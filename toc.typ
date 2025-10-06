#let toc(title, body) = [
  #pad(
    top: 6em,
    [
      #align(center)[
        #text(title, size: 3em, weight: "bold")
      ]
    ],
  )
  #pagebreak()
  #outline()
  #pagebreak()
  #body
]
