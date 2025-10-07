#import "@preview/zero:0.5.0": num, set-group, set-num, zi

#let math-style(body) = [
  #set-num(decimal-separator: ",", omit-unity-mantissa: false)
  #set-group(separator: ".")

  #show math.equation: set text(size: 16pt)

  #show math.equation: it => {
    show regex("\d+(\.\d*)?"): x => math.class("normal", num(x))
    it
  }

  #body
]

#let kgms = zi.declare("kgm/s^2")
