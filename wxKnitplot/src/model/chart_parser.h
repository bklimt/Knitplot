#ifndef __MODEL_CHART_PARSER_H__
#define __MODEL_CHART_PARSER_H__

#include <string>
#include <vector>

#include "model/library.h"
#include "storage/chart.pb.h"

namespace chart_model {

enum ChartParserMessageType { kChartParserError, kChartParserWarning };

struct ChartParserMessage {
 public:
  ChartParserMessageType type;
  std::string message;
  int offset;
  int line;
  int column;
  int length;
};

class ChartParser {
 public:
  ChartParser();

  void Parse(const std::string &text,
             const Library &library,
             chart_proto::Chart *chart);

  int GetMessageCount() const { return messages_.size(); }
  const ChartParserMessage &GetMessage(int i) const { return messages_[i]; }

 private:
  ChartParser(const ChartParser &other) {}  // block auto copy ctor

  void EatWhitespace();
  bool ParseAction(chart_proto::Row *row);
  bool ParseRow(chart_proto::Row *row);
  bool ParseChart(chart_proto::Chart *chart);

  void AddMessage(ChartParserMessageType type, const std::string &message);

 private:
  std::string text_;
  Library library_;

  int line_;          // line of text parser is currently processing
  int offset_;        // offset in the text where parser is currently processing
  int line_start_;    // offset of the start of the line parser is on
  int token_length_;  // length of the current token

  std::vector<ChartParserMessage> messages_;
};

}  // namespace chart_model

#endif
