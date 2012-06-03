#ifndef __MODEL_GRAPHIC_H__
#define __MODEL_GRAPHIC_H__

#include <vector>

#include "model/point.h"
#include "model/listener.h"
#include "model/shape.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Renderer;

class Graphic : public Listener<Shape>, public Speaker<Graphic> {
 public:
  Graphic();
  ~Graphic();

  int shape_count() const { return shape_.size(); }
  const Shape &shape(int i) const { return *(shape_[i]); }

  double width() const { return width_; }
  double height() const { return height_; }

  Shape *mutable_shape(int i) { return shape_[i]; }
  Shape *add_shape();
  void clear_shape();

  void set_width(double width);
  void set_height(double height);

  void ScaleAndTranslate(double x, double y, double width, double height);
  const Shape *GetShapeAt(double x, double y) const;

  void ReadFrom(const chart_proto::Graphic &graphic);
  void WriteTo(chart_proto::Graphic *graphic) const;

  void Render(Renderer *renderer) const;

  void OnChanged(const Shape *shape) { NotifyChanged(this); }

 private:
  std::vector<Shape*> shape_;
  double width_;
  double height_;
};

}  // namespace chart_model

#endif
