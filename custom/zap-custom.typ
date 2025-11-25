#import "@preview/zap:0.4.0": component, ground, interface
#import "@preview/zap:0.4.0" as zap: *
#import "@preview/cetz:0.4.2"

// Credits to JL710
#let battery(name, node, ..params) = {
  let custom-style = (
    width: .3,
    height: 1,
  )

  let draw(ctx, position, style) = {
    interface(
      (-custom-style.width / 2, -custom-style.height / 2),
      (custom-style.width / 2, custom-style.height / 2),
      io: position.len() < 2,
    )

    cetz.draw.line(
      (-custom-style.width / 2, -custom-style.height / 2),
      (-custom-style.width / 2, custom-style.height / 2),
      ..style,
    )

    cetz.draw.line(
      (custom-style.width / 2, -custom-style.height / 3),
      (custom-style.width / 2, custom-style.height / 3),
      ..style,
    )
  }

  component("battery", name, node, draw: draw, ..params)
}

///

#let device(name, node, ..params) = {
  let custom-style = (
    width: 1,
    height: 1,
  )

  let draw(ctx, position, style) = {
    interface(
      (-custom-style.width / 2, -custom-style.height / 2),
      (custom-style.width / 2, custom-style.height / 2),
      io: position.len() < 2,
    )

    cetz.draw.circle((0, 0), radius: (0.5, 0.5))
    cetz.draw.line((0.5, 0.35), (0.7, 0.35), ..style)
    cetz.draw.line((-0.7, 0.35), (-0.5, 0.35), ..style)
    cetz.draw.line((-0.6, 0.45), (-0.6, 0.25), ..style)
  }

  component(
    "device",
    name,
    node,
    draw: draw,
    label: (content: $upright(name)$, anchor: "center", distance: -0.45em),
    ..params,
  )
}

#let ground2(name, node, ..params) = {
  let custom-style = (
    width: 1,
    height: 1,
  )

  let draw(ctx, position, style) = {
    interface(
      (-custom-style.width / 2, -custom-style.height / 2),
      (custom-style.width / 2, custom-style.height / 2),
      io: position.len() < 2,
    )

    ground("g1", (0, -1), label: (content: [*GND*], anchor: "north-east", distance: 0em))
  }

  component(
    "ground-custom",
    name,
    node,
    draw: draw,
    ..params,
  )
}


#let logical-component(
  component-name,
  symbol,
  name,
  node,
  not-out: none,
  not-in: none,
  inputs: 2,
  outputs: 1,
  input-labels: none,
  output-labels: none,
  input-flanked: none,
  input-flanked-size: .28,
  height: 1.5,
  width: 1,
  in-out-length: .4,
  custom-inner-draw: (parent-rect, anchors) => {},
  ..params,
) = {
  let draw(ctx, position, style) = {
    import cetz.draw: anchor, circle, content, line, rect
    let radius = .12
    interface(
      (-(width / 2 + in-out-length), -height / 2),
      ((width / 2 + in-out-length), height / 2),
      io: true,
    )

    rect(
      (-width / 2, -height / 2),
      (width / 2, height / 2),
      stroke: .5pt,
      name: "main-box",
    )

    content(
      "main-box",
      symbol,
    )

    // inputs
    let input-wall-mounts = ()
    let input-flank-positions = ()
    for value in (range(0, inputs)) {
      let in-name = "in" + str(value + 1)
      let wall-mount-point = (
        "main-box.west",
        "|-",
        (
          "main-box.north-west",
          (100% / (inputs + 1)) * (value + 1),
          "main-box.south-west",
        ),
      )
      input-wall-mounts.push(wall-mount-point)

      if input-labels != none {
        let pos = wall-mount-point
        if input-flanked != none and input-flanked.at(value) {
          pos = (rel: (input-flanked-size, 0), to: wall-mount-point)
        }
        content(pos, padding: .3em, anchor: "west", input-labels.at(value))
      }
      if input-flanked != none and input-flanked.at(value) {
        let flank-corners = (
          top: (rel: (0, input-flanked-size / 2), to: wall-mount-point),
          bottom: (rel: (0, -input-flanked-size / 2), to: wall-mount-point),
          middle: (rel: (input-flanked-size, 0), to: wall-mount-point),
        )
        input-flank-positions.push(flank-corners)
        cetz.draw.merge-path(
          {
            line(
              (rel: (input-flanked-size, 0), to: wall-mount-point),
              (rel: (0, input-flanked-size / 2), to: wall-mount-point),
            )
            line(
              (rel: (0, input-flanked-size / 2), to: wall-mount-point),
              (rel: (0, -input-flanked-size / 2), to: wall-mount-point),
            )
            line(
              (rel: (0, -input-flanked-size / 2), to: wall-mount-point),
              (rel: (input-flanked-size, 0), to: wall-mount-point),
            )
            line(
              (rel: (input-flanked-size, 0), to: wall-mount-point),
              (rel: (input-flanked-size, 0), to: wall-mount-point),
            )
            line(
              (rel: (input-flanked-size, 0), to: wall-mount-point),
              (rel: (0, input-flanked-size / 2), to: wall-mount-point),
            )
          },
          stroke: .5pt,
        )
      } else {
        input-flank-positions.push(none)
      }

      anchor(
        in-name,
        (rel: (-in-out-length, 0), to: wall-mount-point),
      )

      if not-in != none and not-in.at(value) {
        circle(
          (rel: (-radius, 0), to: wall-mount-point),
          radius: radius,
          stroke: .5pt,
        )
        wire(in-name, (rel: (-radius * 2, 0), to: wall-mount-point))
      } else {
        wire(in-name, wall-mount-point)
      }
    }

    // outputs
    let output-wall-mounts = ()
    for value in (range(0, outputs)) {
      let out-name = "out" + str(value + 1)
      let wall-mount-point = (
        "main-box.east",
        "|-",
        (
          "main-box.north-east",
          (100% / (outputs + 1)) * (value + 1),
          "main-box.south-east",
        ),
      )
      output-wall-mounts.push(wall-mount-point)

      if output-labels != none {
        content(wall-mount-point, padding: .3em, anchor: "east", output-labels.at(value))
      }

      anchor(
        out-name,
        (
          rel: (in-out-length, 0),
          to: wall-mount-point,
        ),
      )

      if not-out != none and not-out.at(value) {
        circle(
          (rel: (radius, 0), to: wall-mount-point),
          radius: radius,
          stroke: .5pt,
        )
        wire(out-name, (rel: (radius * 2, 0), to: wall-mount-point))
      } else {
        wire(out-name, wall-mount-point)
      }
    }
    custom-inner-draw(
      "main-box",
      (
        input-wall-mounts: input-wall-mounts,
        output-wall-mounts: output-wall-mounts,
        input-flanks: input-flank-positions,
      ),
    )
  }

  component(component-name, name, node, draw: draw, ..params)
}


