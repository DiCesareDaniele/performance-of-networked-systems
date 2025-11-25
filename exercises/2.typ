
= II. Optimal distribution of channels over neighboring cells in mobile voice networks

== 10. Call attempt probabilities
The probability $p_i$ that a call takes place in cell i is:
$ p_i = lambda_i / (sum_(j=1)^5 lambda_j) $
with:\
#let lambdas = (2, 5, 8, 9, 11)
#let lsum = 0.0
#for (i, l) in lambdas.enumerate() {
  lsum += l
  $lambda_#(i + 1) = #l$
  linebreak()
}
which gives us:\
#for (i, l) in lambdas.enumerate() {
  $p_#(i + 1) = #l / #lsum$
  linebreak()
}

== 11. Optimal distribution of channels

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

#let code = read("../scripts/cells.py")

#figure(caption: "Weighted erlang")[
  #codly-range(2, end: 17)
  #raw(code, block: true, lang: "py")
] <werlang>

In @werlang we use three different functions to compute the overall blocking probability. The first one is a special case of the Kaufman-Roberts recursion formula, where there is exactly one class and that class occupies one channel. We will derive that in @proof_erlang. The second function populates a table, where $"table[cell][c]" = B(rho_"cell", "c")$, of all the possible blocking probabilities. This is done to reduce the runtime complexity of the program since the overall blocking probability has to be calculated a lot of times. The third and final function in this code block is the werlang function  short for weighted erlang function. This function calculates the overall blocking probaiblity by using the following formula:
$ sum_(i=1)^5 B((rho_i, n_i) | "call happend in" "cell"_i) = sum_(i=1)^5 p_i B(rho_i, n_i) $
We are yet to derive the formula used in the first function. To do that start by using the Kaufman-Roberts recursion forumla for 1 class and 1 channel.
$
  q(n) & = rho/n q(n - 1) \
   S_n & := sum_(i=0)^n g(i) \
  q(n) & = g(n) / S_n
$

Where $g(c)$ is the un-normalized version of q(0) and g(0) := 1. Then:

$
  B_n = q(n)/S_n & = frac(rho/n g(n - 1), S_(n - 1) + rho/n g(n - 1)) \
                 & = frac(rho/n, S_(n - 1) / g(n - 1) + rho/n) \
                 & = frac(rho/n, 1/B_(n-1) + rho/n) \
                 & = frac(rho B_(n-1), n + rho B_(n-1))
$ <proof_erlang>

So if we start with B = 0.0 we can apply the formula n times to compute $B_n$.

#figure(caption: "Optimal channels distribution")[
  #codly-range(19, end: 20)
  #raw(code, block: true, lang: "py")
  #codly-range(25, end: 39)
  #raw(code, block: true, lang: "py")
] <optimal>

In @optimal we have a function that iters over all the possible distributions of channels and calculates the overall blocking probability. It keeps track of the minimum and returns it. To iterate over all the possible channel distributions we could naively iterate over all possible 5-tuple $n in Z_C^5$ and check if it is a valid channel distribution given our constraints. But that would be inefficent. Instead what we can do is chose the number of channels for the third cell, now we know that to be a valid channel distribution should have $(n_1 + n_2 <= C - n_3) and (n_4 + n_5 <= C - n_3)$, but since we are interested in the minimum it does not make sense to use less channels than what we are given, so we will only consider the case that $(n_1 + n_2 = C - n_3) and (n_4 + n_5 = C - n_3)$. So once we have chosen $n_3$ we can iter over all the possible $n_1 "and" n_4$ and from that constraints calculate $n_2 "and" n_5$. Reducing the runtime complexity from $O(C^5) "to" O(C^3)$.

#figure(caption: "Optimal channels distribution main")[
  #codly-range(41, end: 52)
  #raw(code, block: true, lang: "py")
  #codly-range(59, end: 60)
  #raw(code, block: true, lang: "py")
] <optimal_main>
@optimal_main gives us a overall blocking probaiblity of $0.27431686232726826 approx 27.4%$, distributing this ammount of channels per cell:\
$n_1 = 8$\
$n_2 = 15$\
$n_3 = 9$\
$n_4 = 10$\
$n_5 = 13$\

== 12. Optimal distribution below 1%
For this problem we can reuse the function from the previous exercise and keep increasing the capacity until we get a blocking probability less than 1%.

#figure(caption: "Optimal channels distribution below 1%")[
  #codly-range(41, end: 48)
  #raw(code, block: true, lang: "py")
  #codly-range(53, end: 60)
  #raw(code, block: true, lang: "py")
] <less_1perc>

@less_1perc gives us a overall blocking probaiblity of bearly less than 1%, with a capacity of 66 and distributing this ammount of channels per cell:\
$n_1 = 18$\
$n_2 = 28$\
$n_3 = 20$\
$n_4 = 21$\
$n_5 = 25$\
