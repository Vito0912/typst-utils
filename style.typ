#import "math.typ": *
#import "./custom/typki/typki.typ": math-framed
#import "@preview/gentle-clues:1.2.0": warning
#import "custom/typki/typki.typ" as typki
#import "utils.typ": init-relative-headings
#import "custom/example.typ": examples-outline

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

  #show: init-relative-headings

  #show: math-framed

  #show "TODO": warning()[TODO]

  #show link: underline

  // Code
  #show: codly-init.with()

  #show: typki.fix-html
  #show: typki.unwrap-aligns
  #show: typki.unwrap-paddings

  #codly(languages: codly-languages, zebra-fill: none)

  #body
]

#let sources(body, additionalSources: ()) = [
  #context if state("included", 0).get() == 0 [
    #examples-outline()

    #pagebreak()

    #let sourcesArray = (
      "/sources.yml",
    )

    #for source in additionalSources {
      sourcesArray.push(source)
    }

    #bibliography(
      sourcesArray,
      title: "Sources",
      full: false,
      style: "./common/cite-style.cls",
    )
  ]


  #body
]
