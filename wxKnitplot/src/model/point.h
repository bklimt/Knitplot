#ifndef __MODEL_POINT_H__
#define __MODEL_POINT_H__

#include "model/listener.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Point;

class PointChangedEvent {
 public:
  PointChangedEvent(const Point *source, double old_x, double old_y)
      : source_(source), old_x_(old_x), old_y_(old_y) {}

  const Point *source() const { return source_; }
  double old_x() const { return old_x_; }
  double old_y() const { return old_y_; }

 private:
  const Point *source_;
  double old_x_;
  double old_y_;
};

class Point : public Speaker<PointChangedEvent> {
 public:
  Point();

  double x() const { return x_; }
  double y() const { return y_; }

  void set_x(double x);
  void set_y(double y);

  void ReadFrom(const chart_proto::Point &point);
  void WriteTo(chart_proto::Point *point) const;

 private:
  Point(const Point &other) {}

  double x_;
  double y_;
};

}  // namespace chart_model

#endif
