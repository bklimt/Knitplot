#ifndef __MODEL_ANCHOR_H__
#define __MODEL_ANCHOR_H__

#include "model/listener.h"
#include "model/point.h"

namespace chart_model {

class Anchor : public Speaker<Anchor>, Listener<Point> {
 public:
  Anchor();

  const Point &point() { return point_; }

  Point *mutable_point() { return &point_; }

 private:
  
};

}  // namespace chart_model

#endif
