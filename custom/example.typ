#import "note-block.typ": note-block
#import "typki/typki.typ": display_all

// TODO
#let example(body) = {
  note-block(
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

#let definition(title, id, basic, body) = {
  heading(title, level: 3)

  note-block(
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
    display: display_all,
  )
}
