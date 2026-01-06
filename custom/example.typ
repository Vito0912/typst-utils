#import "note-block.typ": note-block

#let example(breakable: false, body) = {
  note-block(
    breakable: breakable,
    [
      #pad(
        [
          #underline([*Beispiel*])
        ],
        bottom: 0.2em,
      )
      #body
    ],
    color: rgb("#e0e0e08c"),
  )
}

#let definition(title, id, basic, level: 3, breakable: false, body) = {
  context { heading(title, level: level + state("relative heading offset", 0).get()) }

  note-block(
    breakable: breakable,
    basic(
      id,
      [
        #title
      ],
      [
        #pad(
          [
            #underline([*Definition*])
          ],
          bottom: 0.2em,
        )

        #body
      ],
    ),
  )
}

#let question(id, basic, question, answer) = {
  basic(
    id,
    [
      #underline(text(question, weight: "bold"))\
    ],
    [
      #answer\
    ],
    display: "all",
  )
}


#let example-state = state("example-state", ())
#let example-counter = counter("example-counter")

#let example-beta(body, show-link: true, custom-label: none) = {
  example-counter.step()

  example-state.update(examples => {
    examples.push((
      body: body,
      custom-label: custom-label,
    ))
    examples
  })

  context {
    let count = example-counter.get().first()
    let auto-lbl = label("example-" + str(count))
    let auto-lbl-back = label("example-" + str(count) + "-back")

    if show-link {
      let target = if custom-label != none { custom-label } else { auto-lbl }
      link(target)[Beispiel #count #sym.arrow.double.tr #auto-lbl-back]
    }
  }
}

#let example-define = example-beta

#let examples-outline(title: "Beispiele") = {
  heading(title, level: 1)

  context {
    let examples = example-state.final()
    for (i, ex) in examples.enumerate() {
      let count = i + 1
      let auto-lbl = label("example-" + str(count))
      let auto-lbl-back = label("example-" + str(count) + "-back")

      [
        #show figure.where(kind: "example"): set block(breakable: true)

        #block(
          [
            #pad(bottom: 0.2em)[#underline([*Beispiel #count*])]
            #ex.body
            #link(auto-lbl-back)[Zurück zur Referenz #sym.arrow.double.bl]
          ],
          fill: rgb("#e0e0e041"),
          radius: 8pt,
          inset: (x: 12pt, y: 8pt),
        )
        #if ex.custom-label != none { ex.custom-label } else { auto-lbl }
      ]
    }
  }
}
