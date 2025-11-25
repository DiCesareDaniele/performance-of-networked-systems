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
  abstract: [
    This document is the submission of Daniele Di Cesare and Gabriel Marica for the first assignment of Performance of Networked Systems. This assignment is divided into four main sections. \
    *I. Planning of cellular telephone networks with video-conferencing services* \
    This section involves applying queuing theory and traffic models to cellular networks with multiple service classes. \
    *II. Optimal distribution of channels over neighboring cells in mobile voice networks* \
    This section focuses on optimizing channel allocation across multiple neighboring cells to minimize the overall blocking probability. \
    *III. Traffic Management in IP networks* \
    This section shows the effects of Traffic Shaping and Traffic Policing on an incoming traffic stream. \
    *IV. Performance of TCP-based networks* \
    The final section addresses the performance implications of TCP Slow Start mechanism.
  ],
  lecturer: "Prof.dr. Rob van der Mei",
  date: "November 30, 2025",
  spacing: 1.25cm,
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

