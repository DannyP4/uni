#include <iostream>
#include <vector>
#include <algorithm>
#include <map>

using namespace std;

int const maxn = 1e7 + 10, MOD = 1e9 + 7;
int n;
long long q = 0;
vector<int> v(maxn);

void mergePart(vector<int>& v, int l, int m, int r) {
    int i = l, j = m + 1, k = 0;
    vector<int> temp(r - l + 1);

    while (i <= m && j <= r) {
        if (v[i] <= v[j]) {
            temp[k++] = v[i++];
        } else {
            q = (q +(m - i + 1)) % MOD;
            temp[k++] = v[j++];
        }
    }

    while (i <= m) temp[k++] = v[i++];
    while (j <= r) temp[k++] = v[j++];

    for (int i = 0; i < temp.size(); i++) v[i + l] = temp[i];
}

void merge(vector<int>& v, int l, int r) {
    int m = l + (r - l) / 2;
    if (l >= r) return;

    merge(v, l, m);
    merge(v, m + 1, r);
    mergePart(v, l, m, r);
}

int main() {
    cin >> n;
    v.resize(n);

    for (int i = 0; i < n; i++) cin >> v[i];

    merge(v, 0, n - 1);

    cout << q;

    return 0;
}
