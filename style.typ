#let style(body) = [
  #set text(font: "Open Sans")
  #set terms(separator: [: ])
  #set page(
    footer: context [
      Finn Dittmar
      #h(1fr)
      #counter(page).display(
        "1",
        both: false,
      )
    ],
  )

  #show terms: it => {
    block(fill: luma(235), inset: 0.5em)[#it]
  }

  #show link: underline
  #body
]
