#include <bits/stdc++.h>

using namespace std;

int const MAXV = 1e7 + 1;
int n, res = 0, t = 1;
vector<pair<int, int>> v(MAXV);

int main() {
    cin >> n;
    v.resize(n);
    for (int i = 0; i < n; i++) cin >> v[i].first >> v[i].second;

    sort(v.begin(), v.end(), [](const pair<int, int>& a, const pair<int, int>& b) {
        if (a.second == b.second) return a.first < b.first;
        return a.second > b.second;
    });

    vector<bool> checked(n);
    for (const auto& j : v) {
        int d = j.first;
        int p = j.second;

        for (int i = d; i >= 1; i--) {
            if (!checked[i]) {
                checked[i] = true;
                res += p;
                break;
            }
        }
    }

    cout << res;
/*
6
3 10
2 40
6 70
3 50
5 80
1 60
*/

    return 0;
}
