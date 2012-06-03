
#include "model/text.h"
#include "model/renderer.h"

namespace chart_model {

Text::Text() {
  point_.AddListener(this);
}

void Text::set_text(const std::string &other) {
  text_ = other;
  NotifyChanged(this);
}

void Text::ScaleAndTranslate(double x, double y,
                             double width, double height) {
  mutable_point()->set_x(x + point().x() * width);
  mutable_point()->set_y(y + point().y() * height);
}

bool Text::Contains(double x, double y) const {
  return false;
}

void Text::ReadFrom(const chart_proto::Text &text) {
  point_.ReadFrom(text.point());
  text_ = text.text();
  NotifyChanged(this);
}

void Text::WriteTo(chart_proto::Text *text) const {
  text->Clear();
  point_.WriteTo(text->mutable_point());
}

void Text::WriteShape(chart_proto::Shape *shape) const {
  WriteTo(shape->mutable_text());
}

void Text::Render(const Style &style, Renderer *renderer) const {
  renderer->DrawText(*this, style);
}

}  // namespace chart_model

