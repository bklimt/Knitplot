#ifndef __MODEL_CHART_LISTENER_H__
#define __MODEL_CHART_LISTENER_H__

#include <string>

class ChartListener {
 public:
  virtual ~ChartListener() {}

  virtual void OnChartChanged() = 0;

  virtual void OnSelect() = 0;
};

#endif
