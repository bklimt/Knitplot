
#include "model/circle.h"
#include "model/renderer.h"

namespace chart_model {

Circle::Circle() : radius_(0) {
  center_.AddListener(this);
}

void Circle::set_radius(double r) {
  radius_ = r;
  NotifyChanged(this);
}

void Circle::ScaleAndTranslate(double x, double y,
                               double width, double height) {
  mutable_center()->set_x(x + center().x() * width);
  mutable_center()->set_y(y + center().y() * height);
  set_radius(radius() * height);
}

bool Circle::Contains(double x, double y) const {
  return false;
}

void Circle::ReadFrom(const chart_proto::Circle &circle) {
  center_.ReadFrom(circle.center());
  radius_ = circle.radius();
  NotifyChanged(this);
}

void Circle::WriteShape(chart_proto::Shape *shape) const {
  WriteTo(shape->mutable_circle());
}

void Circle::WriteTo(chart_proto::Circle *circle) const {
  circle->Clear();
  center_.WriteTo(circle->mutable_center());
  circle->set_radius(radius_);
}

void Circle::Render(const Style &style, Renderer *renderer) const {
  renderer->DrawCircle(*this, style);
}

}  // namespace chart_model

