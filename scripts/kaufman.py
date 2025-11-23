
def kaufman(C: int, p: list[float], b: list[int]) -> list[float]:
    K = len(p)
    q = [0.0] * (C + 1)
    q[0] = 1.0

    for c in range(1, C + 1):
        s = 0.0
        for k in range(K):
            if b[k] <= c:
                s += p[k] * b[k] * q[c - b[k]]
        q[c] = s / c

    G = sum(q)
    q = [qi / G for qi in q]

    B = [0.0] * K
    for k in range(K):
        s = 0.0
        for c in range(C + 1 - b[k], C + 1):
            s += q[c]
        B[k] = s

    return B

def main():
    C = 4
    p = [30 * 1/12, 96/125 * 3/10, 24/125 * 3/10]
    b = [1, 2, 3]
    B = kaufman(C, p, b)
    # Bv = 0.1996735997252397, Bl = 0.45640869851448096, Bh = 0.7224714013479422
    print(f"Bv = {B[0]}, Bl = {B[1]}, Bh = {B[2]}")

if __name__ == "__main__":
    main()
