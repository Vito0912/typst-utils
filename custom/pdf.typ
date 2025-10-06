#import "@preview/muchpdf:0.1.0": muchpdf

#let doc-pdf(data, ..args) = {
  for (i, arg) in args.pos().enumerate() {
    if arg == none {
      continue
    }
    muchpdf(data, pages: i + 1)
  }
}
