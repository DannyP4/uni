#include<iostream>
#include<algorithm>
#include<string>

using namespace std;

int const maxn = 1e5 + 1;

long long n, q, a[maxn], t[4 * maxn];

void build(int v, int l, int r) {
	if (l == r) t[v] = a[l];
	else {
		int m = (l + r) / 2;
		build(2 * v, l, m);
		build(2 * v + 1, m + 1, r);
		t[v] = t[2 * v] + t[2 * v + 1];
	} 
}

void update(int v, int l, int r, int pos, int val) {
	if (l == r) t[v] = val;
	else {
		int m = (l + r) / 2;
		if (pos <= m) update(2 * v, l, m, pos, val);
		else update(2 * v + 1, m + 1, r, pos, val);
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
	cin >> n;
	for (int i = 0; i < n; i++) cin >> a[i];
	build(1, 0, n - 1);
//	update(1, 0, n - 1, 4, 10);
//	for (int i = 1; i <= 15; i++) cout << t[i] << " ";
	cout << query(1, 0, n - 1, 3, 5);
	return 0;
}
