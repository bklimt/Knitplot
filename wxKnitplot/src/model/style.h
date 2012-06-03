#ifndef __MODEL_STYLE_H__
#define __MODEL_STYLE_H__

#include "model/color.h"
#include "model/listener.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Style : public Listener<Color>, public Speaker<Style> {
 public:
  Style();

  void ReadFrom(const chart_proto::Style &style);
  void WriteTo(chart_proto::Style *style) const;

  const Color &fill() const { return fill_; }
  const Color &stroke() const { return stroke_; }
  int stroke_width() const { return stroke_width_; }

  Color *mutable_fill() { return &fill_; }
  Color *mutable_stroke() { return &stroke_; }

  void set_stroke_width(int stroke_width);

  void OnChanged(const Color *color) { NotifyChanged(this); }

 private:
  Style(const Style &other) {}

  Color fill_;
  Color stroke_;
  int stroke_width_;
};

}  // namespace chart_model

#endif
