#import "@preview/cetz:0.4.2"
#import "@preview/cetz-plot:0.1.3"

#let rectanges(x, y, w, color: blue) = {
  import cetz.draw: *
  if type(color) == array {
    x.zip(y, w, color).map(((x, y, w, c)) => rect((x, 0), (x + w, y), fill: c))
  } else {
    x.zip(y, w).map(((x, y, w)) => rect((x, 0), (x + w, y), fill: color))
  }
}

#let traffic-plot(
  width: 52.5,
  height: 10.0,
  caption: none,
  x-ticks: none,
  y-ticks: none,
  x-label: none,
  y-label: none,
  plot-body: none,
  body,
) = {
  import cetz-plot: *
  if plot-body == none {
    plot-body = {
      plot.add(((0, 0),))
    }
  }
  figure(caption: caption)[
    #layout(ly => {
      cetz.canvas(
        length: ly.width / width,
        {
          plot.plot(
            size: (width, height),
            x-min: 0.0,
            y-min: 0.0,
            x-max: width,
            y-max: height,
            x-ticks: x-ticks,
            y-ticks: y-ticks,
            x-tick-step: none,
            y-tick-step: none,
            x-label: x-label,
            y-label: y-label,
            x-grid: true,
            y-grid: true,
            plot-body,
          )
          body
        },
      )
    })
  ]
}

#let bitrate(x, y, w, ticks-pad: none, caption: none) = {
  let x-ticks = x
    .zip(w)
    .fold((), (acc, (x, w)) => {
      acc.push(x)
      acc.push(x + w)
      acc
    })
  if ticks-pad == none {
    ticks-pad = (0pt,) * x-ticks.len()
  }
  let x-ticks = x-ticks.zip(ticks-pad).map(((x, p)) => (x, h(p) + [#x]))
  traffic-plot(
    caption: caption,
    x-ticks: x-ticks,
    y-ticks: y,
    x-label: "time (s)",
    y-label: "bitrate (Mb/s)",
    {
      for r in rectanges(x, y, w) {
        r
      }
    },
  )
}

#let delay(delays, no-delays: (), ticks-pad: none, caption: none) = {
  let x-ticks = delays.fold((), (acc, ((x1, _), (x2, _), (x3, _))) => {
    acc.push(x1)
    acc.push(x2)
    acc.push(x3)
    acc
  })
  let x-ticks = no-delays.fold(x-ticks, (acc, (x1, x2)) => {
    acc.push(x1)
    acc.push(x2)
    acc
  })
  let x-ticks = x-ticks.sorted()
  if ticks-pad == none {
    ticks-pad = (0pt,) * x-ticks.len()
  }
  let x-ticks = x-ticks.zip(ticks-pad).map(((x, p)) => (x, h(p) + [#x]))
  let y-ticks = delays.map(((_, (_, y), _)) => y)
  let style = (style: (stroke: red))
  traffic-plot(
    height: 7.0,
    caption: caption,
    x-ticks: x-ticks,
    y-ticks: y-ticks,
    x-label: "time (s)",
    y-label: "delay (s)",
    plot-body: {
      import cetz.draw: *
      import cetz-plot: *
      for (p1, p2, p3) in delays {
        plot.add((p1, p2), ..style)
        plot.add((p2, p3), ..style)
      }
      for (x1, x2) in no-delays {
        plot.add(((x1, 0), (x2, 0)), ..style)
      }
      plot.annotate({
        content((37.5, 1), [No delay here])
      })
    },
    {},
  )
}

#let policed(x, y, w, splits, caption: none) = {
  let x-ticks = x
    .zip(w, splits)
    .fold((), (acc, (x, w, s)) => {
      acc.push(x)
      if s != 0.0 {
        acc.push(x + s)
      }
      acc.push(x + w)
      acc
    })
  let xs = x
    .zip(splits)
    .fold((), (acc, (x, s)) => {
      acc.push(x)
      if s != 0.0 {
        acc.push(x + s)
      }
      acc
    })
  let ys = y
    .zip(splits)
    .fold((), (acc, (y, s)) => {
      acc.push(y)
      if s != 0.0 {
        acc.push(y)
      }
      acc
    })
  let ws = w
    .zip(splits)
    .fold((), (acc, (w, s)) => {
      if s != 0.0 {
        acc.push(s)
        acc.push(w - s)
      } else {
        acc.push(w)
      }
      acc
    })
  let colors = splits.fold((), (acc, s) => {
    acc.push(blue)
    if s != 0.0 {
      acc.push(red)
    }
    acc
  })
  traffic-plot(
    caption: caption,
    x-ticks: x-ticks,
    y-ticks: y,
    x-label: "time (s)",
    y-label: "bitrate (Mb/s)",
    {
      for r in rectanges(xs, ys, ws, color: colors) {
        r
      }
    },
  )
}
