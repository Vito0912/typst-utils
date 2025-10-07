#let toc(title, subtitle: none, body) = [
  #pad(
    top: 6em,
    [
      #align(center)[
        #text(title, size: 3em, weight: "bold")\
        #if subtitle != none {
          pad(top: 1em)[
            #text(subtitle, size: 1.5em, weight: "light")
          ]
        }
      ]
    ],
  )
  #pagebreak()
  #outline()
  #pagebreak()
  #counter(page).update(1)
  #set page(
    header: context [
      #text(title)
      #if subtitle != none {
        h(1fr)
        text(subtitle, weight: "light")
      }

    ],
    footer: context [
      Finn Dittmar
      #h(1fr)
      #counter(page).display(
        "1",
        both: false,
      )
    ],
  )
  #body
]
