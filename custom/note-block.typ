#let note-block(
  body,
  type: "info",
  mark: none,
) = {
  let bg = if type == "info" or type == "emoji" { rgb("#11355f9d") } else if type == "warn" {
    rgb("#e0b81883")
  } else if (
    type == "danger"
  ) { rgb("#ce1e1e91") }

  let default-mark = if type == "info" { "ℹ️" } else if type == "warn" { "⚠️" } else if type == "danger" { "❌" } else {
    "💬"
  }

  let show-mark = if type == "emoji" and mark != none { mark } else { default-mark }

  block(
    width: 100%,
    inset: 8pt,
    fill: bg,
    radius: 6pt,
  )[
    #grid(
      columns: 2,
      column-gutter: 8pt,
      align: start + horizon,
    )[
      #box(
        width: 1.4em,
      )[
        #align(horizon + center)[ #show-mark ]
      ]

      #box(inset: 2pt)[
        #align(start + horizon)[
          #body
        ]
      ]
    ]
  ]
}
