#ifndef __GUI_CHART_APP_H__
#define __GUI_CHART_APP_H__

#include <wx/wx.h>

#include "model/library.h"

class Knitplot: public wxApp {
 public:
  void SetupMenus(wxMenuBar *menu_bar);
  
 private:
  /* overridden */ bool OnInit();

  void OnAbout(wxCommandEvent &event);
  void OnNew(wxCommandEvent &event);
  void OnOpen(wxCommandEvent &event);
  void OnQuit(wxCommandEvent &event);
  
  static const int kMenuQuit;
  static const int kMenuAbout;
  static const int kMenuNew;
  static const int kMenuOpen;
  
  chart_model::Library default_library_;
  int next_id_;
  
  DECLARE_EVENT_TABLE()
};

#endif
