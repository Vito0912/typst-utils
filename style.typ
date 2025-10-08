#import "math.typ": *
#import "./custom/typki/typki.typ": math-framed
#import "@preview/gentle-clues:1.2.0": warning

#let style(body) = [
  #show: math-style
  #set text(font: "Open Sans")
  #set terms(separator: [: ])

  #show terms: it => {
    block(fill: luma(235), inset: 0.5em)[#it]
  }

  #show: math-framed

  #show "TODO": warning()[TODO]

  #show link: underline
  #body
]

#let sources(body) = [
  #pagebreak()
  #bibliography(
    "/sources.yml",
    title: "Sources",
    full: false,
    style: "./common/cite-style.cls",
  )
  #body
]
