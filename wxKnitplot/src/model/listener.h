#ifndef __MODEL_LISTENER_H__
#define __MODEL_LISTENER_H__

#include <vector>

namespace chart_model {

template<typename T>
class Listener {
 public:
  virtual ~Listener() {}

  virtual void OnChanged(const T *item) = 0;
};

template<typename T>
class Speaker {
 public:
  void AddListener(Listener<T> *listener) {
    listeners_.push_back(listener);
  }

 protected:
  void NotifyChanged(T *item) const {
    for (unsigned int i = 0; i < listeners_.size(); ++i) {
      listeners_[i]->OnChanged(item);
    }
  }

 private:
  std::vector<Listener<T>*> listeners_;
};

} // namespace chart_model

#endif
