#import "@preview/bullseye:0.1.0": show-target
#import "./custom/typki/typki.typ": with-deck

#let toc(title, subtitle: none, short: none, date: none, note: none, body) = [
  #context if not state("included", false).get() [
    #pad(
      top: 6em,
      [
        #align(left)[
          #text(title, size: 3em, weight: "bold")\
          #if subtitle != none {
            pad(top: 0em)[
              #text(subtitle, size: 2em)
            ]
          }
          #line()
          #text("Finn Dittmar", size: 1.5em, weight: "light")
          #if note != none {
            pad(top: 1em)[
              #text(note, size: 1.15em, weight: "light")
            ]
          }
          #if date != none {
            let parse(s) = toml.decode("date = " + s).date
            pad(top: 1em)[
              #text(
                parse(date).display(
                  "[day]. [month repr:long] [year]",
                ),
                size: 1.15em,
                weight: "light",
              )
            ]
          }
        ]
      ],
    )
    #pagebreak()
    #show: show-target(paged: doc => {
      outline()
      doc
    })
    #pagebreak()
    #counter(page).update(1)
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
        #if (date != none) {
          text(" - ")
          let parse(s) = toml.decode("date = " + s).date
          parse(date).display(
            "[day].[month].[year repr:last_two]",
          )
        }
        #h(1fr)
        #counter(page).display(
          "1",
          both: false,
        )
      ],
    )
    doc
  })

  #if short != none {
    show: with-deck.with(short)
    body
  } else {
    body
  }
]
