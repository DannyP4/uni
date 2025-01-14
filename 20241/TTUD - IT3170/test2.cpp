#include<iostream>
#include<algorithm>
#include<string>

using namespace std;

int const maxn = 1e5 + 1;

long long n, q, a[maxn], t[4 * maxn], X, Y, m;

void build(int v, int l, int r) {
	if (l == r) t[v] = a[l];
	else {
		int m = (l + r) / 2;
		build(2 * v, l, m);
		build(2 * v + 1, m + 1, r);
		t[v] = t[2 * v] + t[2 * v + 1];
	}
}

long long query(int v, int tl, int tr, int l, int r) {
	if (l > r) return 0;
	if (tl == l && tr == r) return t[v];
	else {
		int tm = (tl + tr) / 2;
		long long s1 = query(2 * v, tl, tm, l, min(r, tm));
		long long s2 = query(2 * v + 1, tm + 1, tr, max(l, tm + 1), r);
		return s1 + s2;
	}
}

int main() {
	cin >> n >> X >> Y;
	for (int i = 0; i < n; i++) cin >> a[i];
	build(1, 0, n - 1);

	cin >> m;
	int a, b;
	while (m--) {
        cin >> a >> b;
        int temp = query(1, 0, n - 1, a - 1, b - 1);
        if (temp < X || temp > Y) {
            cout << 1 << endl;
            continue;
        } else {
            cout << 0 << endl;
            continue;
        }
	}
	return 0;
}
