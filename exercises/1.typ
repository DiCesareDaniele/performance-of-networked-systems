
= I. Planning of cellular telephone networks with video-conferencing services

== 1. Problem Modeling

Assumptions:
+ Cell area is A
+ Number of lines is N
+ Spatial arrival intensity is $lambda prime$
+ Poisson process of "calls" with rate $lambda$
+ Average call duration is $beta$

Parameters:
+ $A = 1.2"Km"^2$
+ $N = 4$
+ $lambda prime = frac(25, "h" dot "Km"^2)$
+ $lambda = lambda prime A = frac(25, "h" dot "Km"^2) 1.2"Km"^2 = 30 frac(1, "h")$
+ $beta = 1/12"h"$

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

An analogy would be a leaky bucket (more on that later :P). If you triple how often you pour water but each time you pour a third the water the average water level will stay the same. So the probability that the bucket is full stays the same.

== 4. Multi-Rate Model Markov Chain
#import "multi-rate.typ": *

#let C = 4
#let b = (1, 2, 3)
#let labels = ("voice", "low", "high")

#let (sv, sl, sh) = labels
#let (cv, cl, ch) = b

#let (lv, ll, lh) = labels.map(l => $lambda_#l$)
#let (bv, bl, bh) = labels.map(l => $beta_#l$)
#let (mv, ml, mh) = labels.map(l => $mu_#l$)
#let (rv, rl, rh) = labels.map(l => $rho_#l$)
#let (nv, nl, nh) = labels.map(l => $n_#l$)

Assumptions:
+ Cell area is A
+ Number of lines is N
+ Probability of a low-resolution video call is $P_"low"$
+ Spatial arrival intensity for voice call is $lv prime$
+ Spatial arrival intensity for video call is $lambda_"video" prime$
+ Poisson processes of "calls" with rate $(lv, ll, lh)$
+ Average call duration is $(bv, bl, bh)$

Parameters:
+ $A = 1.2"Km"^2$
+ $N = 4$
+ $P_"low" = 80%$
+ $lv = 30 frac(1, "h")$ #h(1fr) (same as before)
+ $bv = 1/12"h"$ #h(1fr) (same as before)
+ $lambda_"video" prime = frac(0.8, "h" dot "Km"^2)$
+ $ll = lambda_"video" prime A P_"low" = frac(0.8, "h" dot "Km"^2) dot 1.2"Km"^2 dot 0.8 = 96/125 frac(1, "h")$
+ $lh = lambda_"video" prime A (1 - P_"low") = frac(0.8, "h" dot "Km"^2) dot 1.2"Km"^2 dot 0.2 = 24/125 frac(1, "h")$
+ $bl = bh = 3/10h$

The state space is:\
$ S = {n = (nv,nl,nh) in I^3: #if cv != 1 { cv } nv + #if cl != 1 { b.at(1) } nl + #if ch != 1 { b.at(2) } nh <= 4} $

The evolution of the number of calls $n = (nv,nl,nh)$ can be represented by the following Markov-chain:
#draw-markov-chain(C, b, labels)

== 5. Balance Equations
We know that in equilibrium the rate-in must equal the rate-out. Using the transitions of the Markov-chain we can derive the following balance equations:

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

TODO: derive solutions & write normalization equation

== 6. Product-Form solution
#let p = (30 * 1 / 12, 96 / 125 * 3 / 10, 24 / 125 * 3 / 10)
#let pfrac = ($30 dot 1 / 12$, $96 / 125 dot 3 / 10$, $24 / 125 dot 3 / 10$)

The equilibrium state probabilities can also be computed using the product-form formula:
$
  & pi (nv,nl,nh) = frac(1, G) dot frac(rv^nv, nv!) dot frac(rl^nl, nl!) dot frac(rh^nh, nh!), "for" (nv,nl,nh) in S \
  & G := sum_(n in S) frac(rv^nv, nv!) dot frac(rl^nl, nl!) dot frac(rh^nh, nh!) \
  & "with" rv := lv bv, rl := ll bl, rh := lh bh
$

If we apply the formula to each state we get:\
#product-form(C, b, labels, p)

== 7. Blocking Probability
The blocking probability is just the sum of probabilities of states in which a class is not accepted, or one minus the sum of the probabilities of states in which a class is accepted. We will use the former for the blocking probability of voice calls and the latter for the blocking probability of video calls (this way we have to write less states).

If we look at the Marokov-chain we can notice that:
+ The voice calls are blocked in states ${(4,0,0), (2,1,0), (0,2,0), (1,0,1)}$
+ The low-resolution video calls are accepted in states ${(0,0,0), (1,0,0), (2,0,0), (0,1,0)}$
+ The high-resolution video calls are accepted in states ${(0,0,0), (1,0,0)}$

This gives us the following blocking probabilities:\
#blocking-prob(C, b, labels, p)

== 8. Kaufman-Roberts Solution
Kaufman-Roberts works by defining $q(c)$ as the probability that c channels are occupied.
Then $q(c)$ follows the following recurrence relation:

$ q(c) = 1/c sum_(k=1)^K rho_k b_k q(c - b_k) $

Which in our case is:

$ q(c) = 1/c (rv #if cv != 1 { cv } q(c - 1) + rl #if cl != 1 { cl } q(c - 2) + rh #if ch != 1 { ch } q(c - 3)) $

Instead of computing $q(c)$ directly lets start with a function $g "such that" g(0) = 1$ and then using the recurrence formula to compute $g(c) "for" c = 1,..,#C$. After that we can compute $q(c)$ by normalizing $g(c)$. Then the blocking probability $B_i$ of class i is the sum of $q(c)$ such that $c + b_i > #C$.

#kaufman-roberts(C, b, labels, p, pfrac)

Notice that we get the exact same probabilities as in exercise 7 (minus some floating point errors).

== 9. Kaufman-Roberts Recursion in Python
#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

#let code = read("../scripts/kaufman.py")

#figure(caption: "Kaufman-Roberts Recursion in Python")[
  #codly-range(2, end: 24)
  #raw(code, block: true, lang: "py")
] <kaufman>

If we look at the @kaufman, we see that it is doing the same procedure as in the previous exercise. We create an array q and we start with q[0] = 1. With dynamic programming we populate the whole q array using the recurrence formula and the previously computed values. Then we normalize and we compute the blocking probabilities of each class by summing all the q[c] such that c is not enough capacity to accept a new call for that class.

#figure(caption: "Kaufman-Roberts Recursion main")[
  #codly-range(26, end: 37)
  #raw(code, block: true, lang: "py")
] <kaufman-main>

After running @kaufman-main we get:\
$B_#sv = 0.1996735997252397$\
$B_#sl = 0.45640869851448096$\
$B_#sh = 0.7224714013479422$\
Which are the exact same probabilities as in exercise 7 and 8 (minus some floating point errors).
