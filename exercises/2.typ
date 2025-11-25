
= II. Optimal distribution of channels over neighboring cells in mobile voice networks

== 10. Call attempt probabilities
The probability $p_i$ that a call takes place in cell i is:
$ p_i = lambda_i / (sum_(j=1)^5 lambda_j) $
with:\
#let lambdas = (2, 5, 8, 9, 11)
#let lsum = 0.0
#for (i, l) in lambdas.enumerate() {
  lsum += l
  $lambda_#i = #l$
  linebreak()
}
which gives us:\
#for (i, l) in lambdas.enumerate() {
  $p_#i = #l / #lsum$
  linebreak()
}

== 11. Optimal distribution of channels

TODO: explain

#import "@preview/codly:1.3.0": *
#import "@preview/codly-languages:0.1.1": *

#show: codly-init.with()
#codly(languages: codly-languages)

#let code = read("../scripts/cells.py")

#figure(caption: "Weighted erlang")[
  #codly-range(2, end: 17)
  #raw(code, block: true, lang: "py")
]

#figure(caption: "Optimal channels distribution")[
  #codly-range(19, end: 20)
  #raw(code, block: true, lang: "py")
  #codly-range(25, end: 39)
  #raw(code, block: true, lang: "py")
]

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
