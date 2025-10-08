#import "@preview/suiji:0.4.0": *
#import "typki/typki.typ" as typki

#let rand-hex-digit = rng => {
  let (new-rng, d) = integers-f(rng, low: 0, high: 15)
  (new-rng, str(d, base: 16))
}

#let globalOffset = state("globalOffset", 0)

#let gen-uuidv4 = rng => {
  let hex = ()
  let new-rng = rng

  // 32 hex
  for i in range(32) {
    let digit
    (new-rng, digit) = rand-hex-digit(new-rng)
    hex.push(digit)
  }

  hex.at(12) = "4"

  let vidx
  (new-rng, vidx) = integers-f(new-rng, low: 0, high: 3)
  let variant = ("8", "9", "a", "b").at(vidx)
  hex.at(16) = variant

  let uuid = (
    hex.slice(0, 8).join("")
      + "-"
      + hex.slice(8, 12).join("")
      + "-"
      + hex.slice(12, 16).join("")
      + "-"
      + hex.slice(16, 20).join("")
      + "-"
      + hex.slice(20, 32).join("")
  )

  (new-rng, uuid)
}

#let note(id, field1, field2, note-type: none, deck: none, display: typki.display_field2, offset: 0) = {
  if offset == 0 {
    panic(
      "Offset must be set manually to avoid ID collisions. Set with #set-typki-offset(<offset>).",
    )
  }
  let (rng, uuid) = gen-uuidv4(gen-rng-f(id + offset))
  typki.note(uuid, field1, field2, note-type: note-type, deck: deck, display: display)
}

#let basic(id, field1, field2, deck: none, display: typki.display_field2, offset: 0) = {
  if offset == 0 {
    panic(
      "Offset must be set manually to avoid ID collisions. Set with #set-typki-offset(<offset>).",
    )
  }
  let (rng, uuid) = gen-uuidv4(gen-rng-f(id + offset))
  typki.basic(uuid, field1, field2, deck: deck, display: display)
}

#let basic-reverse(id, field1, field2, deck: none, display: typki.display_field2, offset: 0) = {
  if offset == 0 {
    panic(
      "Offset must be set manually to avoid ID collisions. Set with #set-typki-offset(<offset>).",
    )
  }
  let (rng, uuid) = gen-uuidv4(gen-rng-f(id + offset))
  typki.basic-reverse(uuid, field1, field2, deck: deck, display: display)
}

#let cloze(id, field1, deck: none, display: typki.display_field1, offset: 0) = {
  if offset == 0 {
    panic(
      "Offset must be set manually to avoid ID collisions. Set with #set-typki-offset(<offset>).",
    )
  }
  let (rng, uuid) = gen-uuidv4(gen-rng-f(id + offset))
  typki.cloze(uuid, field1, deck: deck, display: display)
}


#let tabki(
  starting-id,
  offset: 0,
  ..children,
) = {
  let entries = ()
  let n = 0
  let items = children.pos()

  if offset == 0 {
    panic(
      "Offset must be set manually to avoid ID collisions. Set with #set-typki-offset(<offset>).",
    )
  }

  while n < (items.len() / 2) {
    let index1 = 2 * n
    let index2 = 2 * n + 1

    let card = basic(
      starting-id + n + offset - 1,
      offset: -1,
      items.at(index1),
      items.at(index2),
      display: typki.display_array,
    )

    entries.push(card.at(0))
    entries.push(card.at(1))

    n = n + 1
  }

  table(
    columns: 2,
    ..entries,
  )
}

#let set-typki-offset(offset) = {
  (
    basic.with(offset: offset),
    note.with(offset: offset),
    cloze.with(offset: offset),
    basic-reverse.with(offset: offset),
    tabki.with(offset: offset),
  )
}
