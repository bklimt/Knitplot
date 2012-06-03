
#include <cstdio>
#include <fstream>
#include <gflags/gflags.h>
#include <google/protobuf/io/tokenizer.h>
#include <google/protobuf/io/zero_copy_stream_impl.h>
#include <google/protobuf/text_format.h>
#include <string>

#include "storage/chart.pb.h"

using namespace std;

using google::protobuf::TextFormat;
using google::protobuf::io::ErrorCollector;

DEFINE_string(output, "", "name of json file to output to");
DEFINE_string(library, "data/actions.txt", "library file of actions");

class LibraryErrorCollector : public ErrorCollector {
 public:
  void AddError(int line, int column, const std::string &message) {
    if (!error.empty()) {
      error.append("\n");
    }

    char position[1000];
    sprintf(position, " (line: %d, column: %d)", line, column);
    error.append(message + position);
  }

  std::string GetErrorMessage() {
    return error;
  }

 private:
  std::string error;
};

string PointToString(chart_proto::Point point) {
  char result[1024];
  sprintf(result, "[%.2f, %.2f]", point.x(), point.y());
  return result;
}

string ColorToString(chart_proto::Color color) {
  char rgb[20];
  sprintf(rgb, "#%02x%02x%02x", color.red(), color.green(), color.blue());
  return rgb;
}

void PrintLibrary(FILE *out, chart_proto::Library& library) {
  fprintf(out, "Library =\n");
  for (int i = 0; i < library.action_type_size(); ++i) {
    chart_proto::ActionType action = library.action_type(i);
    fprintf(out, "  \"%s\":\n", action.name().c_str());
    if (action.has_width()) {
      fprintf(out, "    width: %d,\n", action.width());
    }
    fprintf(out, "    graphic: [\n");
    for (int j = 0; j < action.graphic().shape_size(); ++j) {
      chart_proto::Shape shape = action.graphic().shape(j);
      if (shape.has_rectangle()) {
        fprintf(out, "      rectangle: { top_left: %s, width: %.2f, height: %.2f }\n",
                PointToString(shape.rectangle().top_left()).c_str(),
                shape.rectangle().width(), shape.rectangle().height());
      }
      if (shape.has_circle()) {
        fprintf(out, "      circle: { center: %s, radius: %.2f }\n",
                PointToString(shape.circle().center()).c_str(),
                shape.circle().radius());
      }
      if (shape.has_line()) {
        fprintf(out, "      line: { point1: %s, point2: %s }\n",
                PointToString(shape.line().point1()).c_str(),
                PointToString(shape.line().point2()).c_str());
      }
      if (shape.has_polygon()) {
        fprintf(out, "      polygon: [\n");
        for (int k = 0; k < shape.polygon().point_size(); ++k) {
          chart_proto::Point point = shape.polygon().point(k);
          fprintf(out, "        %s,\n", PointToString(point).c_str());
        }
        fprintf(out, "      ]\n");
      }
      if (shape.has_spline()) {
        fprintf(out, "      spline: [\n");
        for (int k = 0; k < shape.spline().point_size(); ++k) {
          chart_proto::Point point = shape.spline().point(k);
          fprintf(out, "        %s,\n", PointToString(point).c_str());
        }
        fprintf(out, "      ]\n");
      }
      fprintf(out, "      style:\n");
      fprintf(out, "        fill: \"%s\"\n", ColorToString(shape.style().fill()).c_str());
      fprintf(out, "        stroke: \"%s\"\n", ColorToString(shape.style().stroke()).c_str());
      fprintf(out, "        strokeWidth: %d\n", shape.style().stroke_width());
      if (j != action.graphic().shape_size() - 1) {
        fprintf(out, "    ,\n");
      } else {
        fprintf(out, "    ]\n");
      }
    }
  }
}

int main(int argc, char **argv) {
  google::SetUsageMessage("proto2json");
  google::ParseCommandLineFlags(&argc, &argv, true);

  if (FLAGS_library.empty()) {
    fprintf(stderr, "You must have a library file.\n");
    exit(-1);
  }

  FILE *out;
  if (FLAGS_output.empty()) {
    out = stdout;
  } else {
    out = fopen(FLAGS_output.c_str(), "w");
  }

  // Load the library of available actions.
  std::fstream library_file(FLAGS_library.c_str(), std::ios::in | std::ios::binary);
  if (!library_file.good()) {
    string error = (std::string)"Unable to open library at " + FLAGS_library + ".";
    fprintf(stderr, "%s\n", error.c_str());
    exit(-1);
  }

  TextFormat::Parser parser;
  LibraryErrorCollector error_collector;
  parser.RecordErrorsTo(&error_collector);
  google::protobuf::io::IstreamInputStream library_stream(&library_file);
  chart_proto::Library library;
  if (!parser.Parse(&library_stream, &library)) {
    string error = error_collector.GetErrorMessage();
    fprintf(stderr, "%s\n", error.c_str());
    exit(-1);
  }

  PrintLibrary(out, library);

  fclose(out);
  return 0;
}

