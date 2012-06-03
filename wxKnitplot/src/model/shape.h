#ifndef __MODEL_SHAPE_H__
#define __MODEL_SHAPE_H__

#include <vector>

#include "model/shape_base.h"
#include "model/listener.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Renderer;

class Shape : public Listener<ShapeBase>,
              public Listener<Style>,
              public Speaker<Shape> {
 public:
  Shape();
  ~Shape();

  int text_offset() const { return text_offset_; }
  int text_length() const { return text_length_; }
  const Style &style() const { return style_; }

  void set_text_offset(int text_offset);
  void set_text_length(int text_length);
  Style *mutable_style() { return &style_; }

  void ScaleAndTranslate(double x, double y, double width, double height);
  bool Contains(double x, double y) const;

  void ReadFrom(const chart_proto::Shape &shape);
  void WriteTo(chart_proto::Shape *shape) const;

  void Render(Renderer *renderer) const;

  void OnChanged(const Style *style) { NotifyChanged(this); }
  void OnChanged(const ShapeBase *shape) { NotifyChanged(this); }

 private:
  ShapeBase *shape_;

  Style style_;
  int text_offset_;
  int text_length_;
};

} // namespace chart_model

#endif
