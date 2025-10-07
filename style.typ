#import "math.typ": *

#let style(body) = [
  #show: math-style
  #set text(font: "Open Sans")
  #set terms(separator: [: ])

  #show terms: it => {
    block(fill: luma(235), inset: 0.5em)[#it]
  }

  #show link: underline
  #body
]

#let sources(body) = [
  #bibliography(
    "/sources.yml",
    title: "Sources",
    full: false,
    // TODO: custom style
    style: "ieee",
  )
  #body
]
