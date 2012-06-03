
#ifndef __GUI_PREVIEW_PANEL_H__
#define __GUI_PREVIEW_PANEL_H__

#include <wx/wx.h>

#include "model/chart.h"
#include "storage/chart.pb.h"

class PreviewPanel : public wxScrolledWindow, ChartListener {
 public:
  PreviewPanel(wxWindow *parent, chart_model::Chart *chart);

  void OnChartChanged();
  void OnSelect();

  void OnLeftDown(wxMouseEvent &event);
  void OnMotion(wxMouseEvent &event);
  void OnLeftUp(wxMouseEvent &event);
  void OnSize(wxSizeEvent &event);
  void OnDraw(wxDC &dc);

 private:
  const chart_model::Shape *GetShapeAt(wxCoord x, wxCoord y);

  void DrawGraphic(wxDC &dc, double x, double y, bool as_shadow);

  chart_model::Chart *chart_;
  chart_model::Graphic graphic_;

  bool selecting_;
  int selection_start_;
  int selection_end_;

  DECLARE_EVENT_TABLE()
};

#endif
