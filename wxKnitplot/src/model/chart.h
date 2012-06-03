#ifndef __MODEL_CHART_H__
#define __MODEL_CHART_H__

#include <string>
#include <vector>

#include "model/chart_listener.h"
#include "model/chart_parser.h"
#include "model/graphic.h"
#include "model/library.h"
#include "storage/chart.pb.h"

namespace chart_model {

struct ChartSelection {
 public:
  ChartSelection() : start(0), length(0) {}
  ChartSelection(int s, int l) : start(s), length(l) {}

  int start;
  int length;
};

class Chart {
 public:
  Chart(const Library &library);

  Chart(const Chart &other);

  std::string GetText() const {
    return text_;
  }

  Library *GetLibrary() {
    return &library_;
  }

  bool IsModified() const {
    return modified_;
  }

  int GetParserMessageCount() const { return parser_.GetMessageCount(); }

  const ChartParserMessage &GetParserMessage(int i) {
    return parser_.GetMessage(i);
  }

  const ChartSelection &GetSelection() {
    return selection_;
  }

  bool ParseText(const char *text);

  void SelectText(int start, int length);

  bool GetGraphic(double max_width, double max_height,
                  bool show_selection,
                  Graphic *graphic, std::string *error) const;

  bool LoadFromFile(const char *filename, std::string *error);
  bool SaveToFile(const char *filename, std::string *error);

  bool ExportToSVG(const char *filename, int max_width, int max_height,
                   std::string *error) const;

  void AddListener(ChartListener *listener);

 private:
  void OnChartChanged();

  void OnSelect();

 private:
  Library library_;
  std::string text_;
  chart_proto::Chart chart_;

  bool modified_;

  ChartSelection selection_;

  ChartParser parser_;

  std::vector<ChartListener*> listeners_;
};

}  // namespace chart_model

#endif
