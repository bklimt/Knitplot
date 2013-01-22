
Parse = require('parse').Parse

Parse.initialize(
    "732uFxOqiBozGHcv6BUyEZrpQC0oIbmTbi4UJuK2",
    "JB48tpHfZ39NTwrRuQIoqq7GQzpdxLonrjpsj67L")

library = new Parse.Object "Library"
library.save
  name: "Basic"
  data:
    "a":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#40e0d0"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "bp":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#bebebe"
          stroke: "#000000"
          "stroke-width": 1
      ,
        circle: { center: [0.50, 0.50], radius: 0.30 }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "ap":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#40e0d0"
          stroke: "#000000"
          "stroke-width": 1
      ,
        circle: { center: [0.50, 0.50], radius: 0.30 }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "error":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ff0000"
          stroke: "#ff0000"
          "stroke-width": 1
      ]
    "k":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "p":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.20], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "ns":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "k3tog":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.80, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "k2tog":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.80, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "sk2p":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "ssk":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "cdd":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.20, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "yo":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        circle: { center: [0.50, 0.50], radius: 0.30 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "t#l":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [0.00, 0.00],
          [0.00, 1.00],
          [0.33, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [1.00, 0.00],
          [0.67, 0.00],
          [1.00, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "t#r":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [0.00, 0.00],
          [0.00, 1.00],
          [0.33, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [1.00, 0.00],
          [0.67, 1.00],
          [1.00, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "c#l":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.00, 0.00], point2: [0.50, 1.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.00], point2: [1.00, 1.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "c#r":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.00, 1.00], point2: [0.50, 0.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 1.00], point2: [1.00, 0.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "b":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        spline: [
          [0.30, 0.80],
          [0.70, 0.40],
          [0.50, 0.10],
          [0.30, 0.40],
          [0.70, 0.80],
        ]
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "tssk":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.10, 0.80], point2: [0.50, 0.20] }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        spline: [
          [0.60, 0.80],
          [0.90, 0.40],
          [0.75, 0.10],
          [0.60, 0.40],
          [0.90, 0.80],
        ]
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "k2togtbl":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.90, 0.80], point2: [0.50, 0.20] }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        spline: [
          [0.10, 0.80],
          [0.40, 0.40],
          [0.25, 0.10],
          [0.10, 0.40],
          [0.40, 0.80],
        ]
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "p2togtbl":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.60], point2: [0.40, 0.60] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "p2tog":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.60, 0.60], point2: [0.80, 0.60] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.80, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "mil":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.50, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
,
  success: (library) ->
    console.log "Saved library successfully."
  error: (library, error) ->
    console.log "Failed to save library: #{error.code}: #{error.message}"


library = new Parse.Object "Library"
library.save
  name: "Classic"
  data:
    "a":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#40e0d0"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "bp":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#bebebe"
          stroke: "#000000"
          "stroke-width": 1
      ,
        circle: { center: [0.50, 0.50], radius: 0.30 }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "ap":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#40e0d0"
          stroke: "#000000"
          "stroke-width": 1
      ,
        circle: { center: [0.50, 0.50], radius: 0.30 }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "error":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ff0000"
          stroke: "#ff0000"
          "stroke-width": 1
      ]
    "k":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "p":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#808080"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "ns":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "k3tog":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.80, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "k2tog":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.80, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "sk2p":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "ssk":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "cdd":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.50, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.20, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.50], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "yo":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        circle: { center: [0.50, 0.50], radius: 0.30 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "t#l":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [0.00, 0.00],
          [0.00, 1.00],
          [0.33, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [1.00, 0.00],
          [0.67, 0.00],
          [1.00, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "t#r":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [0.00, 0.00],
          [0.00, 1.00],
          [0.33, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ,
        polygon: [
          [1.00, 0.00],
          [0.67, 1.00],
          [1.00, 1.00],
        ]
        style:
          fill: "#7f7f7f"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "c#l":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.00, 0.00], point2: [0.50, 1.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.00], point2: [1.00, 1.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "c#r":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.00, 1.00], point2: [0.50, 0.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 1.00], point2: [1.00, 0.00] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "b":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        spline: [
          [0.30, 0.80],
          [0.70, 0.40],
          [0.50, 0.10],
          [0.30, 0.40],
          [0.70, 0.80],
        ]
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "tssk":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.10, 0.80], point2: [0.50, 0.20] }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        spline: [
          [0.60, 0.80],
          [0.90, 0.40],
          [0.75, 0.10],
          [0.60, 0.40],
          [0.90, 0.80],
        ]
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "k2togtbl":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.90, 0.80], point2: [0.50, 0.20] }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        spline: [
          [0.10, 0.80],
          [0.40, 0.40],
          [0.25, 0.10],
          [0.10, 0.40],
          [0.40, 0.80],
        ]
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "p2togtbl":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.60], point2: [0.40, 0.60] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "p2tog":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.60, 0.60], point2: [0.80, 0.60] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.80, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
    "mil":
      graphic: [
        rectangle: { topLeft: [0.00, 0.00], width: 1.00, height: 1.00 }
        style:
          fill: "#ffffff"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.20, 0.80], point2: [0.50, 0.20] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ,
        line: { point1: [0.50, 0.20], point2: [0.80, 0.80] }
        style:
          fill: "#000000"
          stroke: "#000000"
          "stroke-width": 1
      ]
,
  success: (library) ->
    console.log "Saved library successfully."
  error: (library, error) ->
    console.log "Failed to save library: #{error.code}: #{error.message}"

