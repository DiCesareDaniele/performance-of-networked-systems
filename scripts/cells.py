
def erlang(p: list[float], N: int) -> float:
    B = 1.0
    for n in range(1, N + 1):
        B = (p * B) / (n + p * B)
    return B

def erlang_table(C: int, p: list[float]) -> list[list[float]]:
    table = []
    for pi in p:
        row = [erlang(pi, N) for N in range(C + 1)]
        table.append(row)
    return table

def werlang(weights: list[float], n: list[int], table: list[list[float]]) \
    -> float:
    return sum(weights[i] * table[i][ni] for (i, ni) in enumerate(n))

def optimal(C: int, p: list[float], weights: list[float]) \
    -> tuple[float, list[int]]:
    '''
    adjacency matrix:
    1 -> (2, 3), 2 -> (1, 3), 3 -> (1, 2, 4, 5), 4 -> (3, 5), 5 -> (3, 4)
    '''
    table = erlang_table(C, p)

    min_n = []
    min_b = float("inf")
    for n3 in range(C + 1):
        for n1 in range(C + 1 - n3):
            n2 = C - n3 - n1
            for n4 in range(C + 1 - n3):
                n5 = C - n3 - n4
                n = [n1, n2, n3, n4, n5]
                b = werlang(weights, n, table)
                if b < min_b:
                    min_n = n
                    min_b  = b
    return (min_b, min_n)

def main():
    C = 32
    lambdas = [2, 5, 8, 9, 11]
    beta = [1.5, 1.5, 1.5, 1.5, 1.5]
    p = [l * b for (l, b) in zip(lambdas, beta)]
    lsum = sum(lambdas)
    weights = [l / lsum for l in lambdas]

    B, n = optimal(C, p, weights)
    # C = 32, B = 0.27431686232726826, n = [8, 15, 9, 10, 13]
    print(f"C = {C}, B = {B}, n = {n}")

    while B >= 0.01:
        C += 1
        B, n = optimal(C, p, weights)
    # C = 66, B = 0.009938133851637975, n = [18, 28, 20, 21, 25]
    print(f"C = {C}, B = {B}, n = {n}")

if __name__ == "__main__":
    main()
