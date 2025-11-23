
= I. Planning of cellular telephone networks with video-conferencing services

== 1. Problem Modeling

Assumptions:
+ Poisson process of "calls" with rate $lambda$
+ Average call duration is $beta$
+ Number of lines is N
+ Spatial arrival intensity is $lambda prime$
+ Cell area is A

Parameters:
+ $A = 1.2"Km"^2$
+ $lambda = lambda prime A = frac(25, "h" dot "Km"^2) dot 1.2"Km"^2 = 30 frac(1, "h")$
+ $beta = 1/12"h"$
+ $N = 4$

We want to find the blocking probability.

== 2. Blocking Probability
Using Erlang Blocking Formula we know that the probability of having k blocked channels is:

$ pi_k = frac((lambda beta)^k slash k!, sum_(i=0)^N (lambda beta)^i slash i!) $

Since N = 4 and $lambda beta = 2.5$ we get that the blocking probability of a call is:

$
  pi_N & = frac((lambda beta)^N slash N!, sum_(i=0)^N (lambda beta)^i slash i!) \
       & = frac(2.5^4 slash 24, 1 + 2.5 + 2.5^2/2 + 2.5^3/6 + 2.5^4/24) \
       & approx 0.15
$

So a call will be blocked 15% of the time.

== 3. Parameter Modifications
If the call arrival rate triples, while the average call duration becomes three
times as small the blocking probability stays the same.

We can immagine each call occuping a slot of random size $beta$, with this change the slot is divided into three equal parts $beta/3$, and each part is used by a different caller since the rate tripled.

An analogy would be a leaky bucket (more on that later :P). If you triple how often you pour water but each time you pour a third the water the average water level will stays the same. So the probability that the bucket is full stays the same.

== 4. Multi-Rate Model Markov Chain
#import "markov-chain.typ": *

#let C = 4
#let b = (1, 2, 3)
#let labels = ("voice", "low", "high")

#let (sv, sl, sh) = labels

#let lv = $lambda_#sv$
#let ll = $lambda_#sl$
#let lh = $lambda_#sh$

#let bv = $beta_#sv$
#let bl = $beta_#sl$
#let bh = $beta_#sh$

#let mv = $mu_#sv$
#let ml = $mu_#sl$
#let mh = $mu_#sh$

TODO: write assumptions

Parameters:
+ $A = 1.2"Km"^2$
+ $P_"low" = 80%$
+ $lv = lv prime A = frac(25, "h" dot "Km"^2) dot 1.2"Km"^2 = 30 frac(1, "h")$ #h(1fr) (same as before)
+ $bv = 1/12"h"$ #h(1fr) (same as before)
+ $ll = lambda_"video" prime A P_"low" = frac(0.8, "h" dot "Km"^2) dot 1.2"Km"^2 dot 0.8 = 96/125 frac(1, "h")$
+ $lh = lambda_"video" prime A (1 - P_"low") = frac(0.8, "h" dot "Km"^2) dot 1.2"Km"^2 dot 0.2 = 24/125 frac(1, "h")$
+ $bl = bh = 3/10h$
+ $N = 4$

#draw-markov-chain(C, b, labels)

== 5.
#balance-equations(C, b, labels)
#linebreak()

// Derive $pi (4,0,0)$ from @mk_5:\
// $pi (4,0,0) = frac(lv, 4 mv) pi (3,0,0)$
//
// Derive $pi (3,0,0)$ from @mk_4 substituting ...:\
// $pi (3,0,0) = frac(lv, 3 mv) pi (2,0,0)$
//
// Derive $pi (2,0,0)$ from ...:\
// $(lv + ll + 2 mv) pi (2,0,0) = lv pi (2,0,0) + ml pi (2,1,0) + lv pi (1,0,0)\
// (ll + 2 mv) pi (2,0,0) = ml pi (2,1,0) + lv pi (1,0,0)$
//
// Derive $pi (0,2,0)$ from ...:\
// $pi (0,2,0) = frac(ll, 2 ml) pi (0,1,0)$
//
// Derive $pi (0,1,0)$ from ...:\
// $(lv + ll + ml) pi (0,1,0) = mv pi (1,1,0) + ll pi (0,1,0) + ll pi (0,0,0)\
// (lv + ml) pi (0,1,0) = mv pi (1,1,0) + ll pi (0,0,0)$
//
// Derive $pi (1,1,0)$ from ...:\
// $(lv + mv + ml) pi (1,1,0) = 2 mv pi (2,1,0) + lv$
//
// Derive $pi (1,0,0)$ from ...:\
//
//
// Derive $pi (1,0,1)$ from ...:\
// $(lv + mh) pi (0,0,1)$

TODO: derive solutions

== 6.
#let nv = $n_#sv$
#let nl = $n_#sl$
#let nh = $n_#sh$

#let rv = $rho_#sv$
#let rl = $rho_#sl$
#let rh = $rho_#sh$

#let p = (30 * 1 / 12, 96 / 125 * 3 / 10, 24 / 125 * 3 / 10)
#let pfrac = ($30 dot 1 / 12$, $96 / 125 dot 3 / 10$, $24 / 125 dot 3 / 10$)

$
  & pi (nv,nl,nh) = frac(1, G) dot frac(rv^nv, nv!) dot frac(rl^nl, nl!) dot frac(rh^nh, nh!), "for" (nv,nl,nh) in S \
  & G := sum_(n in S) frac(rv^nv, nv!) dot frac(rl^nl, nl!) dot frac(rh^nh, nh!) \
  & "with" rv := lv bv, rl := ll bl, rh := lh bh
$

This gives us:\
#product-form(C, b, labels, p)

== 7.
TODO: explain blocking prob
TODO: 1 - probability of being accepted
#blocking-prob(C, b, labels, p)

== 8.
TODO: explain kaufman roberts steps
#kaufman-roberts(C, b, labels, p, pfrac)

== 9. Kaufman-Roberts Recursion in Python
TODO: explain what the program is doing

#let code = read("../scripts/kaufman.py")
#box(
  inset: 1em,
  radius: 6pt,
  fill: rgb("#f5f5f7"),
  stroke: rgb("#d0d0d5"),
  width: 100%,
)[
  #raw(code, lang: "py")
]
