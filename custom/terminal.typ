#let terminalColor = rgb("#f0f0f0")

#let terminal(terminal-text, output: none) = {
  grid(
    columns: 1,
    inset: 0pt,
    [
      #rect(
        height: 13pt,
        stroke: 1pt + terminalColor,
        fill: terminalColor,
        width: 100%,
        inset: 0.5pt,
        radius: (
          top-left: 5pt,
          top-right: 5pt,
        ),
      )[
        #grid(
          columns: (12pt, 12pt, 12pt, 1fr, 12pt, 12pt, 12pt),
          inset: 2pt,
          [
            #circle(
              fill: red,
              radius: 4pt,
            )
          ],
          [
            #circle(
              fill: yellow,
              radius: 4pt,
            )
          ],
          [
            #circle(
              fill: green,
              radius: 4pt,
            )
          ],
          [
            #align(horizon + center)[#text(size: 10pt, weight: "semibold")[Terminal]]
          ],
        )
      ]
    ],
    [
      #place(
        rect(
          height: 10pt,
          width: 100%,
          stroke: (top: terminalColor, left: terminalColor, right: terminalColor),
        ),
      )

      #if output != none {
        place(
          rect(
            height: 20pt,
            width: 100%,
            stroke: (top: terminalColor, left: terminalColor, right: terminalColor),
          ),
        )
      }

      #terminal-text


    ],
    if output != none {
      [
        #align(center)[
          #box(
            inset: 6pt,
            width: 100.2%,
            radius: (
              bottom: 5pt,
              top: 0pt,
            ),
            fill: rgb("#f1f1f1"),
            box(
              width: 99%,
              [
                #grid(
                  inset: 0pt,
                  output,
                  align(left)[

                    #set text(size: 8.5pt)

                    #text(fill: rgb("#12CC1A"))[#h(4pt) finn\@typst]:#text(fill: rgb("#12CC1A"))[\~]\$


                  ],
                )

              ],
            ),
          )]
      ]
    },
  )
}
