
#ifndef __MODEL_POLYGON_H__
#define __MODEL_POLYGON_H__

#include <vector>

#include "model/shape_base.h"
#include "model/listener.h"
#include "model/point.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Polygon : public ShapeBase, public Listener<PointChangedEvent> {
 public:
  Polygon() {}

  ~Polygon() { clear_point(); }

  int point_count() const { return point_.size(); }
  const Point &point(int i) const { return *(point_[i]); }

  Point *mutable_point(int i) { return point_[i]; }
  void clear_point();
  Point *add_point();

  void ScaleAndTranslate(double x, double y, double width, double height);
  bool Contains(double x, double y) const;

  void ReadFrom(const chart_proto::Polygon &polygon);
  void WriteTo(chart_proto::Polygon *polygon) const;
  void WriteShape(chart_proto::Shape *shape) const;

  void Render(const Style &style, Renderer *renderer) const;

  void OnChanged(const PointChangedEvent *event) { NotifyChanged(this); }

 private:
  Polygon(const Polygon &other) {}

  std::vector<Point*> point_;
};

} // namespace chart_model

#endif
