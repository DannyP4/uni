#include<iostream>
#include<string>
#include<algorithm>

using namespace std;

int const maxn = 1e5 + 1;
long long n, m, t[4 * maxn], a[maxn];

void build(int v, int l, int r) {
	if (l == r) t[v] = a[r];
	else {
		int m = (l + r) / 2;
		build(2 * v, l, m);
		build(2 * v + 1, m + 1, r);
		t[v] = max(t[2 * v], t[2 * v + 1]);
	}
}

void update(int v, int l, int r, int pos, int val) {
	if (l == r) t[v] = val;
	else {
		int m = (l + r) / 2;
		if (pos <= m) update(2 * v, l, m, pos, val);
		else update(2 * v + 1, m + 1, r, pos, val);
		t[v] = max(t[2 * v], t[2 * v + 1]);
	}
}

long long query(int v, int tl, int tr, int l, int r) {
	if (l > r) return 0;
	if (tl == l && tr == r) return t[v];
	else {
		int tm = (tl + tr) / 2;
		long long s1 = query(2 * v, tl, tm, l, min(r, tm));
		long long s2 = query(2 * v + 1, tm + 1, tr, max(tm + 1, l), r);
		return max(s1, s2);
	}
}

int main() {
	cin >> n;
	for (int i = 0; i < n; i++) cin >> a[i];
	build(1, 0, n - 1);
	cin >> m;
	cin.ignore();
	while(m--) {
		string input;
		getline(cin, input);
		if (input.substr(0, 7) == "get-max") {
            size_t space1 = input.find(' ', 8); // tim dau ' ' sau ki tu thu 8
            int l = stoi(input.substr(8, space1 - 8)) - 1;
            int r = stoi(input.substr(space1 + 1)) - 1;
            cout << query(1, 0, n - 1, l, r) << endl;
        } else if (input.substr(0, 6) == "update") {
            size_t space1 = input.find(' ', 7);
            int pos = stoi(input.substr(7, space1 - 7)) - 1;
            int val = stoi(input.substr(space1 + 1));
            update(1, 0, n - 1, pos, val);
        }
	}

	return 0;
}
