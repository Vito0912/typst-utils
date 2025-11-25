#import "@preview/zero:0.5.0": num, set-group, set-num, zi

#let math-style(body) = [
  #set-num(decimal-separator: ",", omit-unity-mantissa: false)
  #set-group(separator: sym.space.thin)

  #show math.equation: set text()

  #show math.equation: it => {
    show regex("\d+(\.\d*)?"): x => math.class("normal", num(x))
    show sym.ast: sym.dot
    show math.sum: math.limits(math.sum)
    show math.product: math.limits(math.product)
    it
  }

  #body
]

#let kgms = zi.declare("kgm/s^2")
