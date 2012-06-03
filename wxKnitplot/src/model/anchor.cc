
#include "model/anchor.h"

namespace chart_model {

void Anchor::set_x(double x) {
  x_ = x;
  NotifyListeners(this);
}

void Anchor::set_y(double y) {
  y_ = y;
  NotifyListeners(this);
}

}  // namespace chart_model

