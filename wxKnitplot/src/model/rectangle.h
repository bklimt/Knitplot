
#ifndef __MODEL_RECTANGLE_H__
#define __MODEL_RECTANGLE_H__

#include "model/shape_base.h"
#include "model/listener.h"
#include "model/point.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Rectangle : public ShapeBase, public Listener<PointChangedEvent> {
 public:
  Rectangle();

  const Point &top_left() const { return top_left_; }
  double width() const { return width_; }
  double height() const { return height_; }
 
  Point *mutable_top_left() { return &top_left_; }
  void set_width(double width);
  void set_height(double height);

  void ScaleAndTranslate(double x, double y, double width, double height);
  bool Contains(double x, double y) const;

  void ReadFrom(const chart_proto::Rectangle &rect);
  void WriteTo(chart_proto::Rectangle *rect) const;
  void WriteShape(chart_proto::Shape *shape) const;

  void Render(const Style &style, Renderer *renderer) const;

  void OnChanged(const PointChangedEvent *event) { NotifyChanged(this); }

 private:
  Rectangle(const Rectangle &other) {}

  Point top_left_;
  double width_;
  double height_;
};


} // namespace chart_model

#endif
