
#include <fstream>

#include "gui/chart_panel.h"

// Add some symbols that aren't in wx 2.6.
#if (wxMINOR_VERSION < 8)
#define wxFD_SAVE wxSAVE
#define wxFD_OVERWRITE_PROMPT wxOVERWRITE_PROMPT
#endif

const int ChartPanel::kIDInputText = 1;
const int ChartPanel::kIDErrorList = 2;

const int ChartPanel::kMenuSaveAs = wxID_SAVEAS;
const int ChartPanel::kMenuExportSVG = 1;
const int ChartPanel::kMenuClose = wxID_CLOSE;

ChartPanel::ChartPanel(Knitplot *app, const chart_model::Chart &chart,
                       const wxString &title)
    : wxFrame((wxFrame*)NULL, wxID_ANY, title),
      chart_(chart) {

  // Set up the menus.
  wxMenuBar *menu_bar = new wxMenuBar();
  app->SetupMenus(menu_bar);

  wxMenu *file_menu;
  int file_menu_index = menu_bar->FindMenu(_T("File"));
  if (file_menu_index == wxNOT_FOUND) {
    file_menu = new wxMenu();
    menu_bar->Append(file_menu, _T("&File"));
  } else {
    file_menu = menu_bar->GetMenu(file_menu_index);
  }

  file_menu->Append(kMenuSaveAs, _T("S&ave as...\tCtrl-A"));
  file_menu->Append(kMenuExportSVG, _T("Export as SVG...\tCtrl-X"));
  file_menu->Append(kMenuClose, _T("&Close\tCtrl-W"));

  SetMenuBar(menu_bar);

  preview_panel_ = new PreviewPanel(this, &chart_);
  input_text_ = new wxTextCtrl(this, kIDInputText, _T(""),
                               wxDefaultPosition, wxDefaultSize,
                               wxTE_MULTILINE | wxTE_RICH);
  error_list_ = new wxListBox(this, kIDErrorList,
                              wxDefaultPosition, wxDefaultSize,
                              0, NULL, wxLB_SINGLE);
  error_list_->SetMinSize(wxSize(10, 100));
  library_panel_ = new LibraryPanel(this, chart_.GetLibrary());

  wxBoxSizer *right_sizer = new wxBoxSizer(wxVERTICAL);
  right_sizer->Add(input_text_, 1, wxEXPAND, 0);
  right_sizer->Add(error_list_, 0, wxEXPAND, 0);

  wxBoxSizer *left_sizer = new wxBoxSizer(wxVERTICAL);
  left_sizer->Add(preview_panel_, 1, wxEXPAND, 0);
  left_sizer->Add(library_panel_, 0, wxEXPAND, 0);

  wxBoxSizer *sizer = new wxBoxSizer(wxHORIZONTAL);
  sizer->Add(left_sizer, 1, wxEXPAND, 0);
  sizer->Add(right_sizer, 1, wxEXPAND, 0);
  SetSizer(sizer);

  SetAutoLayout(TRUE);

  wxString text(chart_.GetText().c_str(), wxConvUTF8);
  input_text_->SetValue(text);

  chart_.AddListener(this);
}

void ChartPanel::OnChartChanged() {
  wxString text(chart_.GetText().c_str(), wxConvUTF8);
  if (input_text_->GetValue() != text) {
    input_text_->SetValue(text);
  }
}

void ChartPanel::OnSelect() {
  input_text_->SetFocus();

  const chart_model::ChartSelection &sel = chart_.GetSelection();
  input_text_->SetSelection(sel.start, sel.start + sel.length);
}

void ChartPanel::OnSaveAs(wxCommandEvent& WXUNUSED(event)) {
  wxFileDialog dialog(this, _T("Save chart as..."), _T(""), _T(""),
                      _T("*.chart"), wxFD_SAVE | wxFD_OVERWRITE_PROMPT);
  if (dialog.ShowModal() == wxID_OK) {
    wxString path = dialog.GetPath();
    std::string error;
    if (!chart_.SaveToFile(path.mb_str(wxConvUTF8), &error)) {
      wxString err(error.c_str(), wxConvUTF8);
      wxMessageBox(err, _T("Error"), wxOK | wxICON_INFORMATION, NULL);
    }
  }
}

