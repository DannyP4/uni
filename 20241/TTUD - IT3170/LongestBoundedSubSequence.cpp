#include <iostream>
#include <string>
#include <algorithm>

using namespace std;

using ll = long long;

int const maxn = 1e7 + 1;

int n, q, a[maxn], r = 0, l = 0, crtSum = 0;

int main() {
    cin >> n >> q;
    for (int i = 0; i < n; i++) cin >> a[i];

    crtSum = a[l];
    int tmpL = l, tmpR = r, tmp = 0;
    while(r < n) {
        r += 1;
        crtSum += a[r];

        if (crtSum > q) {
            crtSum -= a[r];
            r -= 1;
            tmp = max(tmp, r - l);
            l += 1;
            crtSum -= a[l - 1];
        }
    }

    if (tmp == 0) cout << -1;
    else cout << tmp + 1;

    return 0;
}
