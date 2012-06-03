
DEBUG =

GFLAGS = ../lib/gflags
PROTOBUF = ../lib/proto

GFLAGS_CFLAGS = -I$(GFLAGS)/include
GFLAGS_LIBS = -L$(GFLAGS)/lib -lgflags -lpthread

PROTOBUF_CFLAGS = -I$(PROTOBUF)/include
PROTOBUF_LIBS = -L$(PROTOBUF)/lib -lprotobuf

WX_CFLAGS = `../lib/wx/bin/wx-config --cxxflags`
WX_LIBS = `../lib/wx/bin/wx-config --libs`

COMPILE = g++ $(DEBUG) -Wall -c -I.
LINK = g++ $(DEBUG)

all: ../bin/proto2json ../bin/chart2svg ../bin/Knitplot.app

clean:
	#
	# Cleaning up binaries...
	#
	-rm ../bin/proto2json
	-rm ../bin/chart2svg
	-rm ../bin/knitplot
	-rm -rf ../bin/Knitplot.app
	#
	# Cleaning up object files...
	#
	-rm ../obj/*.o
	#
	# Cleaning up the protocol buffer files...
	#
	-rm ../obj/chart.pb
	-rm storage/chart.pb.h
	-rm storage/chart.pb.cc

# chart.proto

../obj/chart.pb: storage/chart.proto
	$(PROTOBUF)/bin/protoc -I=. --cpp_out=. $< && touch $@
storage/chart.pb.h: ../obj/chart.pb
storage/chart.pb.cc: ../obj/chart.pb

INCLUDE_storage_chart_pb_h = storage/chart.pb.h

../obj/chart.pb.o: storage/chart.pb.cc $(INCLUDE_storage_chart_pb_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

INCLUDE_model_listener_h = model/listener.h

INCLUDE_model_color_h = model/color.h $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h)

INCLUDE_model_style_h = model/style.h $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_color_h)

INCLUDE_model_point_h = model/point.h $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) 

INCLUDE_model_shape_base_h = model/shape_base.h $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_style_h)

INCLUDE_model_line_h = model/line.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_point_h)

INCLUDE_model_rectangle_h = model/rectangle.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_point_h)

INCLUDE_model_circle_h = model/circle.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_point_h)

INCLUDE_model_polygon_h = model/polygon.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_point_h)

INCLUDE_model_spline_h = model/spline.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_point_h)

INCLUDE_model_text_h = model/text.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_point_h)

INCLUDE_model_shape_h = model/shape.h $(INCLUDE_model_shape_base_h) $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h)

INCLUDE_model_graphic_h = model/graphic.h $(INCLUDE_storage_chart_pb_h) $(INCLUDE_model_listener_h) $(INCLUDE_model_shape_h)

INCLUDE_model_renderer_h = model/renderer.h $(INCLUDE_model_line_h) $(INCLUDE_model_rectangle_h) $(INCLUDE_model_circle_h) $(INCLUDE_model_polygon_h) $(INCLUDE_model_spline_h) $(INCLUDE_model_style_h) $(INCLUDE_model_text_h)

../obj/color.o: model/color.cc $(INCLUDE_model_color_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/style.o: model/style.cc $(INCLUDE_model_style_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/point.o: model/point.cc $(INCLUDE_model_point_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/line.o: model/line.cc $(INCLUDE_model_line.h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/rectangle.o: model/rectangle.cc $(INCLUDE_model_rectangle.h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/circle.o: model/circle.cc $(INCLUDE_model_circle.h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/polygon.o: model/polygon.cc $(INCLUDE_model_polygon.h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/spline.o: model/spline.cc $(INCLUDE_model_spline.h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/text.o: model/text.cc $(INCLUDE_model_text.h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/shape.o: model/shape.cc $(INCLUDE_model_shape_h) $(INCLUDE_model_line_h) $(INCLUDE_model_rectangle_h) $(INCLUDE_model_circle_h) $(INCLUDE_model_polygon_h) $(INCLUDE_model_spline_h) $(INCLUDE_model_text_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/graphic.o: model/graphic.cc $(INCLUDE_model_graphic_h) $(INCLUDE_model_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

INCLUDE_model_library_h = model/library.h \
                          $(INCLUDE_storage_chart_pb_h)

INCLUDE_model_chart_parser_h = model/chart_parser.h \
                               $(INCLUDE_storage_chart_pb_h) \
                               $(INCLUDE_model_library_h)

INCLUDE_model_chart_listener_h = model/chart_listener.h

INCLUDE_model_chart_h = model/chart.h \
                        $(INCLUDE_storage_chart_pb_h) \
                        $(INCLUDE_model_chart_parser_h) \
                        $(INCLUDE_model_library_h) \
                        $(INCLUDE_model_chart_listener_h)

../obj/chart_parser.o: model/chart_parser.cc \
                       $(INCLUDE_model_chart_parser_h) \
                       $(INCLUDE_storage_chart_pb_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/chart.o: model/chart.cc \
                $(INCLUDE_model_chart_h) \
                $(INCLUDE_model_svg_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/library.o: model/library.cc $(INCLUDE_model_library_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

INCLUDE_model_svg_h = model/svg.h \
                      $(INCLUDE_model_renderer_h)

../obj/svg.o: model/svg.cc $(INCLUDE_model_svg.h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS)

../obj/chart2svg.o: cli/chart2svg.cc $(INCLUDE_model_chart_h) $(INCLUDE_model_svg.h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(GFLAGS_CFLAGS)

../obj/proto2json.o: cli/proto2json.cc $(INCLUDE_storage_chart_pb_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(GFLAGS_CFLAGS)

# wx UI

INCLUDE_gui_library_panel_h = gui/library_panel.h \
                              $(INCLUDE_model_library_h)

../obj/library_panel.o: gui/library_panel.cc $(INCLUDE_gui_library_panel_h) $(INCLUDE_model_chart_h) $(INCLUDE_gui_preview_panel.h) $(INCLUDE_gui_wx_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(WX_CFLAGS)

INCLUDE_gui_wx_renderer_h = gui/wx_renderer.h $(INCLUDE_model_renderer_h)

../obj/wx_renderer.o: gui/wx_renderer.cc $(INCLUDE_gui_wx_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(WX_CFLAGS)

INCLUDE_gui_preview_panel_h = gui/preview_panel.h \
                              $(INCLUDE_model_chart_h) \
                              $(INCLUDE_storage_chart_pb_h)

../obj/preview_panel.o: gui/preview_panel.cc $(INCLUDE_gui_preview_panel_h) $(INCLUDE_gui_wx_renderer_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(WX_CFLAGS)

INCLUDE_gui_knitplot_h = gui/knitplot.h \
                        $(INCLUDE_model_library.h)

../obj/knitplot.o: gui/knitplot.cc \
                  $(INCLUDE_gui_knitplot_h) \
                  $(INCLUDE_storage_chart_pb_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(GFLAGS_CFLAGS) $(WX_CFLAGS)

INCLUDE_gui_chart_panel_h = gui/chart_panel.h \
                            $(INCLUDE_gui_knitplot_h) \
                            $(INCLUDE_gui_preview_panel_h) \
                            $(INCLUDE_gui_library_panel_h) \
                            $(INCLUDE_model_chart_h)

../obj/chart_panel.o: gui/chart_panel.cc $(INCLUDE_gui_chart_panel_h)
	$(COMPILE) -o $@ $< $(PROTOBUF_CFLAGS) $(WX_CFLAGS)

# proto2json

../bin/proto2json: ../obj/proto2json.o ../obj/chart.pb.o
	#
	# Linking command line chart proto -> json converter...
	#
	$(LINK) -o $@ $^ $(PROTOBUF_LIBS) $(GFLAGS_LIBS)

# chart2svg

../bin/chart2svg: ../obj/chart2svg.o ../obj/chart_parser.o ../obj/chart.pb.o ../obj/svg.o ../obj/chart.o ../obj/library.o ../obj/line.o ../obj/circle.o ../obj/shape.o ../obj/rectangle.o ../obj/polygon.o ../obj/spline.o ../obj/graphic.o ../obj/style.o ../obj/point.o ../obj/color.o ../obj/text.o
	#
	# Linking command line chart text -> svg converter...
	#
	$(LINK) -o $@ $^ $(PROTOBUF_LIBS) $(GFLAGS_LIBS)

# knitplot

../bin/knitplot: ../obj/knitplot.o ../obj/chart_panel.o ../obj/chart.pb.o ../obj/chart_parser.o ../obj/svg.o ../obj/preview_panel.o ../obj/chart.o ../obj/library.o ../obj/library_panel.o ../obj/wx_renderer.o ../obj/line.o ../obj/circle.o ../obj/shape.o ../obj/rectangle.o ../obj/polygon.o ../obj/spline.o ../obj/graphic.o ../obj/style.o ../obj/point.o ../obj/color.o ../obj/text.o

	#
	# Linking GUI chart editor...
	#
	$(LINK) -o $@ $^ $(PROTOBUF_LIBS) $(GFLAGS_LIBS) $(WX_LIBS)

# Knitplot.app

#YourApp.app: Info.plist YourApp version.plist InfoPlist.strings YourAppMacIcons.icns AnotherResource.txt  
../bin/Knitplot.app: ../bin/knitplot
	#
	# Creating Mac OS X app bundle...
	#
	rm -rf ../bin/Knitplot.app
	mkdir -p ../bin/Knitplot.app
	mkdir -p ../bin/Knitplot.app/Contents
	mkdir -p ../bin/Knitplot.app/Contents/MacOS
	mkdir -p ../bin/Knitplot.app/Contents/Resources
	mkdir -p ../bin/Knitplot.app/Contents/Resources/English.lproj
	#cp Info.plist ../bin/Knitplot.app/Contents/
	#cp version.plist ../bin/Knitplot.app/Contents/
	#cp InfoPlist.strings ../bin/Knitplot.app/Contents/Resources/English.lproj/
	echo -n 'APPL????' > ../bin/Knitplot.app/Contents/PkgInfo
	cp ../bin/knitplot ../bin/Knitplot.app/Contents/MacOS/Knitplot
	# cp icons.icns ../bin/Knitplot.app/Contents/Resources/
	mkdir -p ../bin/Knitplot.app/Contents/Resources/data/
	cp ../data/actions.txt ../bin/Knitplot.app/Contents/Resources/data/
