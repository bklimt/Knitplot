
#include "model/rectangle.h"
#include "model/renderer.h"

namespace chart_model {

Rectangle::Rectangle() : width_(0), height_(0) {
  top_left_.AddListener(this);
}

void Rectangle::set_width(double width) {
  width_ = width;
  NotifyChanged(this);
}

void Rectangle::set_height(double height) {
  height_ = height;
  NotifyChanged(this);
}

void Rectangle::ScaleAndTranslate(double x, double y,
                                  double width, double height) {
  mutable_top_left()->set_x(x + top_left().x() * width);
  mutable_top_left()->set_y(y + top_left().y() * height);
  set_width(width_ * width);
  set_height(height_ * height);
}

bool Rectangle::Contains(double x, double y) const {
  return (x >= top_left().x() &&
          x <= top_left().x() + width() &&
          y >= top_left().y() &&
          y <= top_left().y() + height());
}

void Rectangle::ReadFrom(const chart_proto::Rectangle &rect) {
  top_left_.ReadFrom(rect.top_left());
  width_ = rect.width();
  height_ = rect.height();
  NotifyChanged(this);
}

void Rectangle::WriteTo(chart_proto::Rectangle *rect) const {
  rect->Clear();
  top_left_.WriteTo(rect->mutable_top_left());
  rect->set_width(width_);
  rect->set_height(height_);
}

void Rectangle::WriteShape(chart_proto::Shape *shape) const {
  WriteTo(shape->mutable_rectangle());
}

void Rectangle::Render(const Style &style, Renderer *renderer) const {
  renderer->DrawRectangle(*this, style);
}

}  // namespace chart_model

