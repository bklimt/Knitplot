
#include "model/shape.h"
#include "model/line.h"
#include "model/rectangle.h"
#include "model/circle.h"
#include "model/polygon.h"
#include "model/spline.h"
#include "model/text.h"

namespace chart_model {

Shape::Shape() : shape_(NULL), text_offset_(0), text_length_(0) {
  style_.AddListener(this);
}

Shape::~Shape() {
  if (shape_ != NULL) {
    delete shape_;
  }
}

void Shape::set_text_offset(int text_offset) {
  text_offset_ = text_offset;
  NotifyChanged(this);
}

void Shape::set_text_length(int text_length) {
  text_length_ = text_length;
  NotifyChanged(this);
}

void Shape::ScaleAndTranslate(double x, double y,
                              double width, double height) {
  if (shape_ != NULL) {
    shape_->ScaleAndTranslate(x, y, width, height);
  }
}

bool Shape::Contains(double x, double y) const {
  if (shape_ != NULL) {
    return shape_->Contains(x, y);
  }
  return false;
}

void Shape::ReadFrom(const chart_proto::Shape &shape) {
  if (shape_ != NULL) {
    delete shape_;
  }
  if (shape.has_line()) {
    Line *line = new Line();
    line->ReadFrom(shape.line());
    shape_ = line;
  }
  if (shape.has_rectangle()) {
    Rectangle *rect = new Rectangle();
    rect->ReadFrom(shape.rectangle());
    shape_ = rect;
  }
  if (shape.has_circle()) {
    Circle *circle = new Circle();
    circle->ReadFrom(shape.circle());
    shape_ = circle;
  }
  if (shape.has_polygon()) {
    Polygon *polygon = new Polygon();
    polygon->ReadFrom(shape.polygon());
    shape_ = polygon;
  }
  if (shape.has_spline()) {
    Spline *spline = new Spline();
    spline->ReadFrom(shape.spline());
    shape_ = spline;
  }
  if (shape.has_text()) {
    Text *text = new Text();
    text->ReadFrom(shape.text());
    shape_ = text;
  }
  if (shape_ != NULL) {
    shape_->AddListener(this);
  }
  style_.ReadFrom(shape.style());
  text_offset_ = shape.text_offset();
  text_length_ = shape.text_length();
  NotifyChanged(this);
}

void Shape::WriteTo(chart_proto::Shape *shape) const {
  shape->Clear();
  if (shape_ != NULL) {
    shape_->WriteShape(shape);
  }
  style_.WriteTo(shape->mutable_style());
  shape->set_text_offset(text_offset_);
  shape->set_text_length(text_length_);
}

void Shape::Render(Renderer *renderer) const {
  if (shape_ != NULL) {
    shape_->Render(style_, renderer);
  }
}

}  // namespace chart_model

