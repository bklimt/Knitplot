#ifndef __MODEL_LIBRARY_H__
#define __MODEL_LIBRARY_H__

#include <string>

#include "storage/chart.pb.h"

namespace chart_model {

class Library {
 public:
  Library();

  Library(const Library &other);

  Library(const chart_proto::Library &library);

  Library &operator=(const Library &other);

  bool FindActionType(const char *const action,
                      chart_proto::ActionType *action_type) const;

  bool FindAction(const char *const action_text,
                  chart_proto::Action *action) const;

  bool LoadFromFile(const char *const filename, std::string *error);

  void CopyFrom(const chart_proto::Library &other);

  void CopyTo(chart_proto::Library *other) const;

  int GetActionTypeCount() { return library_.action_type_size(); }

  const chart_proto::ActionType &GetActionType(int i) {
    return library_.action_type(i);
  }

 private:
  chart_proto::Library library_;
};

}  // namespace chart_model

#endif
