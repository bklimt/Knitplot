
#include "model/line.h"
#include "model/renderer.h"

namespace chart_model {

Line::Line() {
  point1_.AddListener(this);
  point2_.AddListener(this);
}

void Line::ScaleAndTranslate(double x, double y,
                             double width, double height) {
  mutable_point1()->set_x(x + point1().x() * width);
  mutable_point1()->set_y(y + point1().y() * height);
  mutable_point2()->set_x(x + point2().x() * width);
  mutable_point2()->set_y(y + point2().y() * height);
}

bool Line::Contains(double x, double y) const {
  return false;
}

void Line::ReadFrom(const chart_proto::Line &line) {
  point1_.ReadFrom(line.point1());
  point2_.ReadFrom(line.point2());
  NotifyChanged(this);
}

void Line::WriteTo(chart_proto::Line *line) const {
  line->Clear();
  point1_.WriteTo(line->mutable_point1());
  point2_.WriteTo(line->mutable_point2());
}

void Line::WriteShape(chart_proto::Shape *shape) const {
  WriteTo(shape->mutable_line());
}

void Line::Render(const Style &style, Renderer *renderer) const {
  renderer->DrawLine(*this, style);
}

}  // namespace chart_model

