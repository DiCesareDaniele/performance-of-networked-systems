from sympy import Matrix, symbols, solve, Rational

def main():
    lv, ll, lh = (Rational(30), Rational(96, 125), Rational(24, 125))
    mv, ml, mh = (Rational(12), Rational(10, 3), Rational(10, 3))

    A = Matrix([
        [lv+ll+lh, -mv, 0, 0, 0, -ml, 0, 0, 0, -mh, 0],
        [0, -lv, lv+ll+2*mv, -3*mv, 0, 0, 0, -ml, 0, 0, 0],
        [0, 0, -lv, lv+3*mv, -4*mv, 0, 0, 0, 0, 0, 0],
        [0, 0, 0, -lv, 4*mv, 0, 0, 0, 0, 0, 0],
        [-ll, 0, 0, 0, 0, lv+ll+ml, -mv, 0, -2*ml, 0, 0],
        [0, -ll, 0, 0, 0, -lv, lv+mv+ml, -2*mv, 0, 0, 0],

        [0, 0, -ll, 0, 0, 0, -lv, 2*mv+ml, 0, 0, 0],
        [0, 0, 0, 0, 0, -ll, 0, 0, 2*ml, 0, 0],
        [-lh, 0, 0, 0, 0, 0, 0, 0, 0, lv+mh, -mv],
        [0, -lh, 0, 0, 0, 0, 0, 0, 0, -lv, mv+mh],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    ])

    b = Matrix(
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    )

    x = symbols(f"x1:12")

    solution = solve(A*Matrix(x) - b, x)
    for xi in x:
        s = solution[xi]
        print(f"{xi}: {s} = {float(s)}")

if __name__  == "__main__":
    main()