#ifndef __GUI_LIBRARY_PANEL_H__
#define __GUI_LIBRARY_PANEL_H__

#include <wx/wx.h>

#include "model/library.h"

class LibraryPanel : public wxPanel {
 public:
  LibraryPanel(wxWindow *parent, chart_model::Library *library);

 private:
  void OnSize(wxSizeEvent &event);

  void OnPaint(wxPaintEvent &event);

  void OnDraw(wxDC &dc);

  void OnIdle(wxIdleEvent &event);

  int column_width_;
  int target_height_;

  chart_model::Library *library_;

  DECLARE_EVENT_TABLE()
};

#endif
