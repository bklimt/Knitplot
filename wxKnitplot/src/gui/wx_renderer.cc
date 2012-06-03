
#include "gui/wx_renderer.h"

inline int rnd(double d) {
  return static_cast<int>(d + 0.5);
}

inline int min(int b1, int b2) {
  return b1 < b2 ? b1 : b2;
}

inline int max(int b1, int b2) {
  return b1 > b2 ? b1 : b2;
}

wxRenderer::wxRenderer(wxDC *dc, int x, int y, bool shadow)
    : dc_(dc), x_(x), y_(y), shadow_(shadow) {
}

void wxRenderer::Start(int width, int height) {
}

void wxRenderer::DrawLine(const chart_model::Line &line, const chart_model::Style &style) {
  SetStyle(style);
  dc_->DrawLine(rnd(line.point1().x() + x_),
                rnd(line.point1().y() + y_),
                rnd(line.point2().x() + x_),
                rnd(line.point2().y() + y_));
}

void wxRenderer::DrawRectangle(const chart_model::Rectangle &rect, const chart_model::Style &style) {
  SetStyle(style);
  int right = rnd(rect.top_left().x() + rect.width() + x_);
  int bottom = rnd(rect.top_left().y() + rect.height() + y_);
  int left = rnd(rect.top_left().x() + x_);
  int top = rnd(rect.top_left().y() + y_);
  dc_->DrawRectangle(left, top, right - left, bottom - top);
}

void wxRenderer::DrawCircle(const chart_model::Circle &circle, const chart_model::Style &style) {
  SetStyle(style);
  dc_->DrawCircle(rnd(circle.center().x() + x_),
                  rnd(circle.center().y() + y_),
                  rnd(circle.radius()));
}

void wxRenderer::DrawPolygon(const chart_model::Polygon &polygon, const chart_model::Style &style) {
  SetStyle(style);
  wxPoint *points = new wxPoint[polygon.point_count()];
  for (int j = 0; j < polygon.point_count(); ++j) {
    points[j].x = rnd(polygon.point(j).x() + x_);
    points[j].y = rnd(polygon.point(j).y() + y_);
  }
  dc_->DrawPolygon(polygon.point_count(), points);
  delete[] points;
}

void wxRenderer::DrawSpline(const chart_model::Spline &spline, const chart_model::Style &style) {
  SetStyle(style);
  wxPoint *points = new wxPoint[spline.point_count()];
  for (int j = 0; j < spline.point_count(); ++j) {
    points[j].x = rnd(spline.point(j).x() + x_);
    points[j].y = rnd(spline.point(j).y() + y_);
  }
  dc_->DrawSpline(spline.point_count(), points);
  delete[] points;
}

void wxRenderer::DrawText(const chart_model::Text &text, const chart_model::Style &style) {
  SetStyle(style);
  wxString str(text.text().c_str(), wxConvUTF8);
  dc_->DrawText(str, text.point().x() + x_, text.point().y() + y_);
}

void wxRenderer::End() {
}

void wxRenderer::SetStyle(const chart_model::Style &style) {
  wxColour stroke(shadow_ ? 94 : style.stroke().red(),
                  shadow_ ? 94 : style.stroke().green(),
                  shadow_ ? 94 : style.stroke().blue());

  wxColour fill(shadow_ ? 94 : style.fill().red(),
                shadow_ ? 94 : style.fill().green(),
                shadow_ ? 94 : style.fill().blue());

  wxPen pen(stroke, style.stroke_width());
  dc_->SetPen(pen);

  wxBrush brush(fill);
  dc_->SetBrush(brush);
}

