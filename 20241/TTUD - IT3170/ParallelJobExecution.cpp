#include <bits/stdc++.h>

using namespace std;

int n, amax = -1;

int main() {
    cin >> n;
    vector<int> a(n), b(n), c(n);
    for (int i = 0; i < n; i++) cin >> a[i];
    for (int i = 0; i < n; i++) b[i] = i;

    sort(a.begin(), a.end(), greater<int>());
    for (int i = 0; i < n; i++) {
        a[i] += b[i];
        amax = max(amax, a[i]);
    }

    cout << amax;

    return 0;
}
