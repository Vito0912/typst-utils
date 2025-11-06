#import "note-block.typ": note-block

// TODO
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
  heading(title, level: level)

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
