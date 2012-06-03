
#include <fstream>

#include "model/chart.h"
#include "model/chart_parser.h"
#include "model/svg.h"

inline int rnd(double d) {
  return static_cast<int>(d + 0.5);
}

inline int min(int b1, int b2) {
  return b1 < b2 ? b1 : b2;
}

inline int max(int b1, int b2) {
  return b1 > b2 ? b1 : b2;
}

namespace chart_model {

Chart::Chart(const Library &library) : library_(library), modified_(false) {
}

Chart::Chart(const Chart &other)
    : library_(other.library_),
      text_(other.text_),
      modified_(other.modified_) {
  chart_.CopyFrom(other.chart_);
}

bool Chart::ParseText(const char *text) {
  modified_ = true;
  text_ = text;
  parser_.Parse(text, library_, &chart_);
  OnChartChanged();
  return true;
}

void Chart::SelectText(int start, int length) {
  if (start != selection_.start || length != selection_.length) {
    selection_.start = start;
    selection_.length = length;
    OnSelect();
  }
}

bool Chart::GetGraphic(double max_width, double max_height,
                       bool show_selection,
                       Graphic *graphic,
                       std::string *error) const {
  // Figure out how many columns there are.
  int columns = 1;
  for (int row = 0; row < chart_.row_size(); ++row) {
    int column = 0;
    for (int action_index = 0;
         action_index < chart_.row(row).action_size();
         ++action_index) {
      const chart_proto::Action &action = chart_.row(row).action(action_index);
      column += (action.width() * action.repetitions());
    }
    if (column > columns) {
      columns = column;
    }
  }
  int rows = chart_.row_size();

  double width = max_width;
  double column_width = width / columns;
  double row_height = column_width * 0.75;
  double height = row_height * rows;
  if (height > max_height) {
    height = max_height;
    row_height = height / rows;
    column_width = row_height / 0.75;
    width = column_width * columns;
  }

  graphic->clear_shape();
  graphic->set_width(width);
  graphic->set_height(height);

  for (int row = 0; row < chart_.row_size(); ++row) {
    int column = 0;
    for (int action_index = 0;
         action_index < chart_.row(row).action_size();
         ++action_index) {
      const chart_proto::Action &action = chart_.row(row).action(action_index);

      chart_proto::ActionType type;
      if (!library_.FindActionType(action.action().c_str(), &type)) {
        *error = (std::string)"Unknown action: " + action.action();
        return false;
      }

      for (int rep = 0; rep < action.repetitions(); ++rep) {
        for (int shape = 0; shape < type.graphic().shape_size(); ++shape) {
          Shape *new_shape = graphic->add_shape();
          new_shape->ReadFrom(type.graphic().shape(shape));
          new_shape->set_text_offset(action.text_offset());
          new_shape->set_text_length(action.text_length());

          // Highlight it if it's selected.
          if (show_selection) {
            int overlap_start = max(new_shape->text_offset(), selection_.start);
            int overlap_end =
                min(new_shape->text_offset() + new_shape->text_length(),
                    selection_.start + selection_.length);
            if (overlap_end > overlap_start) {
              if (overlap_end - overlap_start < new_shape->text_length()) {
                new_shape->mutable_style()->mutable_stroke()->set_red(
                    rnd(new_shape->style().stroke().red() * 0.75));
                new_shape->mutable_style()->mutable_stroke()->set_green(
                    rnd(new_shape->style().stroke().green() * 0.75));
                new_shape->mutable_style()->mutable_fill()->set_red(
                    rnd(new_shape->style().fill().red() * 0.75));
                new_shape->mutable_style()->mutable_fill()->set_green(
                    rnd(new_shape->style().fill().green() * 0.75));
              } else {
                new_shape->mutable_style()->mutable_stroke()->set_red(
                    rnd(new_shape->style().stroke().red() * 0.5));
                new_shape->mutable_style()->mutable_stroke()->set_green(
                    rnd(new_shape->style().stroke().green() * 0.5));
                new_shape->mutable_style()->mutable_fill()->set_red(
                    rnd(new_shape->style().fill().red() * 0.5));
                new_shape->mutable_style()->mutable_fill()->set_green(
                    rnd(new_shape->style().fill().green() * 0.5));
              }
            } else if (overlap_end == overlap_start) {
                new_shape->mutable_style()->mutable_stroke()->set_red(
                    rnd(new_shape->style().stroke().red() * 0.25));
                new_shape->mutable_style()->mutable_stroke()->set_blue(
                    rnd(new_shape->style().stroke().blue() * 0.25));
                new_shape->mutable_style()->mutable_fill()->set_red(
                    rnd(new_shape->style().fill().red() * 0.25));
                new_shape->mutable_style()->mutable_fill()->set_blue(
                    rnd(new_shape->style().fill().blue() * 0.25));
            }
          }

          new_shape->ScaleAndTranslate(
              (columns - (column + action.width())) * column_width,
              (rows - (row + 1)) * row_height,
              action.width() * column_width,
              1 * row_height);
        }
        column += action.width();
      }
    }
  }
  return true;
}

bool Chart::LoadFromFile(const char *filename, std::string *error) {
  std::fstream file(filename, std::ios::in | std::ios::binary);
  if (!file.good()) {
    *error = "Unable to open chart file ";
    error->append(filename);
    error->append(".");
    return false;
  }
  chart_proto::ChartFile chart_file;
  if (!chart_file.ParseFromIstream(&file)) {
    *error = "The chart file appears to be corrupted.";
    return false;
  }
  library_.CopyFrom(chart_file.library());
  ParseText(chart_file.text().c_str());
  modified_ = false;
  return true;
}

bool Chart::SaveToFile(const char *filename, std::string *error) {
  chart_proto::ChartFile chart_file;
  chart_file.set_text(text_);
  library_.CopyTo(chart_file.mutable_library());

  std::fstream file(filename, std::ios::out | std::ios::trunc | std::ios::binary);
  if (!chart_file.SerializeToOstream(&file)) {
    *error = "Unable to save chart to file.";
    return false;
  }
  modified_ = false;
  return true;
}

bool Chart::ExportToSVG(const char *filename, int max_width, int max_height,
                        std::string *error) const {
  std::fstream file(filename, std::ios::out | std::ios::trunc | std::ios::binary);
  if (!file.good()) {
    *error = "Unable to save svg file.";
    return false;
  }

  Graphic graphic;
  if (!GetGraphic(max_width, max_height, false, &graphic, error)) {
    return false;
  }

  SVGRenderer svg;
  graphic.Render(&svg);
  file << svg.OutputAsString();

  return true;
}

void Chart::AddListener(ChartListener *listener) {
  listeners_.push_back(listener);
}

void Chart::OnChartChanged() {
  static bool in_on_chart_changed = false;
  if (in_on_chart_changed) {
    return;
  }

  in_on_chart_changed = true;
  for (unsigned int i = 0; i < listeners_.size(); ++i) {
    listeners_[i]->OnChartChanged();
  }
  in_on_chart_changed = false;
}

void Chart::OnSelect() {
  static bool in_on_select = false;
  if (in_on_select) {
    return;
  }

  in_on_select = true;
  for (unsigned int i = 0; i < listeners_.size(); ++i) {
    listeners_[i]->OnSelect();
  }
  in_on_select = false;
}

}  // namespace chart_model
