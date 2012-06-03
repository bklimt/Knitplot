#ifndef __SHAPE_BASE_H__
#define __SHAPE_BASE_H__

#include "model/listener.h"
#include "model/style.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Renderer;

class ShapeBase : public Speaker<ShapeBase> {
 public:
  virtual ~ShapeBase() {}

  virtual void ScaleAndTranslate(double x, double y,
                                 double width, double height) = 0;

  virtual bool Contains(double x, double y) const = 0;

  virtual void WriteShape(chart_proto::Shape *shape) const = 0;

  virtual void Render(const Style &style, Renderer *renderer) const = 0;

 protected:
  ShapeBase() {}

 private:
  ShapeBase(const ShapeBase &other) {}
};

} // namespace chart_model

#endif
