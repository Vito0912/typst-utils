#import "@preview/bullseye:0.1.0": show-target
#import "./custom/typki/typki.typ": with-deck

#let toc(title, subtitle: none, short: none, date: none, body) = [
  #context if not state("included", false).get() [
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
  ] else [
    #heading([
      #if subtitle != none {
        subtitle
      } else {
        title
      }
    ])
  ]
  #show: show-target(paged: doc => {
    set page(
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
    body
  })

  #if short != none {
    show: with-deck.with(short)
  }
  #body
]
