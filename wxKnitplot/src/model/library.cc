
#include <fstream>

#include <google/protobuf/io/tokenizer.h>
#include <google/protobuf/io/zero_copy_stream_impl.h>
#include <google/protobuf/text_format.h>

#include "model/library.h"

using google::protobuf::TextFormat;
using google::protobuf::io::ErrorCollector;

namespace chart_model {

Library::Library() {
}

Library::Library(const Library &other) {
  library_.CopyFrom(other.library_);
}

Library::Library(const chart_proto::Library &library) {
  library_.CopyFrom(library);
}

Library &Library::operator=(const Library &other) {
  library_.CopyFrom(other.library_);
  return *this;
}

bool Library::FindActionType(const char *const action,
                             chart_proto::ActionType *action_type) const {
  for (int i = 0; i < library_.action_type_size(); ++i) {
    if (library_.action_type(i).name() == action) {
      action_type->CopyFrom(library_.action_type(i));
      return true;
    }
  }
  return false;
}

bool Library::FindAction(const char *const action_text,
                         chart_proto::Action *action) const {
  std::string action_string = action_text;
  for (int i = 0; i < library_.action_type_size(); ++i) {
    size_t pos = library_.action_type(i).name().find('#');
    if (pos != std::string::npos) {
      // The thing in the library has a # wildcard.
      std::string prefix = library_.action_type(i).name().substr(0, pos);
      std::string suffix = library_.action_type(i).name().substr(pos + 1);
      if (action_string.size() > prefix.size() + suffix.size()) {
        if (action_string.substr(0, prefix.size()) == prefix &&
            action_string.substr(action_string.size() - suffix.size()) == suffix) {
          int number_length = action_string.size() - (prefix.size() + suffix.size());
          std::string number_text = action_string.substr(prefix.size(), number_length);
          bool number = true;
          for (unsigned int j = 0; j < number_text.size(); ++j) {
            if (!isdigit(number_text[j])) {
              number = false;
            }
          }
          if (number) {
            action->set_action(library_.action_type(i).name());
            action->set_width(library_.action_type(i).width() *
                              atoi(number_text.c_str()));
            return true;
          }
        }
      }
    } else {
      // The thing in the library has NO # wildcard.
      if (library_.action_type(i).name() == action_string) {
        action->set_action(action_string);
        action->set_width(library_.action_type(i).width());
        return true;
      }
    }
  }

  return false;
}

class LibraryErrorCollector : public ErrorCollector {
 public:
  void AddError(int line, int column, const std::string &message) {
    if (!error.empty()) {
      error.append("\n");
    }

    char position[1000];
    sprintf(position, " (line: %d, column: %d)", line, column);
    error.append(message + position);
  }

  std::string GetErrorMessage() {
    return error;
  }

 private:
  std::string error;
};

bool Library::LoadFromFile(const char *const filename, std::string *error) {
  std::fstream library_file(filename, std::ios::in | std::ios::binary);
  if (!library_file.good()) {
    *error = (std::string)"Unable to open library at " + filename + ".";
    return false;
  }
  
  TextFormat::Parser parser;
  LibraryErrorCollector error_collector;
  parser.RecordErrorsTo(&error_collector);
  google::protobuf::io::IstreamInputStream library_stream(&library_file);
  if (!parser.Parse(&library_stream, &library_)) {
    *error = error_collector.GetErrorMessage();
    return false;
  }

  return true;
}

void Library::CopyFrom(const chart_proto::Library &other) {
  library_.CopyFrom(other);
}

void Library::CopyTo(chart_proto::Library *other) const {
  other->CopyFrom(library_);
}

}  // namespace chart_model
