
#include "gui/preview_panel.h"
#include "gui/wx_renderer.h"
#include "model/renderer.h"

inline int rnd(double d) {
  return static_cast<int>(d + 0.5);
}

inline int min(int b1, int b2) {
  return b1 < b2 ? b1 : b2;
}

inline int max(int b1, int b2) {
  return b1 > b2 ? b1 : b2;
}

PreviewPanel::PreviewPanel(wxWindow *parent, chart_model::Chart *chart)
    : wxScrolledWindow(parent),
      chart_(chart),
      selecting_(false) {
  chart->AddListener(this);
  OnChartChanged();
}

void PreviewPanel::OnChartChanged() {
  std::string error;
  if (chart_->GetGraphic(GetSize().GetWidth() - 30,
                         GetSize().GetHeight() - 30,
                         true,
                         &graphic_, &error)) {
    if (graphic_.width() > 0 &&
        graphic_.height() > 0) {
      SetScrollRate(10, 10);
      SetVirtualSize(rnd(graphic_.width()), rnd(graphic_.height()));
    }
  }

  Refresh();
  Update();
}

void PreviewPanel::OnSelect() {
  OnChartChanged();
}

const chart_model::Shape *PreviewPanel::GetShapeAt(wxCoord x, wxCoord y) {
  double x_offset = (GetSize().GetWidth() - graphic_.width()) / 2.0;
  double y_offset = (GetSize().GetHeight() - graphic_.height()) / 2.0;

  return graphic_.GetShapeAt(static_cast<double>(x - x_offset),
                             static_cast<double>(y - y_offset));
}

void PreviewPanel::OnLeftDown(wxMouseEvent &event) {
  if (event.ShiftDown()) {
    selecting_ = true;
    selection_start_ = chart_->GetSelection().start;
    selection_end_ = chart_->GetSelection().start +
                     chart_->GetSelection().length;
  } else {
    const chart_model::Shape *target = GetShapeAt(event.GetX(), event.GetY());
    if (target != NULL) {
      selecting_ = true;
      selection_start_ = target->text_offset();
      selection_end_ = target->text_offset() + target->text_length();
    }
  }
}

void PreviewPanel::OnMotion(wxMouseEvent &event) {
  if (selecting_) {
    const chart_model::Shape *target = GetShapeAt(event.GetX(), event.GetY());
    if (target != NULL) {
      int start = min(selection_start_, target->text_offset());
      int end = max(selection_end_,
                    target->text_offset() + target->text_length());
      chart_->SelectText(start, end - start);
    }
  }
}

void PreviewPanel::OnLeftUp(wxMouseEvent &event) {
  if (selecting_) {
    selecting_ = false;
    const chart_model::Shape *target = GetShapeAt(event.GetX(), event.GetY());
    if (target != NULL) {
      int start = min(selection_start_, target->text_offset());
      int end = max(selection_end_,
                    target->text_offset() + target->text_length());
      chart_->SelectText(start, end - start);
    }
  }
}

void PreviewPanel::OnSize(wxSizeEvent &event) {
  OnChartChanged();
}

void PreviewPanel::DrawGraphic(wxDC &dc, double x, double y, bool shadow) {
  wxRenderer renderer(&dc, x, y, shadow);
  graphic_.Render(&renderer);
}

void PreviewPanel::OnDraw(wxDC &dc) {
  double x_offset = (GetSize().GetWidth() - graphic_.width()) / 2.0;
  double y_offset = (GetSize().GetHeight() - graphic_.height()) / 2.0;
  DrawGraphic(dc, x_offset + 2, y_offset + 2, true);
  DrawGraphic(dc, x_offset, y_offset, false);
}

BEGIN_EVENT_TABLE(PreviewPanel, wxScrolledWindow)
  EVT_SIZE(PreviewPanel::OnSize)
  EVT_LEFT_UP(PreviewPanel::OnLeftUp)
  EVT_MOTION(PreviewPanel::OnMotion)
  EVT_LEFT_DOWN(PreviewPanel::OnLeftDown)
END_EVENT_TABLE()
