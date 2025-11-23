#import "@preview/lilaq:0.5.0" as lq

#let extend(acc, x) = {
  (..acc, ..x)
}

#let bitrate(
  x,
  y,
  width,
  label-pad: 0pt,
) = {
  let x-ticks = x
    .zip(width)
    .map(o => {
      let x1 = o.at(0)
      let x2 = x1 + o.at(1)
      (
        (x1, h(label-pad) + [#x1]),
        (x2, h(-label-pad) + [#x2]),
      )
    })
    .fold((), extend)
  lq.diagram(
    width: 100%,
    lq.bar(
      x,
      y,
      offset: width.map(w => w / 2),
      width: width,
    ),
    xlim: (0, 50),
    xaxis: (
      ticks: x-ticks,
      subticks: none,
      label: "time (s)",
    ),
    ylim: (0, 8),
    yaxis: (
      ticks: y,
      subticks: none,
      label: "bitrate (Mb/s)",
    ),
  )
}

#let delay(
  triangles,
  label-pad: 0pt,
  extra: (),
) = {
  let x-ticks = triangles
    .map(t => {
      let x1 = t.at(0).at(0)
      let x2 = t.at(1).at(0)
      let x3 = t.at(2).at(0)
      (
        (x1, h(label-pad) + [#x1]),
        (x2, [#x2]),
        (x3, h(-label-pad) + [#x3]),
      )
    })
    .fold((), extend)
  let y-ticks = triangles.map(t => t.at(1).at(1))
  let lines = triangles
    .map(t => (
      lq.line(
        t.at(0),
        t.at(1),
        stroke: red,
      ),
      lq.line(
        t.at(1),
        t.at(2),
        stroke: red,
      ),
    ))
    .flatten()
  lq.diagram(
    width: 100%,
    ..lines,
    ..extra,
    xlim: (0, 50),
    xaxis: (
      ticks: x-ticks,
      subticks: none,
      label: "time (s)",
    ),
    ylim: (0, 5),
    yaxis: (
      ticks: y-ticks,
      subticks: none,
      label: "delay (s)",
    ),
  )
}

#let policed(
  x,
  y,
  width,
  splits,
  label-pad: 0pt,
) = {
  let x-ticks = x
    .zip(width)
    .zip(splits)
    .map(o => {
      let x1 = o.at(0).at(0)
      let x2 = x1 + o.at(1)
      let x3 = x1 + o.at(0).at(1)
      if o.at(1) == 0.0 {
        (
          (x1, h(label-pad) + [#x1]),
          (x3, h(-label-pad) + [#x3]),
        )
      } else {
        (
          (x1, h(label-pad) + [#x1]),
          (x2, [#x2]),
          (x3, h(-label-pad) + [#x3]),
        )
      }
    })
    .fold((), extend)
  let xs = x
    .zip(splits)
    .map(o => {
      if o.at(1) == 0.0 {
        (o.at(0),)
      } else {
        (o.at(0), o.at(0) + o.at(1))
      }
    })
    .fold((), extend)
  let ys = y
    .zip(splits)
    .map(o => {
      if o.at(1) == 0.0 {
        (o.at(0),)
      } else {
        (o.at(0), o.at(0))
      }
    })
    .fold((), extend)
  let ws = width
    .zip(splits)
    .map(o => {
      if o.at(1) == 0.0 {
        (o.at(0),)
      } else {
        (o.at(1), o.at(0) - o.at(1))
      }
    })
    .fold((), extend)
  let fill = splits
    .map(s => {
      if s == 0.0 {
        (blue,)
      } else {
        (blue, red)
      }
    })
    .fold((), extend)
  lq.diagram(
    width: 100%,
    lq.bar(
      xs,
      ys,
      fill: fill,
      offset: ws.map(w => w / 2),
      width: ws,
    ),
    xlim: (0, 50),
    xaxis: (
      ticks: x-ticks,
      subticks: none,
      label: "time (s)",
    ),
    ylim: (0, 8),
    yaxis: (
      ticks: y,
      subticks: none,
      label: "bitrate (Mb/s)",
    ),
  )
}
