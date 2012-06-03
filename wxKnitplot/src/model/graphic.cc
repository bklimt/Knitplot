
#include "model/graphic.h"
#include "model/renderer.h"

namespace chart_model {

Graphic::Graphic() : width_(1.0), height_(1.0) {
}

Graphic::~Graphic() {
  clear_shape();
}

Shape *Graphic::add_shape() {
  Shape *shape = new Shape();
  shape->AddListener(this);
  shape_.push_back(shape);
  NotifyChanged(this);
  return shape;
}

void Graphic::clear_shape() {
  for (int i = 0; i < shape_count(); ++i) {
    delete mutable_shape(i);
  }
  shape_.clear();
  NotifyChanged(this);
}

void Graphic::set_width(double width) {
  width_ = width;
  NotifyChanged(this);
}

void Graphic::set_height(double height) {
  height_ = height;
  NotifyChanged(this);
}

void Graphic::ScaleAndTranslate(double x, double y,
                                double width, double height) {
  for (int i = 0; i < shape_count(); ++i) {
    mutable_shape(i)->ScaleAndTranslate(x, y, width, height);
  }
}

const Shape *Graphic::GetShapeAt(double x, double y) const {
  for (int i = shape_count() - 1; i >= 0; --i) {
    if (shape(i).Contains(x, y)) {
      return &(shape(i));
    }
  }
  return NULL;
}

void Graphic::ReadFrom(const chart_proto::Graphic &graphic) {
  width_ = graphic.width();
  height_ = graphic.height();
  for (int i = 0; i < graphic.shape_size(); ++i) {
    add_shape()->ReadFrom(graphic.shape(i));
  }
  NotifyChanged(this);
}

void Graphic::WriteTo(chart_proto::Graphic *graphic) const {
  graphic->Clear();
  graphic->set_width(width_);
  graphic->set_height(height_);
  for (int i = 0; i < shape_count(); ++i) {
    shape(i).WriteTo(graphic->add_shape());
  }
}

void Graphic::Render(Renderer *renderer) const {
  renderer->Start(width(), height());
  for (int i = 0; i < shape_count(); ++i) {
    shape(i).Render(renderer);
  }
  renderer->End();
}

}  // namespace chart_model

