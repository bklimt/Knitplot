
#include "model/point.h"

namespace chart_model {

Point::Point() : x_(0), y_(0) {
}

void Point::set_x(double x) {
  double old_x = x_;
  x_ = x;
  PointChangedEvent event(this, old_x, y_);
  NotifyChanged(&event);
}

void Point::set_y(double y) {
  double old_y = y_;
  y_ = y;
  PointChangedEvent event(this, x_, old_y);
  NotifyChanged(&event);
}

void Point::ReadFrom(const chart_proto::Point &point) {
  double old_x = x_;
  double old_y = y_;
  x_ = static_cast<double>(point.x());
  y_ = static_cast<double>(point.y());
  PointChangedEvent event(this, old_x, old_y);
  NotifyChanged(&event);
}

void Point::WriteTo(chart_proto::Point *point) const {
  point->Clear();
  point->set_x(static_cast<float>(x_));
  point->set_y(static_cast<float>(y_));
}

}  // namespace chart_model

