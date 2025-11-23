
def erlangb(p: list[float], N: int) -> float:
    B = 1.0
    for k in range(1, N + 1):
        B = (p * B) / (k + p * B)
    return B

def erlangb_table(C: int, p: list[float]) -> list[list[float]]:
    table = []
    for pi in p:
        row = [erlangb(pi, N) for N in range(C + 1)]
        table.append(row)
    return table

def weighted_erlangb(weights: list[float], n: list[int], table: list[list[float]]) -> float:
    return sum(weights[i] * table[i][ni] for (i, ni) in enumerate(n))

def optimal(C: int, p: list[float], weights: list[float]) -> tuple[float, list[int]]:
    '''
    adjacency matrix: 1 -> (2, 3), 2 -> (1, 3), 3 -> (1, 2, 4, 5), 4 -> (3, 5), 5 -> (3, 4)
    '''
    table = erlangb_table(C, p)

    min_n = []
    min_b = float("inf")
    for n3 in range(C + 1):
        for n1 in range(C + 1 - n3):
            n2 = C - n3 - n1
            for n4 in range(C + 1 - n3):
                n5 = C - n3 - n4
                n = [n1, n2, n3, n4, n5]
                b = weighted_erlangb(weights, n, table)
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
    # C = 32, B = 0.27431686232726826, n1 = 8, n2 = 15, n3 = 9, n4 = 10, n5 = 13
    print(f"C = {C}, B = {B}, n1 = {n[0]}, n2 = {n[1]}, n3 = {n[2]}, n4 = {n[3]}, n5 = {n[4]}")

    while B >= 0.1:
        C += 1
        B, n = optimal(C, p, weights)
    # C = 48, B = 0.09147871525381661, n1 = 13, n2 = 21, n3 = 14, n4 = 15, n5 = 19
    print(f"C = {C}, B = {B}, n1 = {n[0]}, n2 = {n[1]}, n3 = {n[2]}, n4 = {n[3]}, n5 = {n[4]}")

if __name__ == "__main__":
    main()
