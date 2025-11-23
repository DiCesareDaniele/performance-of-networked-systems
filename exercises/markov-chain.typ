#import "@preview/cetz:0.4.2"
#import "@preview/equate:0.3.2": equate, share-align

#let nodes-iter(C, b) = {
  let (bx, by, bz) = b
  let nodes = ()
  for z in range(int(C / bz) + 1) {
    for y in range(int(C / by) + 1) {
      for x in range(int(C / bx) + 1) {
        let c = bx * x + by * y + bz * z
        if c <= C {
          nodes.push((c, (x, y, z)))
        }
      }
    }
  }
  return nodes
}

#let draw-markov-chain(C, b, labels) = {
  cetz.canvas(
    length: 0.8cm,
    {
      import cetz.draw: *

      let inc = 4
      let text-pad = 0.1
      let x-line-pad = 0.3
      let y-line-pad = 0.1
      let stroke = 0.5pt
      let arrow-style = (
        mark: (end: "straight", fill: black),
        stroke: stroke,
      )

      let to_pos(state) = {
        let (x, y, z) = state
        assert(
          y == 0 or z == 0,
          message: "in this diagram y and z cannot be simultaniously non zero",
        )
        (x * inc, (z - y) * inc)
      }

      let to_label(state) = {
        let (x, y, z) = state
        str(x) + "," + str(y) + "," + str(z)
      }

      let to_name(state) = {
        let (x, y, z) = state
        str(x) + "-" + str(y) + "-" + str(z)
      }

      let node(state) = {
        let pos = to_pos(state)
        let name = to_name(state)
        let label = to_label(state)
        circle(
          pos,
          radius: 0.5,
          name: name,
          stroke: stroke,
        )
        content(pos, label)
      }

      let arrow-east(start, end, label) = {
        let ns = to_name(start)
        let ne = to_name(end)
        let name = ns + "-line"
        line(
          (rel: (x-line-pad, -y-line-pad), to: ns + ".north-east"),
          (rel: (-x-line-pad, -y-line-pad), to: ne + ".north-west"),
          ..arrow-style,
          name: name,
        )
        content(
          (rel: (0, text-pad), to: name),
          label,
          anchor: "south",
        )
      }

      let arrow-south(start, end, label) = {
        let ns = to_name(start)
        let ne = to_name(end)
        let name = ns + "-line"
        line(
          (rel: (-y-line-pad, -x-line-pad), to: ns + ".south-east"),
          (rel: (-y-line-pad, x-line-pad), to: ne + ".north-east"),
          ..arrow-style,
          name: name,
        )
        content(
          (rel: (text-pad, 0), to: name),
          label,
          anchor: "west",
        )
      }

      let arrow-west(start, end, label) = {
        let ns = to_name(start)
        let ne = to_name(end)
        let name = ns + "-line"
        line(
          (rel: (-x-line-pad, y-line-pad), to: ns + ".south-west"),
          (rel: (x-line-pad, y-line-pad), to: ne + ".south-east"),
          ..arrow-style,
          name: name,
        )
        content(
          (rel: (0, -text-pad), to: name),
          label,
          anchor: "north",
        )
      }

      let arrow-north(start, end, label) = {
        let ns = to_name(start)
        let ne = to_name(end)
        let name = ns + "-line"
        line(
          (rel: (y-line-pad, x-line-pad), to: ns + ".north-west"),
          (rel: (y-line-pad, -x-line-pad), to: ne + ".south-west"),
          ..arrow-style,
          name: name,
        )
        content(
          (rel: (-text-pad, 0), to: name),
          label,
          anchor: "east",
        )
      }

      let (bx, by, bz) = b
      let (lx, ly, lz) = labels

      for (_, n) in nodes-iter(C, b) {
        node(n)
      }
      for (c, (x, y, z)) in nodes-iter(C, b) {
        if c + bx <= C {
          arrow-east((x, y, z), (x + 1, y, z), $lambda_#lx$)
        }
        if c + by <= C {
          arrow-south((x, y, z), (x, y + 1, z), $lambda_#ly$)
        }
        if c + bz <= C {
          arrow-north((x, y, z), (x, y, z + 1), $lambda_#lz$)
        }
        if x > 0 {
          arrow-west((x, y, z), (x - 1, y, z), $#if x != 1 { x } mu_#lx$)
        }
        if y > 0 {
          arrow-north((x, y, z), (x, y - 1, z), $#if y != 1 { y } mu_#ly$)
        }
        if z > 0 {
          arrow-south((x, y, z), (x, y, z - 1), $#if z != 1 { z } mu_#lz$)
        }
      }
    },
  )
}

#let balance-equations(C, b, labels) = {
  let (bx, by, bz) = b
  let (lx, ly, lz) = labels

  show: equate
  set math.equation(numbering: "(1)")
  share-align(
    for (i, (c, (x, y, z))) in nodes-iter(C, b).enumerate() {
      let lhs = ()
      let rhs = ()
      if c + bx <= C {
        lhs.push($lambda_#lx$)
        rhs.push($#if x != 0 { x + 1 } mu_#lx pi (#{ x + 1 },#y,#z)$)
      }
      if c + by <= C {
        lhs.push($lambda_#ly$)
        rhs.push($#if y != 0 { y + 1 } mu_#ly pi (#x,#{ y + 1 },#z)$)
      }
      if c + bz <= C {
        lhs.push($lambda_#lz$)
        rhs.push($#if z != 0 { z + 1 } mu_#lz pi (#x,#y,#{ z + 1 })$)
      }
      if x > 0 {
        lhs.push(if x == 1 { $mu_#lx$ } else { $#x mu_#lx$ })
        rhs.push($lambda_#lx pi (#{ x - 1 },#y,#z)$)
      }
      if y > 0 {
        lhs.push(if y == 1 { $mu_#ly$ } else { $#y mu_#ly$ })
        rhs.push($lambda_#ly pi (#x,#{ y - 1 },#z)$)
      }
      if z > 0 {
        lhs.push(if z == 1 { $mu_#lz$ } else { $#z mu_#lz$ })
        rhs.push($lambda_#lz pi (#x,#y,#{ z - 1 })$)
      }

      let par = lhs.len() != 1
      let left = $#if par { $($ } #lhs.join($+$) #if par { $)$ }$
      let right = $#rhs.join($+$)$
      text(
        size: 0.8em,
        [$ left pi (#x,#y,#z) & = right $ #label("mk_" + str(i + 1))],
      )
      linebreak()
    },
  )
}

#let state-prob(C, b, p) = {
  let G = 0.0
  let (px, py, pz) = p
  for (_, (x, y, z)) in nodes-iter(C, b) {
    G += (calc.pow(px, x) / calc.fact(x)) * (calc.pow(py, y) / calc.fact(y)) * (calc.pow(pz, z) / calc.fact(z))
  }

  let prob = ()
  for (_, (x, y, z)) in nodes-iter(C, b) {
    prob.push(
      1 / G * (calc.pow(px, x) / calc.fact(x)) * (calc.pow(py, y) / calc.fact(y)) * (calc.pow(pz, z) / calc.fact(z)),
    )
  }
  (G, prob)
}

#let product-form(C, b, labels, p) = {
  let (G, prob) = state-prob(C, b, p)

  $G = #G$
  linebreak()
  for (i, (_, (x, y, z))) in nodes-iter(C, b).enumerate() {
    let v = prob.at(i)
    $pi (#x,#y,#z) = #v$
    linebreak()
  }
}

#let blocking-prob(C, b, labels, p) = {
  let (G, prob) = state-prob(C, b, p)

  let (bx, by, bz) = b
  let (lx, ly, lz) = labels

  for (bk, lk) in b.zip(labels) {
    let block-states = ()
    let block-prob = 0.0
    for (i, (c, (x, y, z))) in nodes-iter(C, b).enumerate() {
      if c + bk > C {
        block-states.push($pi (#x,#y,#z)$)
        block-prob += prob.at(i)
      }
    }
    let rhs = block-states.join($+$)
    $B_#lk = rhs = #block-prob$
    linebreak()
  }
}

#let kaufman-roberts(C, b, labels, p, pfrac) = {
  let q = (0.0,) * (C + 1)
  q.at(0) = 1.0

  $g (0) = 1$
  linebreak()

  let qs = ()
  qs.push($q (0)$)
  for c in range(1, C + 1) {
    let s = 0.0
    let pieces = ()
    for ((bk, pk), pfk) in b.zip(p).zip(pfrac) {
      if bk <= c {
        s += pk * bk * q.at(c - bk)
        pieces.push($#pfk #if bk != 1 { $dot #bk$ } q (#{ c - bk })$)
      }
    }
    q.at(c) = s / c
    let sum = pieces.join($+$)
    if c == 1 {
      $g (#c) = #sum = #{ s / c }$
    } else {
      $g (#c) = 1/#c (#sum) = #{ s / c }$
    }
    linebreak()

    qs.push($g (#c)$)
  }

  let qsum = qs.join($+$)
  let G = q.sum()
  $G = qsum = #G$
  linebreak()

  for c in range(0, C + 1) {
    let qnorm = q.at(c) / G
    $q (#c) = frac(g (#c), G) = #qnorm$
    linebreak()
  }

  for (bk, lk) in b.zip(labels) {
    let blocking = ()
    let blocking-prob = 0.0
    for c in range(C + 1 - bk, C + 1) {
      blocking.push($q (#c)$)
      blocking-prob += q.at(c) / G
    }
    let bsum = blocking.join($+$)
    $B_#lk = bsum = #blocking-prob$
    linebreak()
  }
}
