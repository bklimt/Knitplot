#ifndef __MODEL_LINE_H__
#define __MODEL_LINE_H__

#include "model/shape_base.h"
#include "model/listener.h"
#include "model/point.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Line : public ShapeBase,
             public Listener<PointChangedEvent> {
 public:
  Line();

  const Point &point1() const { return point1_; }
  const Point &point2() const { return point2_; }

  Point *mutable_point1() { return &point1_; }
  Point *mutable_point2() { return &point2_; }

  void ScaleAndTranslate(double x, double y, double width, double height);
  bool Contains(double x, double y) const;

  void ReadFrom(const chart_proto::Line &line);
  void WriteTo(chart_proto::Line *line) const;
  void WriteShape(chart_proto::Shape *shape) const;

  void Render(const Style &style, Renderer *renderer) const;

  void OnChanged(const PointChangedEvent *event) { NotifyChanged(this); }

 private:
  Line(const Line &other) {}

  Point point1_;
  Point point2_;
};

} // namespace chart_model

#endif
