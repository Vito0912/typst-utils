#import "/typst-utils/main.typ": *
#show: style

#context if not state("included", false).get() [
  #show: toc.with("Title", subtitle: "Subtitle", short: "Short")
]

#let (basic, note, cloze, basic-reverse, tabki) = set-typki-offset(0)

#context if not state("included", false).get() [
  #show: sources
]
