// Source JL710
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

#let include-doc(docs, sub: false) = {
  state("included", 0).update(x => x + 1)
  for doc in docs {
    doc
  }
  state("included", 0).update(x => x - 1)
}
