
#include "model/style.h"

namespace chart_model {

Style::Style() : stroke_width_(1) {
  fill_.AddListener(this);
  stroke_.AddListener(this);
}

void Style::ReadFrom(const chart_proto::Style &style) {
  fill_.ReadFrom(style.fill());
  stroke_.ReadFrom(style.stroke());
  stroke_width_ = style.stroke_width();
  NotifyChanged(this);
}

void Style::WriteTo(chart_proto::Style *style) const {
  style->Clear();
  fill_.WriteTo(style->mutable_fill());
  stroke_.WriteTo(style->mutable_stroke());
  style->set_stroke_width(stroke_width_);
}

void Style::set_stroke_width(int stroke_width) {
  stroke_width_ = stroke_width;
  NotifyChanged(this);
}

}  // namespace chart_model

