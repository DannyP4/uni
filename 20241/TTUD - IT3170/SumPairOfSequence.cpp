#include <iostream>
#include <vector>
#include <unordered_map>

using namespace std;

int n, m, q = 0;
int maxn = 1e5 + 1;
vector<int> v(maxn);
unordered_map<int, int> ma;

int main() {
    cin >> n >> m;
    for (int i = 0; i < n; i++) cin >> v[i];

    for (int i = 0; i < n; i++) {
        int tmp = m - v[i];
        if (ma.find(tmp) != ma.end()) q++;

        ma[v[i]] = i;
    }

    cout << q;
}
