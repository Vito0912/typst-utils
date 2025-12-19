#import "@preview/bullseye:0.1.0": show-target
#import "./custom/typki/typki.typ": with-deck
#import "utils.typ": with-heading-offset

#let toc(title, subtitle: none, short: none, date: none, note: none, heading-indent: none, body) = [
  #let subtitle-state = state("toc-subtitle", subtitle)
  #let title-state = state("toc-title", title)
  #let date-state = state("toc-date", date)
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
            let parse(s) = toml(bytes("date = " + s)).date
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
  #subtitle-state.update(subtitle)
  #title-state.update(title)
  #date-state.update(date)
  #context if not state("included", false).get() [
    #show: show-target(paged: doc => {
      set page(
        header: context [
          #text(title-state.get())
          #if subtitle-state.get() != none {
            h(1fr)
            text(subtitle-state.get(), weight: "light")
          }
        ],
        footer: context [
          Finn Dittmar
          #if (date-state.get() != none) {
            text(" - ")
            let parse(s) = toml(bytes("date = " + s)).date
            parse(date-state.get()).display(
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
  ] else [
    #if heading-indent != none {
      show: with-heading-offset.with(heading-indent)
      if short != none {
        show: with-deck.with(short)
        body
      } else {
        body
      }
    } else {
      show: with-heading-offset.with(1)
      if short != none {
        show: with-deck.with(short)
        body
      } else {
        body
      }
    }

  ]
]
