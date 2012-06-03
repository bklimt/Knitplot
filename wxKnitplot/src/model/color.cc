
#include "model/color.h"

namespace chart_model {

typedef ::google::protobuf::int32 int32;

Color::Color() : red_(0), green_(0), blue_(0) {
}

void Color::ReadFrom(const chart_proto::Color &color) {
  red_ = static_cast<unsigned char>(color.red());
  green_ = static_cast<unsigned char>(color.green());
  blue_ = static_cast<unsigned char>(color.blue());
  NotifyChanged(this);
}

void Color::WriteTo(chart_proto::Color *color) const {
  color->Clear();
  color->set_red(static_cast<int32>(red_));
  color->set_green(static_cast<int32>(green_));
  color->set_blue(static_cast<int32>(blue_));
}

void Color::set_red(unsigned char red) {
  red_ = red;
  NotifyChanged(this);
}

void Color::set_green(unsigned char green) {
  green_ = green;
  NotifyChanged(this);
}

void Color::set_blue(unsigned char blue) {
  blue_ = blue;
  NotifyChanged(this);
}

}  // namespace chart_model
