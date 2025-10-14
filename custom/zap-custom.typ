#import "@preview/zap:0.4.0": component, ground, interface
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
