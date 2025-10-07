#import "@preview/muchpdf:0.1.1": muchpdf

#let doc-pdf(data, pages, scale: 1, cite-label: none, ..args) = {
  let parse-pages(spec) = {
    let result = ()

    for part in spec.split(",") {
      let part = part.trim()

      if part.contains("-") {
        let range-parts = part.split("-")
        let start = int(range-parts.at(0).trim())
        let end = int(range-parts.at(1).trim())

        for page in range(start, end + 1) {
          result.push(page - 1)
        }
      } else {
        result.push(int(part) - 1)
      }
    }

    return result
  }

  let parsed-pages = parse-pages(pages)

  if (args.pos().len() > 0) {
    for value in args.pos() {
      parsed-pages = parsed-pages.rev()
      let page = parsed-pages.pop()
      muchpdf(data, pages: page, scale: scale)
      if cite-label != none {
        cite(cite-label, supplement: "p." + page)
      }
      parsed-pages = parsed-pages.rev()
      [#value]
    }
  }

  muchpdf(data, pages: parsed-pages, scale: scale)
  if cite-label != none {
    cite(cite-label, supplement: "p. " + parsed-pages.map(n => str(n + 1)).join(", "))
  }
}
