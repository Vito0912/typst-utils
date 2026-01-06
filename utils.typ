// Source JL710 //
#let __state = state("relative heading offset", 0)

#let offsetted(body) = context {
  set heading(offset: __state.get())
  body
}

#let init-relative-headings(body) = {
  show heading: it => {
    offsetted(it)
  }
  body
}

#let with-heading-offset(offset, body) = {
  __state.update(state => {
    state += offset
    state
  })
  offsetted(body)
  __state.update(state => {
    state -= offset
    state
  })
}
////

#let include-doc(docs, sub: false) = {
  state("included", 0).update(x => x + 1)
  for doc in docs {
    doc
  }
  state("included", 0).update(x => x - 1)
}

#let link-ref(target, text: none, show-page: true) = {
  context {
    let elements = query(target)
    if elements.len() == 1 {
      let element = elements.first()
      let query-text = if text != none { text } else { "Kapitel " + element.body }

      link(target, [#query-text #{
          if show-page [
            (p. #{ counter(page).at(element.location()).first() })
          ]
        } #sym.arrow.double.tr])
    } else {
      strong[Reference not in Documentation: #str(target)]
    }
  }
}

#let adv-table(..args) = {
  let inputs = args.named()
  let children = args.pos()

  let col-count = 1
  let cols = inputs.at("columns", default: 1)

  if type(cols) == int {
    col-count = cols
  } else if type(cols) == array {
    col-count = cols.len()
  }

  let styled-children = children
    .enumerate()
    .map(((i, child)) => {
      if i < col-count {
        set text(
          fill: white,
          weight: "bold",
        )
        align(center, child)
      } else {
        child
      }
    })

  table(
    stroke: none,
    column-gutter: .25em,
    row-gutter: .1em,
    fill: (_, row) => if row == 0 { luma(80) } else { luma(240) },

    ..inputs,
    ..styled-children
  )
}

