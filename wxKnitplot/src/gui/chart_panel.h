
#ifndef __GUI_CHART_PANEL_H__
#define __GUI_CHART_PANEL_H__

#include <wx/listctrl.h>
#include <wx/wx.h>

#include "gui/knitplot.h"
#include "gui/library_panel.h"
#include "gui/preview_panel.h"
#include "model/chart.h"

class ChartPanel : public wxFrame, ChartListener {
 public:
  ChartPanel(Knitplot *app, const chart_model::Chart &chart,
             const wxString &title);

  void OnChartChanged();

  void OnSelect();

 private:
  void OnSaveAs(wxCommandEvent &event);
  void OnExportSVG(wxCommandEvent &event);
  void OnMenuClose(wxCommandEvent &event);
  void OnText(wxCommandEvent &event);
  void OnErrorSelect(wxCommandEvent &event);
  void OnClose(wxCloseEvent &event);
  void OnIdle(wxIdleEvent &event);

  static const int kIDInputText;
  static const int kIDErrorList;

  static const int kMenuSaveAs;
  static const int kMenuExportSVG;
  static const int kMenuClose;

  PreviewPanel *preview_panel_;
  wxTextCtrl *input_text_;
  wxListBox *error_list_;
  LibraryPanel *library_panel_;

  chart_model::Chart chart_;

  DECLARE_EVENT_TABLE()
};

#endif
