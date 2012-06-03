
#include <fstream>

#include <gflags/gflags.h>

#include "gui/knitplot.h"
#include "gui/chart_panel.h"
#include "storage/chart.pb.h"

// Add some symbols that aren't in wx 2.6.
#if (wxMINOR_VERSION < 8)
#define wxFD_OPEN wxOPEN
#define wxFD_FILE_MUST_EXIST wxFILE_MUST_EXIST
#endif

DEFINE_string(default_library, "data/actions.txt",
              "default library file of actions");

const int Knitplot::kMenuQuit = wxID_EXIT;
const int Knitplot::kMenuAbout = wxID_ABOUT;;
const int Knitplot::kMenuNew = wxID_NEW;
const int Knitplot::kMenuOpen = wxID_OPEN;

void Knitplot::SetupMenus(wxMenuBar *menu_bar) {
  // Set up the menus.
  wxMenu *file_menu = new wxMenu();
  file_menu->Append(kMenuAbout, _T("&About..."));
  file_menu->AppendSeparator();
  file_menu->Append(kMenuNew, _T("&New\tCtrl-N"));
  file_menu->Append(kMenuOpen, _T("&Open\tCtrl-O"));

  menu_bar->Append(file_menu, _T("&File"));
}

bool Knitplot::OnInit() {
  google::ParseCommandLineFlags(&argc, (char***)&argv, true);

  // Load the default library of available actions.
  std::string error;
  if (!default_library_.LoadFromFile(FLAGS_default_library.c_str(), &error)) {
    wxString err(error.c_str(), wxConvUTF8);
    wxMessageBox(err, _T("Error"), wxOK | wxICON_INFORMATION, NULL);
    return FALSE;
  }

  // Setup the default menu bar on the mac version.
#ifdef __WXMAC__
  wxApp::SetExitOnFrameDelete(false);
  wxMenuBar *menu_bar = new wxMenuBar();
  SetupMenus(menu_bar);
  wxMenuBar::MacSetCommonMenuBar(menu_bar);
#endif

  // Open a new empty document.
  next_id_ = 1;
  wxString title;
  title.Printf(_T("Untitled %d"), next_id_++);

  chart_model::Chart chart(default_library_);
  ChartPanel *new_frame = new ChartPanel(this, chart, title);
  new_frame->Show();

  return TRUE;
}

void Knitplot::OnAbout(wxCommandEvent& WXUNUSED(event)) {
  wxMessageBox(_T("This is a cool program."),
               _T("About Chart"),
               wxOK | wxICON_INFORMATION,
               NULL);
}

void Knitplot::OnNew(wxCommandEvent& WXUNUSED(event)) {
  wxString title;
  title.Printf(_T("Untitled %d"), next_id_++);

  chart_model::Chart chart(default_library_);
  ChartPanel *new_frame = new ChartPanel(this, chart, title);
  new_frame->Show();
}

void Knitplot::OnOpen(wxCommandEvent& WXUNUSED(event)) {
  wxFileDialog dialog(NULL, _T("Open chart..."), _T(""), _T(""), _T("*.chart"),
                      wxFD_OPEN | wxFD_FILE_MUST_EXIST);
  if (dialog.ShowModal() == wxID_OK) {
    wxString path = dialog.GetPath();
    std::string error;
    chart_model::Chart chart(default_library_);
    if (!chart.LoadFromFile(path.mb_str(wxConvUTF8), &error)) {
      wxString err(error.c_str(), wxConvUTF8);
      wxMessageBox(err, _T("Error"), wxOK | wxICON_INFORMATION, NULL);
      return;
    }
    wxFrame *new_frame = new ChartPanel(this, chart, path);
    new_frame->Show();
  }
}

void Knitplot::OnQuit(wxCommandEvent& WXUNUSED(event)) {
  exit(0);
}

BEGIN_EVENT_TABLE(Knitplot, wxApp)
  EVT_MENU(kMenuQuit, Knitplot::OnQuit)
  EVT_MENU(kMenuAbout, Knitplot::OnAbout)
  EVT_MENU(kMenuNew, Knitplot::OnNew)
  EVT_MENU(kMenuOpen, Knitplot::OnOpen)
END_EVENT_TABLE()

IMPLEMENT_APP(Knitplot)
