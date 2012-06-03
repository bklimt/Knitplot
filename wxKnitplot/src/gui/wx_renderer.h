#ifndef __GUI_WX_RENDERER_H__
#define __GUI_WX_RENDERER_H__

#include <wx/wx.h>

#include "model/renderer.h"

class wxRenderer : public chart_model::Renderer {
 public:
  wxRenderer(wxDC *dc, int x, int y, bool shadow);

  void Start(int width, int height);
  void DrawLine(const chart_model::Line &line, const chart_model::Style &style);
  void DrawRectangle(const chart_model::Rectangle &rect, const chart_model::Style &style);
  void DrawCircle(const chart_model::Circle &circle, const chart_model::Style &style);
  void DrawPolygon(const chart_model::Polygon &polygon, const chart_model::Style &style);
  void DrawSpline(const chart_model::Spline& spline, const chart_model::Style &style);
  void DrawText(const chart_model::Text &text, const chart_model::Style &style);
  void End();

 private:
  void SetStyle(const chart_model::Style &style);

  wxDC *dc_;
  double x_;
  double y_;
  bool shadow_;
};

#endif
