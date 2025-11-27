#import "traffic.typ"

= III. Traffic Management in IP networks

Before shaping/policing we have this incoming traffic.

#let x1 = (0.0, 15.0, 25.0)
#let y1 = (5.0, 7.5, 2.5)
#let w1 = (10.0, 5.0, 25)
#traffic.bitrate(
  x1,
  y1,
  w1,
  caption: "Bitrate before shaping/policing",
)

== 13. Traffic Shaping Delay Graph

+ For the first burst we have a peak rate of 5Mb/s distributed over 10 seconds. Since the shaping rate is 4Mb/s the shaping buffer level rises at rate $5"Mb/s" - 4"Mb/s" = 1"Mb/s"$. Which means that at the end of the burst the buffer level is $1"Mb/s" dot 10"s" = 10"Mb"$ and the  delay is $frac(10"Mb", 4"Mb/s") = 2.5"s"$.
+ For the first burst we have a peak rate of 7.5Mb/s distributed over 5 seconds. Since the shaping rate is 4Mb/s the shaping buffer level rises at rate $7.5"Mb/s" - 4"Mb/s" = 3.5"Mb/s"$. Which means that at the end of the burst the buffer level is $3.5"Mb/s" dot 5"s" = 17.5"Mb"$ and the  delay is $frac(17.5"Mb", 4"Mb/s") = 4.375"s"$.
+ For the third and final burst we have a peak rate of 2.5Mb/s, which is less than the 4Mb/s shaping rate. This means that the third burst is not delayed.

#let delays = (
  ((0, 0), (10, 2.5), (12.5, 0)),
  ((15, 0), (20, 4.375), (24.375, 0)),
)
#let no-delays = (
  (25, 50),
)
#traffic.delay(
  delays,
  no-delays: no-delays,
  ticks-pad: (0pt, 0pt, 0pt, 0pt, 0pt, -26pt, 10pt, 0pt),
  caption: "Conforming traffic after policing",
)

== 14. Traffic Shaping Bitrate Graph

+ For the first burst we have a peak rate of 5Mb/s distributed over 10 seconds. Which means that the total ammount of traffic is $5"Mb/s" dot 10"s"=50"Mb"$. Since the shaping rate is 4Mb/s the shaped burst is going to be 4Mb/s distributed over $frac(50"Mb", 4"Mb/s") = 12.5"s"$.
+ For the second burst we have a peak rate of 7.5Mb/s distributed over 5 seconds. Which means that the total ammount of traffic is $7.5"Mb/s" dot 5"s"=37.5"Mb"$. Since the shaping rate is 4Mb/s the shaped burst is going to be 4Mb/s distributed over $frac(37.5"Mb", 4"Mb/s") = 9.375"s"$.
+ For the third and final burst we have a peak rate of 2.5Mb/s, which is less than the 4Mb/s shaping rate. This means that the third burst remains unchanged.

#let x2 = (0, 15, 25)
#let y2 = (4, 4, 2.5)
#let w2 = (12.5, 9.375, 25)
#traffic.bitrate(
  x2,
  y2,
  w2,
  ticks-pad: (0pt, 0pt, 0pt, -26pt, 10pt, 0pt),
  caption: "Bitrate after shaping",
)

== 15. Traffic Policing Bitrate Graph
Trick question the bitrate is the same as before. Policing with marking (not when we drop the packets) does not reduce the bitrate, it only signals which packets exceed the allowed rate.

#traffic.bitrate(
  x1,
  y1,
  w1,
  caption: "Bitrate before/after policing",
)

== 16. Traffic Policing Conforming Graph

Note that the "water volume" takes $frac(8"Mb", 4"Mb/s") = 2s$ to become empty once it has reached the burst tolerance. Since we have a 5 second spacing between each burst we can consider each burst separately.

+ For the first burst we have a peak rate of 5Mb/s distributed over 10 seconds. Since the leak rate is 4Mb/s and the burst tolerance is 8Mb the "water volume" rises at rate $5"Mb/s" - 4"Mb/s" = 1"Mb/s"$, and after $frac(8"Mb", 1"Mb/s") = 8"s"$ the "water volume" reaches the burst tolerance. Which means that in the first 8 seconds (in #text(fill: blue)[blue]) the traffic is marked as conforming and between 8 and 10 seconds (in #text(fill: red)[red]) only $frac(4, 5)$ of the packets are marked as conforming, and the remaining $frac(1, 5)$ non-conforming.
+ For the second burst we have a peak rate of 7.5Mb/s distributed over 5 seconds. Since the leak rate is 4Mb/s and the burst tolerance is 8Mb the "water volume" rises at rate $7.5"Mb/s" - 4"Mb/s" = 3.5"Mb/s"$, and after $frac(8"Mb", 3.5"Mb/s") approx 2.28"s"$ the "water volume" reaches the burst tolerance. Which means that in the first 2.28 seconds (in #text(fill: blue)[blue]) the traffic is marked as conforming and between 2.28 and 5 seconds (in #text(fill: red)[red]) only $frac(4, 7.5)$ of the packets are marked as conforming, and the remaining $frac(3.5, 7.5)$ non-conforming.
+ For the third and final burst we have a peak rate of 2.5Mb/s, which is less than the 4Mb/s leak rate. This means that the third burst is all compleately marked as conforming.

#let splits = (8.0, 2.28, 0.0)
#traffic.policed(
  x1,
  y1,
  w1,
  splits,
  caption: "Conforming traffic after policing",
)
