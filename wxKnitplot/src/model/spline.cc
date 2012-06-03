
#include "model/spline.h"
#include "model/renderer.h"

namespace chart_model {

void Spline::clear_point() {
  for (int i = 0; i < point_count(); ++i) {
    delete mutable_point(i);
  }
  point_.clear();
}

Point *Spline::add_point() {
  Point *p = new Point();
  p->AddListener(this);
  point_.push_back(p);
  return p;
}

void Spline::ScaleAndTranslate(double x, double y,
                               double width, double height) {
  for (int j = 0; j < point_count(); ++j) {
    Point *point = mutable_point(j);
    point->set_x(x + point->x() * width);
    point->set_y(y + point->y() * height);
  }
}

bool Spline::Contains(double x, double y) const {
  return false;
}

void Spline::ReadFrom(const chart_proto::Spline &spline) {
  for (int i = 0; i < spline.point_size(); ++i) {
    add_point()->ReadFrom(spline.point(i));
  }
  NotifyChanged(this);
}

void Spline::WriteTo(chart_proto::Spline *spline) const {
  spline->Clear();
  for (int i = 0; i < point_count(); ++i) {
    point(i).WriteTo(spline->add_point());
  }
}

void Spline::WriteShape(chart_proto::Shape *shape) const {
  WriteTo(shape->mutable_spline());
}

void Spline::Render(const Style &style, Renderer *renderer) const {
  renderer->DrawSpline(*this, style);
}

}  // namespace chart_model

