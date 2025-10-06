#import "@preview/muchpdf:0.1.1": muchpdf

#let doc-pdf(data, pages, ..args) = {
  let parse-pages(spec) = {
    let result = ()

    for part in spec.split(",") {
      let part = part.trim()

      if part.contains("-") {
        let range-parts = part.split("-")
        let start = int(range-parts.at(0).trim())
        let end = int(range-parts.at(1).trim())

        for page in range(start, end + 1) {
          result.push(page)
        }
      } else {
        result.push(int(part))
      }
    }

    return result
  }

  let parsed-pages = parse-pages(pages)

  if (args.pos().len() > 0) {
    for value in args.pos() {
      parsed-pages = parsed-pages.rev()
      muchpdf(data, pages: parsed-pages.pop())
      parsed-pages = parsed-pages.rev()
      [#value]
    }
  }

  muchpdf(data, pages: parsed-pages)
}
