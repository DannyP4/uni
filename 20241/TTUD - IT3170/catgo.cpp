#include<iostream>
#include<vector>
#include<algorithm>

using namespace std;

int n;
vector<int> v, dp;

int main () {
    cin >> n;
    v.resize(n + 1);
    dp.resize(n + 1, 0);
    for (int i = 1; i <= n; i++) cin >> v[i];

    for(int i = 1; i <= n; i++) {
        dp[i] = v[i];
        for (int j = 1; j <= i; j++) {
            dp[i] = max(v[j] + dp[i - j], dp[i]);
        }
    }

    cout << dp[n];

    return 0;
}

/*
8
3 5 8 9 10 17 17 20
*/
