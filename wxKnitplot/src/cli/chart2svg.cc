
#include <cstdio>
#include <fstream>
#include <gflags/gflags.h>
#include <google/protobuf/io/zero_copy_stream_impl.h>
#include <google/protobuf/text_format.h>
#include <string>
using namespace std;

#include "model/chart.h"
#include "model/svg.h"

using google::protobuf::TextFormat;

DEFINE_string(input, "", "chart specified as a string");
DEFINE_string(input_file, "", "file containing chart text");
DEFINE_string(output, "", "name of svg file to output to");
DEFINE_double(max_width, 500.0, "max width of output svg");
DEFINE_double(max_height, 5000.0, "max height of output svg");
DEFINE_string(library, "data/actions.txt", "library file of actions");

int main(int argc, char **argv) {
  google::SetUsageMessage("chart2svg --input TEXT OR --input_file FILE");
  google::ParseCommandLineFlags(&argc, &argv, true);

  if (FLAGS_input.empty() && FLAGS_input_file.empty()) {
    fprintf(stderr, "You must specify either --input or --input_file.\n");
    exit(-1);
  }
  if (!FLAGS_input.empty() && !FLAGS_input_file.empty()) {
    fprintf(stderr, "You can't specify both --input and --input_file.\n");
    exit(-1);
  }
  if (FLAGS_library.empty()) {
    fprintf(stderr, "You must have a library file.\n");
    exit(-1);
  }
  if (FLAGS_max_width == 0.0) {
    fprintf(stderr, "--max_width cannot be 0.0");
    exit(-1);
  }
  if (FLAGS_max_height == 0.0) {
    fprintf(stderr, "--max_height cannot be 0.0");
    exit(-1);
  }

  if (!FLAGS_input_file.empty()) {
    fstream file(FLAGS_input_file.c_str());
    istream& in = file;
    if (!in || !in.good()) {
      fprintf(stderr, "Unable to open file: \"%s\".\n", FLAGS_input_file.c_str());
      exit(-1);
    }
    string line = "";
    getline(in, line);
    while (in && in.good()) {
      FLAGS_input += line;
      FLAGS_input += '\n';
      line = "";
      getline(in, line);
    }
    if (!line.empty()) {
      FLAGS_input += line;
      FLAGS_input += '\n';
    }
  }

  FILE *out;
  if (FLAGS_output.empty()) {
    out = stdout;
  } else {
    out = fopen(FLAGS_output.c_str(), "w");
  }

  string error;

  // Load the library of available actions.
  chart_model::Library library;
  if (!library.LoadFromFile(FLAGS_library.c_str(), &error)) {
    fprintf(stderr, "%s\n", error.c_str());
    exit(-1);
  }

  chart_model::Chart chart(library);
  chart.ParseText(FLAGS_input.c_str());
  for (int i = 0; i < chart.GetParserMessageCount(); ++i) {
    const chart_model::ChartParserMessage &message = chart.GetParserMessage(i);
    fprintf(stderr, "%s: line %d, column %d: %s\n",
            (message.type == chart_model::kChartParserError
             ? "Error"
             : "Warning"),
            message.line, message.column, message.message.c_str());
  }

  chart_model::Graphic graphic;
  if (!chart.GetGraphic(FLAGS_max_width, FLAGS_max_height, false,
                        &graphic, &error)) {
    fprintf(stderr, "%s\n", error.c_str());
    exit(-1);
  }

  chart_model::SVGRenderer svg;
  graphic.Render(&svg);
  fprintf(out, "%s", svg.OutputAsString().c_str());

  fclose(out);
  return 0;
}

