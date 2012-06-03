#ifndef __MODEL_TEXT_H__
#define __MODEL_TEXT_H__

#include <string>

#include "model/shape_base.h"
#include "model/listener.h"
#include "model/point.h"
#include "storage/chart.pb.h"

namespace chart_model {

class Text : public ShapeBase,
             public Listener<PointChangedEvent> {
 public:
  Text();

  const Point &point() const { return point_; }
  const std::string &text() const { return text_; }

  Point *mutable_point() { return &point_; }
  void set_text(const std::string &other);

  void ScaleAndTranslate(double x, double y, double width, double height);
  bool Contains(double x, double y) const;

  void ReadFrom(const chart_proto::Text &text);
  void WriteTo(chart_proto::Text *text) const;
  void WriteShape(chart_proto::Shape *shape) const;

  void Render(const Style &style, Renderer *renderer) const;

  void OnChanged(const PointChangedEvent *event) { NotifyChanged(this); }

 private:
  Text(const Text &other) {}

  Point point_;
  std::string text_;
};

} // namespace chart_model

#endif
