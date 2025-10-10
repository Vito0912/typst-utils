#let note-block(
  body,
  type: "info",
  mark: none,
  color: none,
) = {
  let bg = if type == "info" or type == "emoji" { rgb("#1670d671") } else if type == "warn" {
    rgb("#ebe70f73")
  } else if (
    type == "danger"
  ) { rgb("#ce1e1e91") }

  let default-mark = if type == "info" { "ℹ️" } else if type == "warn" { "⚠️" } else if type == "danger" { "❌" } else {
    "💬"
  }

  if color != none {
    bg = color
  }

  let show-mark = if type == "emoji" and mark != none { mark } else { default-mark }

  block(
    width: 100%,
    inset: 8pt,
    fill: bg,
    radius: 6pt,
  )[

    #table(
      columns: 2,
      stroke: none,
      [
        #text(show-mark, size: 1.5em)
      ],
      [
        #body
      ],
    )

  ]
}
