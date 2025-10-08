#import "note-block.typ": note-block

// TODO
#let example(body) = {
  note-block(
    body,
  )
}

#let definition(title, id, basic, body) = {
  heading(title, level: 3)

  note-block(
    basic(
      id,
      [#title],
      [#body],
    ),
  )
}
