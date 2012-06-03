
#include "gui/library_panel.h"
#include "gui/preview_panel.h"
#include "gui/wx_renderer.h"
#include "model/chart.h"

LibraryPanel::LibraryPanel(wxWindow *parent, chart_model::Library *library)
    : wxPanel(parent),
      column_width_(10),
      target_height_(10),
      library_(library) {
  SetMinSize(wxSize(target_height_, column_width_));
}

void LibraryPanel::OnSize(wxSizeEvent &event) {
  Refresh();
}

void LibraryPanel::OnPaint(wxPaintEvent &event) {
  wxPaintDC dc(this);
  OnDraw(dc);
}

void LibraryPanel::OnDraw(wxDC &dc) {
  /*
  wxColour green(0, 255, 0);
  wxBrush brush(green);
  dc.SetBrush(brush);
  dc.DrawRectangle(0, 0, GetSize().GetWidth(), GetSize().GetHeight());
  */

  const int kTargetGraphicHeight = 18;

  int graphic_height = kTargetGraphicHeight;
  int graphic_width = static_cast<int>(graphic_height / 0.75 + 0.5);

  int max_name_width = 0;
  int max_height = graphic_height;
  for (int i = 0; i < library_->GetActionTypeCount(); ++i) {
    wxString name(library_->GetActionType(i).name().c_str(), wxConvUTF8);

    wxCoord width;
    wxCoord height;
    dc.GetTextExtent(name, &width, &height);
    if (width > max_name_width) {
      max_name_width = static_cast<int>(width);
    }
    if (height > max_height) {
      max_height = height;
    }
  }
  max_height += 10;

  column_width_ = max_name_width + graphic_width + 15;
  int columns = static_cast<int>(GetSize().GetWidth() / column_width_);
  if (columns < 1) {
    columns = 1;
  }

  int rows = static_cast<int>(ceil(library_->GetActionTypeCount() /
                                   static_cast<double>(columns)));
  if (rows < 1) {
    rows = 1;
  }
  int row_height = GetSize().GetHeight() / rows;

  if (row_height < graphic_height) {
    graphic_height = row_height;
    graphic_width = static_cast<int>(row_height / 0.75 + 0.5);
  }

  if (row_height > max_height) {
    row_height = max_height;
  }

  for (int column = 0; column < columns; ++column) {
    for (int row = 0; row < rows; ++row) {
      int action_type = column * rows + row;
      if (action_type >= library_->GetActionTypeCount()) {
        continue;
      }

      chart_model::Graphic graphic;
      graphic.ReadFrom(library_->GetActionType(action_type).graphic());

      graphic.ScaleAndTranslate(0, 0, graphic_width, graphic_height);

      wxRenderer shadow_renderer(&dc, column_width_ * column + 7,
                                 row_height * row + 7, true);
      graphic.Render(&shadow_renderer);

      wxRenderer renderer(&dc, column_width_ * column + 5,
                          row_height * row + 5, false);
      graphic.Render(&renderer);

      wxString name(library_->GetActionType(action_type).name().c_str(),
                    wxConvUTF8);
      dc.DrawText(name,
                  column_width_ * column + graphic_width + 10,
                  row_height * row + 5);
    }
  }

  target_height_ = (kTargetGraphicHeight + 10) * rows;
}

void LibraryPanel::OnIdle(wxIdleEvent& WXUNUSED(event)) {
  if (GetSize().GetHeight() != target_height_) {
    SetMinSize(wxSize(column_width_, target_height_));
    GetParent()->Layout();
  }
}

BEGIN_EVENT_TABLE(LibraryPanel, wxPanel)
  EVT_SIZE(LibraryPanel::OnSize)
  EVT_PAINT(LibraryPanel::OnPaint)
  EVT_IDLE(LibraryPanel::OnIdle)
END_EVENT_TABLE()
