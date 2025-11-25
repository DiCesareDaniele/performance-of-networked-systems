#import "conf.typ": conf

#set document(
  title: [Performance of Networked Systems],
)
#show: conf.with(
  subtitle: "Assignment 1",
  authors: (
    (
      name: "Daniele Di Cesare",
      affiliation: "VU Amsterdam",
      email: "d.dicesare@student.vu.nl",
    ),
    (
      name: "Gabriel Marica",
      affiliation: "VU Amsterdam",
      email: "g.marica@student.vu.nl",
    ),
  ),
  abstract: [This document is the submission of Daniele Di Cesare and Gabriel Marica for the first assignment of Performance of Networked Systems. #lorem(40)],
  lecturer: "Prof.dr. Rob van der Mei",
  date: "November 28, 2025",
  spacing: 1.2cm,
)

#pagebreak()

#outline()

#pagebreak()
#include "exercises/1.typ"
#pagebreak()
#include "exercises/2.typ"
#pagebreak()
#include "exercises/3.typ"
#pagebreak()
#include "exercises/4.typ"

