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
          result.push(page)
        }
      } else {
        result.push(int(part))
      }
    }

    return result
  }

  let parsed-pages = parse-pages(pages)

  let i = 0

  while parsed-pages.len() > i {
    let page = parsed-pages.at(i)
    image(data, page: page, format: "pdf", width: scale * 100%)


    if args.pos().len() > i {
      [#args.pos().at(i)]
    }

    i += 1
  }

  if cite-label != none {
    cite(cite-label, supplement: "p. " + parsed-pages.map(n => str(n)).join(", "))
  }
}
