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

#let example-beta(body, show-link: true, custom-label: none, text: none) = {
  example-counter.step()

  example-state.update(examples => {
    examples.push((
      body: body,
      custom-label: custom-label,
      text: text,
    ))
    examples
  })

  context {
    let count = example-counter.get().first()
    let auto-lbl = label("example-" + str(count))
    let auto-lbl-back = label("example-" + str(count) + "-back")

    if show-link {
      let target = if custom-label != none { custom-label } else { auto-lbl }
      if text != none {
        link(target)[#text (#count) #sym.arrow.double.tr #auto-lbl-back]
      } else {
        link(target)[Beispiel #count #sym.arrow.double.tr #auto-lbl-back]
      }
    }
  }
}

#let example-define = example-beta

// I honestly don't care but should it be relevant, consider this sample 0BSD licensed - Cady B.
// https://opensource.org/license/0BSD
// For the original discussion see https://discord.com/channels/1054443721975922748/1458429883612008510 answered by pink_3d (Discord: 284602593597194250)
#let fancy-block(body, radius: 8pt, stroke: rgb("#aaaaaaaa")) = context {
  let start = here()
  let marker = <fancy-block-end>
  let c = counter("fancy-block-counter")
  c.update(0)

  [#grid(
      columns: 100%, inset: radius,
      grid.header(grid.cell(inset: (bottom: radius, rest: 0pt), context if c.get().first() == 0 {
        place(curve(
          stroke: stroke,
          curve.move((0pt, radius)),
          curve.quad((0pt, 0pt), (radius, 0pt)),
          curve.line((100% - radius, 0pt)),
          curve.quad((100%, 0pt), (100%, radius)),
        ))
      }
        + c.step())),
      grid.cell(stroke: (x: stroke), inset: (y: 4pt), body),
      grid.footer(grid.cell(inset: (top: radius, rest: 0pt), context if c.get().first()
        == c.at(query(selector(marker).after(start)).first().location()).first() {
        place(curve(
          stroke: stroke,
          curve.move((0pt, -radius)),
          curve.quad((0pt, 0pt), (radius, 0pt)),
          curve.line((100% - radius, 0pt)),
          curve.quad((100%, 0pt), (100%, -radius)),
        ))
      }))
    )
    #[]#marker]
}

#let examples-outline(title: "Beispiele") = {
  context {
    let examples = example-state.final()

    if examples.len() == 0 {
      return
    }
    heading(title, level: 1)

    for (i, ex) in examples.enumerate() {
      let count = i + 1
      let auto-lbl = label("example-" + str(count))
      let auto-lbl-back = label("example-" + str(count) + "-back")
      let stroke-color = rgb("#aaaaaa79")

      [
        #show figure.where(kind: "example"): set block(breakable: true)

        #fancy-block(
          [
            #pad(bottom: 0.2em)[
              #if ex.text != none [
                #underline([*#ex.text* (Beispiel #count)])
              ] else [#underline([*Beispiel #count*])]
              #h(1fr)
              #link(
                auto-lbl-back,
              )[Zurück zur Referenz #sym.arrow.double.bl]]
            #ex.body
          ],
          stroke: stroke-color,
        )

        #if ex.custom-label != none { ex.custom-label } else { auto-lbl }
      ]
    }
  }
}
