#ifndef __MODEL_COLOR_H__
#define __MODEL_COLOR_H__

#include "model/listener.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Color : public Speaker<Color> {
 public:
  Color();

  void ReadFrom(const chart_proto::Color &color);
  void WriteTo(chart_proto::Color *color) const;

  unsigned char red() const { return red_; }
  unsigned char green() const { return green_; }
  unsigned char blue() const { return blue_; }

  void set_red(unsigned char red);
  void set_green(unsigned char green);
  void set_blue(unsigned char blue);

 private:
  Color(const Color &other) {}

  unsigned char red_;
  unsigned char green_;
  unsigned char blue_;
};

}  // namespace chart_model

#endif
