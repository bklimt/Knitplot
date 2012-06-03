
#include "model/svg.h"

using std::string;

namespace chart_model {

string DoubleToString(double d) {
  char temp[1000];
  sprintf(temp, "%.2lf", d);
  return string(temp);
}

string IntToString(int n) {
  char temp[1000];
  sprintf(temp, "%d", n);
  return string(temp);
}

void ColorToSVG(const Color &color, string *out) {
  out->append("rgb(" + IntToString(color.red()) + ", " +
                       IntToString(color.green()) + ", " +
                       IntToString(color.blue()) + ")");
}

void StyleToSVG(const Style &style, string *out) {
  out->append("style=\"");

  out->append("fill:");
  ColorToSVG(style.fill(), out);
  out->append(";");

  out->append("stroke:");
  ColorToSVG(style.stroke(), out);
  out->append(";");

  out->append("stroke-width:" + DoubleToString(style.stroke_width()) + ";");

  out->append("\"");
}

void SVGRenderer::Start(int width, int height) {
  buffer_.clear();
  buffer_.append("<?xml version=\"1.0\" standalone=\"no\"?>\n");
  buffer_.append("<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" "
                 "\"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n");
  buffer_.append("<svg width=\"" + DoubleToString(width) + "\" "
                 "height=\"" + DoubleToString(height) + "\" "
                 "version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n");
}

void SVGRenderer::DrawLine(const Line &line, const Style &style) {
  buffer_.append("<line x1=\"" + DoubleToString(line.point1().x()) + "\" "
                       "y1=\"" + DoubleToString(line.point1().y()) + "\" "
                       "x2=\"" + DoubleToString(line.point2().x()) + "\" "
                       "y2=\"" + DoubleToString(line.point2().y()) + "\" ");
  StyleToSVG(style, &buffer_);
  buffer_.append(" />\n");
}

void SVGRenderer::DrawRectangle(const Rectangle &rect, const Style &style) {
  buffer_.append("<rect x=\"" + DoubleToString(rect.top_left().x()) + "\" "
                       "y=\"" + DoubleToString(rect.top_left().y()) + "\" "
                   "width=\"" + DoubleToString(rect.width()) + "\" "
                  "height=\"" + DoubleToString(rect.height()) + "\" ");
  StyleToSVG(style, &buffer_);
  buffer_.append(" />\n");
}

void SVGRenderer::DrawCircle(const Circle &circle, const Style &style) {
  buffer_.append("<circle cx=\"" + DoubleToString(circle.center().x()) + "\" "
                         "cy=\"" + DoubleToString(circle.center().y()) + "\" "
                          "r=\"" + DoubleToString(circle.radius()) + "\" ");
  StyleToSVG(style, &buffer_);
  buffer_.append(" />\n");
}

void SVGRenderer::DrawPolygon(const Polygon &polygon, const Style &style) {
  buffer_.append("<polygon points=\"");
  for (int j = 0; j < polygon.point_count(); ++j) {
    if (j != 0) {
      buffer_.append(" ");
    }
    buffer_.append(DoubleToString(polygon.point(j).x()) + "," +
                   DoubleToString(polygon.point(j).y()));
  }
  buffer_.append("\" ");
  StyleToSVG(style, &buffer_);
  buffer_.append(" />\n");
}

void SVGRenderer::DrawSpline(const Spline &spline, const Style &style) {
  if (spline.point_count() < 2) {
    return;
  }

  double thisX = spline.point(0).x();
  double thisY = spline.point(0).y();
  double nextX = spline.point(1).x();
  double nextY = spline.point(1).y();
  double cX = (thisX + nextX) / 2;
  double cY = (thisY + nextY) / 2;

  buffer_.append("<path d=\"");
  buffer_.append("M" +
                 DoubleToString(thisX) + "," +
                 DoubleToString(thisY) + " " +
                 "L" +
                 DoubleToString(cX) + "," +
                 DoubleToString(cY));

  for (int j = 2; j < spline.point_count(); ++j) {
    thisX = nextX;
    thisY = nextY;
    nextX = spline.point(j).x();
    nextY = spline.point(j).y();
    cX = (thisX + nextX) / 2;
    cY = (thisY + nextY) / 2;
    buffer_.append(" Q" +
                   DoubleToString(thisX) + "," +
                   DoubleToString(thisY) + " " +
                   DoubleToString(cX) + "," +
                   DoubleToString(cY));
  }

  buffer_.append(" L" +
                 DoubleToString(nextX) + "," +
                 DoubleToString(nextY));

  buffer_.append("\" ");
  StyleToSVG(style, &buffer_);
  buffer_.append(" />\n");
}

void SVGRenderer::DrawText(const Text &text, const Style &style) {
  buffer_.append("<text x=\"" + DoubleToString(text.point().x()) + "\" "
                       "y=\"" + DoubleToString(text.point().y()) + "\" "
                       //"alignment-baseline=\"bottom\" "
                       //"textLength=\"300.0\" "
                       //"text-anchor=\"bottom\" "
                       "font-family=\"Verdana\" "
                       "font-size=\"12\" ");
  StyleToSVG(style, &buffer_);
  buffer_.append(">");
  buffer_.append(text.text());
  buffer_.append("</text>\n");
}

void SVGRenderer::End() {
  buffer_.append("</svg>\n");
}

}  // namespace chart_model
