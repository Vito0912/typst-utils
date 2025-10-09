#import "math.typ": *
#import "./custom/typki/typki.typ": math-framed
#import "@preview/gentle-clues:1.2.0": warning

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#let style(body) = [
  #show: math-style
  #set text(font: "Open Sans")
  #set terms(separator: [: ])
  #set quote(block: true)

  #show terms: it => {
    block(fill: luma(235), inset: 0.5em)[#it]
  }

  #show: math-framed

  #show "TODO": warning()[TODO]

  #show link: underline

  // Code
  #show: codly-init.with()

  #codly(languages: codly-languages, zebra-fill: none)

  #body
]

#let sources(body) = [
  #pagebreak()

  #context if not state("included", false).get() [
    #bibliography(
      "/sources.yml",
      title: "Sources",
      full: false,
      style: "./common/cite-style.cls",
    )
  ]


  #body
]
