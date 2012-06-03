#ifndef __MODEL_SVG_H__
#define __MODEL_SVG_H__

#include <string>

#include "model/renderer.h"

namespace chart_model {

class SVGRenderer : public Renderer {
 public:
  SVGRenderer() {}

  void Start(int width, int height);
  void DrawLine(const Line &line, const Style &style);
  void DrawRectangle(const Rectangle &rectangle, const Style &style);
  void DrawCircle(const Circle &circle, const Style &style);
  void DrawPolygon(const Polygon &polygon, const Style &style);
  void DrawSpline(const Spline &spline, const Style &style);
  void DrawText(const Text &text, const Style &style);
  void End();

  std::string OutputAsString() const { return buffer_; }

 private:
  std::string buffer_;
};

}  // namespace chart_model

#endif
