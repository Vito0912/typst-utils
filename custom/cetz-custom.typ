#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"

#let vector(
  coordinates,
  label: none,
  start-label: none,
  end-label: none,
  origin: none,
  show-arrow: true,
  use-math: false,
  label-pos: "angled",
  ..style,
) = {
  (
    type: "vector",
    coordinates: coordinates,
    label: label,
    start-label: start-label,
    end-label: end-label,
    origin: origin,
    style: style.named(),
    show-arrow: show-arrow,
    use-math: use-math,
    label-pos: label-pos,
  )
}

#let plane(
  coordinates,
  label: none,
  ..style,
) = {
  (
    type: "plane",
    coordinates: coordinates,
    label: label,
    style: style.named(),
  )
}

#let vector-builder(
  ..args,
) = {
  let vectors = args.pos()
  let options = args.named()

  let add-vec(a, b) = (a.at(0) + b.at(0), a.at(1) + b.at(1))

  let resolved-data = vectors.fold(
    (
      anchors: (:),
      vecs: (),
      bounds: (min-x: none, max-x: none, min-y: none, max-y: none),
    ),
    (state, v) => {
      if type(v) != dictionary or v.at("type", default: "") != "vector" {
        panic(
          "Invalid argument: All positional arguments must be created using the vec() helper.",
        )
      }

      let anchors = state.anchors
      let vecs = state.vecs
      let bounds = state.bounds

      let coords = v.coordinates
      let start = (0, 0)
      let end = coords

      if v.origin != none {
        start = v.origin
        if type(start) == str { start = anchors.at(start) }
        end = add-vec(start, coords)
      } else {
        if (
          type(coords) == array and coords.len() == 2 and type(coords.at(0)) != int and type(coords.at(0)) != float
        ) {
          start = coords.at(0)
          end = coords.at(1)
        }
        if type(start) == str { start = anchors.at(start) }
        if type(end) == str { end = anchors.at(end) }
      }

      if v.label != none {
        anchors.insert(v.label + ".start", start)
        anchors.insert(v.label + ".end", end)
      }

      let x-vals = (start.at(0), end.at(0))
      let y-vals = (start.at(1), end.at(1))

      let new-bounds = (
        min-x: if bounds.min-x == none { calc.min(..x-vals) } else {
          calc.min(bounds.min-x, ..x-vals)
        },
        max-x: if bounds.max-x == none { calc.max(..x-vals) } else {
          calc.max(bounds.max-x, ..x-vals)
        },
        min-y: if bounds.min-y == none { calc.min(..y-vals) } else {
          calc.min(bounds.min-y, ..y-vals)
        },
        max-y: if bounds.max-y == none { calc.max(..y-vals) } else {
          calc.max(bounds.max-y, ..y-vals)
        },
      )

      let new-v = v + (resolved-start: start, resolved-end: end)

      (anchors: anchors, vecs: vecs + (new-v,), bounds: new-bounds)
    },
  )

  let auto-bounds = resolved-data.bounds
  if auto-bounds.min-x == none {
    auto-bounds = (min-x: -5, max-x: 5, min-y: -5, max-y: 5)
  }

  let plot-width = options.at("width", default: 10)
  let plot-height = options.at("height", default: 10)
  let _ = options.remove("width")
  let _ = options.remove("height")

  let padding = 1

  let user-x-min = options.at("x-min", default: options.at(
    "min-x",
    default: none,
  ))
  let user-x-max = options.at("x-max", default: options.at(
    "max-x",
    default: none,
  ))
  let user-y-min = options.at("y-min", default: options.at(
    "min-y",
    default: none,
  ))
  let user-y-max = options.at("y-max", default: options.at(
    "max-y",
    default: none,
  ))

  let _ = options.remove("min-x")
  let _ = options.remove("max-x")
  let _ = options.remove("min-y")
  let _ = options.remove("max-y")

  let final-x-min = if user-x-min != none { user-x-min } else {
    auto-bounds.min-x - padding
  }
  let final-x-max = if user-x-max != none { user-x-max } else {
    auto-bounds.max-x + padding
  }
  let final-y-min = if user-y-min != none { user-y-min } else {
    auto-bounds.min-y - padding
  }
  let final-y-max = if user-y-max != none { user-y-max } else {
    auto-bounds.max-y + padding
  }

  let default-settings = (
    size: (plot-width, plot-height),
    axis-style: "school-book",
    x-grid: "both",
    y-grid: "both",
    x-label: $x$,
    y-label: $y$,
    x-tick-step: 1,
    y-tick-step: 1,
    x-minor-tick-step: 0.5,
    y-minor-tick-step: 0.5,
    x-min: final-x-min,
    x-max: final-x-max,
    y-min: final-y-min,
    y-max: final-y-max,
  )

  let final-options = default-settings + options

  cetz.canvas({
    import cetz.draw: *
    import cetz-plot: plot

    plot.plot(..final-options, {
      for v in resolved-data.vecs {
        let start = v.resolved-start
        let end = v.resolved-end

        let dx = end.at(0) - start.at(0)
        let dy = end.at(1) - start.at(1)
        let vec-length = calc.sqrt(dx * dx + dy * dy)
        let angle = calc.atan2(dx, dy)

        let display-angle = angle
        let normal-multiplier = 1

        if display-angle > 90deg or display-angle < -90deg {
          display-angle += 180deg
          normal-multiplier = -1
        }

        let nx = 0
        let ny = 1

        if vec-length != 0 {
          nx = (-dy / vec-length) * normal-multiplier
          ny = (dx / vec-length) * normal-multiplier
        }

        let label-dist = 0.3
        let label-rotation = display-angle

        if v.label-pos == "upright" {
          label-rotation = 0deg
        }

        let mid-x = (start.at(0) + end.at(0)) / 2
        let mid-y = (start.at(1) + end.at(1)) / 2
        let label-pos = (mid-x + nx * label-dist, mid-y + ny * label-dist)

        let start-label-pos = (start.at(0) + nx * label-dist, start.at(1) + ny * label-dist)
        let end-label-pos = (end.at(0) + nx * label-dist, end.at(1) + ny * label-dist)

        let stroke = v.style.at("stroke", default: black)
        let fill-color = if type(stroke) == dictionary {
          stroke.at("paint", default: black)
        } else {
          stroke
        }

        plot.annotate(
          {
            line(
              start,
              end,
              mark: (end: "triangle", fill: fill-color, scale: 0.7),
              name: v.label,
              ..v.style,
            )

            if v.label != none {
              content(
                label-pos,
                angle: label-rotation,
                box(
                  fill: white.transparentize(20%),
                  radius: 2pt,
                  inset: 2pt,
                  {
                    let label = v.label
                    if v.use-math {
                      label = eval(label, mode: "math")
                    }
                    if (v.show-arrow) {
                      math.arrow(label)
                    } else {
                      label
                    }
                  },
                ),
                anchor: "center",
              )
            }
            if v.start-label != none {
              content(
                start-label-pos,
                box(
                  fill: white.transparentize(20%),
                  radius: 2pt,
                  inset: 2pt,
                  [#v.start-label],
                ),
                anchor: "center",
              )
            }
            if v.end-label != none {
              content(
                end-label-pos,
                box(
                  fill: white.transparentize(20%),
                  radius: 2pt,
                  inset: 2pt,
                  [#v.end-label],
                ),
                anchor: "center",
              )
            }
          },
          resize: false,
        )
      }
    })
  })
}


#let problem-1 = vector-builder.with(
  width: 5,
  height: 5,
  min-y: -.5,
  min-x: -.5,
  max-x: 3,
  max-y: 3,
)
