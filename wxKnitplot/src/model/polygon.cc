
#include "model/polygon.h"
#include "model/renderer.h"

namespace chart_model {

void Polygon::clear_point() {
  for (int i = 0; i < point_count(); ++i) {
    delete mutable_point(i);
  }
  point_.clear();
}

Point *Polygon::add_point() {
  Point *p = new Point();
  p->AddListener(this);
  point_.push_back(p);
  return p;
}

void Polygon::ScaleAndTranslate(double x, double y,
                                double width, double height) {
  for (int j = 0; j < point_count(); ++j) {
    Point *point = mutable_point(j);
    point->set_x(x + point->x() * width);
    point->set_y(y + point->y() * height);
  }
}

bool Polygon::Contains(double x, double y) const {
  return false;
}

void Polygon::ReadFrom(const chart_proto::Polygon &polygon) {
  for (int i = 0; i < polygon.point_size(); ++i) {
    add_point()->ReadFrom(polygon.point(i));
  }
  NotifyChanged(this);
}

void Polygon::WriteTo(chart_proto::Polygon *polygon) const {
  polygon->Clear();
  for (int i = 0; i < point_count(); ++i) {
    point(i).WriteTo(polygon->add_point());
  }
}

void Polygon::WriteShape(chart_proto::Shape *shape) const {
  WriteTo(shape->mutable_polygon());
}

void Polygon::Render(const Style &style, Renderer *renderer) const {
  renderer->DrawPolygon(*this, style);
}

}  // namespace chart_model