void ChartPanel::OnExportSVG(wxCommandEvent& WXUNUSED(event)) {
  wxFileDialog dialog(this, _T("Save as SVG..."), _T(""), _T(""),
                      _T("*.svg"), wxFD_SAVE | wxFD_OVERWRITE_PROMPT);
  if (dialog.ShowModal() == wxID_OK) {
    wxString path = dialog.GetPath();
    std::string error;
    if (!chart_.ExportToSVG(path.mb_str(wxConvUTF8), 500, 500, &error)) {
      wxString err(error.c_str(), wxConvUTF8);
      wxMessageBox(err, _T("Error"), wxOK | wxICON_INFORMATION, NULL);
    }
  }
}

void ChartPanel::OnMenuClose(wxCommandEvent& WXUNUSED(event)) {
  Close(FALSE);
}

void ChartPanel::OnText(wxCommandEvent &event) {
  if (!strcmp(chart_.GetText().c_str(),
              input_text_->GetValue().mb_str(wxConvUTF8))) {
    return;
  }

  input_text_->SetStyle(0, input_text_->GetValue().size(),
                        wxTextAttr(*wxBLACK));

  chart_.ParseText(input_text_->GetValue().mb_str(wxConvUTF8));
  error_list_->Clear();
  for (int i = 0; i < chart_.GetParserMessageCount(); ++i) {
    const chart_model::ChartParserMessage &message = chart_.GetParserMessage(i);

    wxString error;
    if (message.type == chart_model::kChartParserError) {
      error.Append(_T("ERROR"));
    } else {
      error.Append(_T("WARNING"));
    }

    wxString location;
    location.Printf(_T(" [line %d, column %d]: "),
                    message.line, message.column);
    error.Append(location);

    error.Append(wxString(message.message.c_str(), wxConvUTF8));
    error_list_->Append(error);

    // Mark the error text as red in the input field.
    int error_offset = message.offset;
    int error_column = message.column;
    int error_length = message.length;
    if (error_length == 0) {
      error_length = 1;
      if (error_column > 0) {
        --error_column;
        --error_offset;
      }
    }
    input_text_->SetStyle(error_offset, error_offset + error_length,
                          wxTextAttr(*wxRED));
  }
}

void ChartPanel::OnErrorSelect(wxCommandEvent &event) {
  int selection = error_list_->GetSelection();
  if (selection >= 0 && selection < chart_.GetParserMessageCount()) {
    const chart_model::ChartParserMessage &message =
        chart_.GetParserMessage(selection);
    chart_.SelectText(message.offset, message.length);
  }
}

void ChartPanel::OnClose(wxCloseEvent& WXUNUSED(event)) {
  if (chart_.IsModified()) {
    int answer = wxMessageBox(_T("Save changes?"), _T("Save?"),
                              wxYES_NO | wxCANCEL, this);
    if (answer == wxYES) {
      
    } else if (answer == wxNO) {
      Destroy();
    }
  } else {
    Destroy();
  }
}

void ChartPanel::OnIdle(wxIdleEvent& WXUNUSED(event)) {
  long from;
  long to;
  input_text_->GetSelection(&from, &to);
  chart_.SelectText(from, to - from);
}

BEGIN_EVENT_TABLE(ChartPanel, wxFrame)
  EVT_MENU(kMenuSaveAs,     ChartPanel::OnSaveAs)
  EVT_MENU(kMenuExportSVG,  ChartPanel::OnExportSVG)
  EVT_MENU(kMenuClose,      ChartPanel::OnMenuClose)
  EVT_TEXT(kIDInputText,    ChartPanel::OnText)
  EVT_LISTBOX(kIDErrorList, ChartPanel::OnErrorSelect)
  EVT_CLOSE(ChartPanel::OnClose)
  EVT_IDLE(ChartPanel::OnIdle)
END_EVENT_TABLE()
