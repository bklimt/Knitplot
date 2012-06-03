
#include <string>

#include "model/chart_parser.h"

namespace chart_model {

ChartParser::ChartParser() {
  // Verify that the version of the library that we linked against is
  // compatible with the version of the headers we compiled against.
  GOOGLE_PROTOBUF_VERIFY_VERSION;
}

void ChartParser::Parse(const std::string &text,
                        const Library &library,
                        chart_proto::Chart *chart) {
  text_ = text;
  library_ = library;
  line_ = 0;
  line_start_ = 0;
  token_length_ = 1;
  offset_ = 0;
  messages_.clear();
  ParseChart(chart);
}

void ChartParser::EatWhitespace() {
  token_length_ = 0;
  while (text_[offset_] &&
         text_[offset_] == ' ' ||
         text_[offset_] == '\r' ||
         text_[offset_] == '\t') {
    ++offset_;
  }
}

// Reads an action from text and puts in in the row.
bool ChartParser::ParseAction(chart_proto::Row *row) {
  // First, get the string for the action.
  EatWhitespace();
  int action_start = offset_;
  while (text_[offset_] &&
         text_[offset_] != ' ' &&
         text_[offset_] != '\r' &&
         text_[offset_] != '\t' &&
         text_[offset_] != '\n' &&
         text_[offset_] != ',') {
    ++offset_;
    ++token_length_;
  }
  if (token_length_ == 0) {
    if (!text_[offset_] || text_[offset_] == '\r' || text_[offset_] == '\n') {
      // It's just a stray comma at the end of a line.
      return true;
    } else {
      AddMessage(kChartParserWarning, "Missing action.");
      return true;
    }
  }
  std::string action_text = text_.substr(action_start, token_length_);
  chart_proto::Action action;

  // First, see if we can strip a number off the end.
  int number_length = 0;
  for (int i = action_text.size() - 1; i >= 0; --i) {
    if (action_text[i] < '0' || action_text[i] > '9') {
      break;
    }
    ++number_length;
  }
  if (number_length > 0) {
    action.set_repetitions(atoi(action_text.substr(action_text.size() -
                                number_length).c_str()));
    action_text = action_text.substr(0, action_text.size() - number_length);
  }

  // See if it has an entry in the library.
  if (!library_.FindAction(action_text.c_str(), &action)) {
    std::string error = (std::string)"Unknown action type: \"" +
                        action_text + "\"";
    AddMessage(kChartParserError, error);
    action.set_action("error");
    action.set_width(1);
  }
  action.set_text_offset(offset_ - token_length_);
  action.set_text_length(token_length_);
  row->add_action()->CopyFrom(action);
  return true;
}

bool ChartParser::ParseRow(chart_proto::Row *row) {
  EatWhitespace();
  if (!text_[offset_] || text_[offset_] == '\n') {
    // AddMessage(kChartParserWarning, "Empty row.");
    return true;
  }
  if (!ParseAction(row)) {
    return false;
  }
  EatWhitespace();
  while (text_[offset_]) {
    if (text_[offset_] == ',') {
      ++offset_;
      if (!ParseAction(row)) {
        return false;
      }
      EatWhitespace();
    } else if (text_[offset_] == '\n') {
      return true;
    } else {
      std::string token;
      while (text_[offset_] &&
             text_[offset_] != ' ' &&
             text_[offset_] != '\r' &&
             text_[offset_] != '\t' &&
             text_[offset_] != '\n' &&
             text_[offset_] != ',') {
        token += text_[offset_];
        ++offset_;
        ++token_length_;
      }
      std::string error = (std::string)"Stray text: " + token;
      AddMessage(kChartParserError, error);
      EatWhitespace();
    }
  }
  return true;
}

bool ChartParser::ParseChart(chart_proto::Chart *chart) {
  chart->Clear();
  EatWhitespace();
  // Skip extra newlines at the beginning of the chart.
  while (text_[offset_] && text_[offset_] == '\n') {
    ++offset_;
    EatWhitespace();
  }
  if (!text_[offset_]) {
    // It's an empty chart.
    return true;
  }
  if (!ParseRow(chart->add_row())) {
    return false;
  }
  EatWhitespace();
  while (text_[offset_]) {
    if (text_[offset_] == '\n') {
      ++offset_;
      ++line_;
      line_start_ = offset_;
      // Check for blank line at the end of the chart.
      EatWhitespace();
      if (!text_[offset_]) {
        return true;
      }
      if (!ParseRow(chart->add_row())) {
        return false;
      }
      EatWhitespace();
    } else {
      AddMessage(kChartParserError, "Stray text after row.");
      ++offset_;
    }
  }
  return true;
}

void ChartParser::AddMessage(ChartParserMessageType type,
                             const std::string &message) {
  ChartParserMessage m;
  m.type = type;
  m.message = message;
  m.offset = offset_ - token_length_;
  m.line = line_ + 1;
  m.column = (m.offset - line_start_) + 1;
  m.length = token_length_;
  messages_.push_back(m);
}

}