#let or-gate = logical-component.with(
  "or-gate",
  [#sym.gt.eq 1],
)
#let and-gate = logical-component.with(
  "and-gate",
  "&",
)
#let nand-gate = logical-component.with(
  "nand-gate",
  "&",
  not-out: (true,),
)
#let nor-gate = logical-component.with(
  "nor-gate",
  [#sym.gt.eq 1],
  not-out: (true,),
)
#let xor-gate = logical-component.with(
  "xor-gate",
  "=1",
)
#let xnor-gate = logical-component.with(
  "xnor-gate",
  "=",
)
#let xnor-gate2 = logical-component.with(
  "xnor-gate",
  "=1",
  not-out: (true,),
)
#let not-gate = logical-component.with(
  "not-gate",
  "1",
  not-out: (true,),
  inputs: 1,
)
#let d-flip-flop = logical-component.with(
  "d",
  "",
  inputs: 2,
  outputs: 2,
  input-labels: ("D", "C"),
  output-labels: ("Q", overline[Q]),
  input-flanked: (false, true),
  width: 1.5,
  not-out: (false, true),
)
#let t-flip-flop = logical-component.with(
  "t",
  "",
  inputs: 2,
  outputs: 2,
  input-labels: ("T", "C"),
  output-labels: ("Q", overline[Q]),
  input-flanked: (false, true),
  width: 1.5,
  not-out: (false, true),
)
#let sr-flip-flop = logical-component.with(
  "sr",
  "",
  inputs: 2,
  outputs: 2,
  input-labels: ("S", "R"),
  output-labels: ("Q", overline[Q]),
  not-out: (false, true),
)
#let sr-flip-flop-takt = logical-component.with(
  "sr-t",
  "",
  inputs: 3,
  outputs: 2,
  input-labels: ("S", "G", "R"),
  output-labels: ("Q", overline[Q]),
  not-out: (false, true),
  height: 2,
)
#let sr-flip-flop-flank = logical-component.with(
  "sr-f",
  "",
  inputs: 3,
  outputs: 2,
  input-labels: ("S", "", "R"),
  output-labels: ("Q", overline[Q]),
  not-out: (false, true),
  input-flanked: (false, true, false),
  height: 2,
)
#let jk-flip-flop-flank = logical-component.with(
  "jk-flip-flop-flank",
  "",
  width: 1.5,
  height: 2,
  inputs: 3,
  outputs: 2,
  input-flanked: (false, true, false),
  not-out: (false, true),
  input-labels: ([J], [C], [K]),
  output-labels: ([Q], overline[Q]),
)


#zap.circuit({
  import zap: *

  and-gate("and", (0, 0))
  nand-gate("nand", (0, -2))
  or-gate("or", (2, 0))
  nor-gate("nor", (2, -2))
  xor-gate("xor", (4, 0))
  xnor-gate("xnor", (4, -2))
  not-gate("not", (6, -1))

  sr-flip-flop("sr", (0, -4))
  d-flip-flop("d", (2.5, -4))
  t-flip-flop("t", (5, -4))

  sr-flip-flop-takt("sr-takt", (0, -6.25))
  sr-flip-flop-flank("sr-flank", (2, -6.25))
  jk-flip-flop-flank("jk-flank", (5, -6.25))
})
