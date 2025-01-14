#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

int const maxn = 1e7 + 1;
long long n, m, t[maxn * 4], a[maxn], q = 0;

void build (int v, int l, int r)  {
    if (l == r) t[v] = a[l];
    else {
        int m = (l + r) / 2;
        build(2 *v, l, m);
        build(2 * v + 1, m + 1, r);
        t[v] = min(t[2 * v], t[2 * v + 1]);
    }
}

long long query(int v, int tl, int tr, int l, int r) {
    if (l > r) return maxn;
    else if (tl == l && tr == r) return t[v];
    else {
        int tm = (tl + tr) / 2;
        long long s1 = query(2 * v, tl, tm, l, min(r, tm));
        long long s2 = query(2* v + 1, tm + 1, tr, max(l, tm + 1), r);
        long long s = min(s1, s2);
        return s;
    }
}

int main() {
    cin >> n;
    for (int i = 0; i < n; i++) cin >> a[i];

    build(1, 0, n - 1);

    cin >> m;
    while(m--) {
        long long i, j;
        cin >> i >> j;
        q += query(1, 0, n - 1, i, j);
    }

    cout << q;

    return 0;
}
