#ifndef __MODEL_CIRCLE_H__
#define __MODEL_CIRCLE_H__

#include "model/shape_base.h"
#include "model/listener.h"
#include "model/point.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Circle : public ShapeBase, public Listener<PointChangedEvent> {
 public:
  Circle();

  const Point &center() const { return center_; }
  double radius() const { return radius_; }

  Point *mutable_center() { return &center_; }
  void set_radius(double r);

  void ScaleAndTranslate(double x, double y, double width, double height);
  bool Contains(double x, double y) const;

  void ReadFrom(const chart_proto::Circle &circle);
  void WriteTo(chart_proto::Circle *circle) const;
  void WriteShape(chart_proto::Shape *shape) const;

  void Render(const Style &style, Renderer *renderer) const;

  void OnChanged(const PointChangedEvent *event) { NotifyChanged(this); }

 private:
  Circle(const Circle &other) {}

  Point center_;
  double radius_;
};

} // namespace chart_model

#endif
