
#let conf(
  subtitle: "",
  authors: (),
  abstract: [],
  lecturer: "",
  date: "",
  spacing: 0cm,
  doc,
) = {
  show heading.where(level: 1): set align(center)

  let huge-size = 2.0em
  let big-size = 1.5em
  let small-size = 1.2em
  place(
    top + center,
    float: true,
    scope: "parent",
    clearance: 2em,
    {
      // title & subtitle
      title()
      text(
        size: big-size,
        weight: "extralight",
        fill: color.rgb(40, 40, 40),
      )[#subtitle]

      v(spacing)

      // authors
      let count = authors.len()
      let ncols = calc.min(count, 3)
      grid(
        columns: (1fr,) * ncols,
        row-gutter: 24pt,
        ..authors.map(author => text(size: huge-size)[
          #author.name \
          #author.affiliation \
          #link("mailto:" + author.email)
        ]),
      )

      v(spacing)

      // lecturer
      text(size: big-size)[
        Lecturer: \
        #lecturer
      ]

      v(spacing)

      // submission date
      text(size: big-size)[
        #date
      ]

      v(spacing)

      // abstract
      text(size: big-size)[
        *Abstract*
      ]
      align(left)[
        #text(size: small-size)[
          #abstract
        ]
      ]
    },
  )
  doc
}
