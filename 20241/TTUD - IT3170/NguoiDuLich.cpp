#include <bits/stdc++.h>

using namespace std;

int c[105][105], n, X[100];
int visited[105];
int d = 0, ans = 1e7 + 1, cmin = 1e7 + 1;

void nhap() {
    cin >> n;
    for (int i = 1; i <= n; i++) {
        for (int  j = 1; j <= n; j++) {
            cin >> c[i][j];
            if (c[i][j] != 0) cmin = min(cmin, c[i][j]);
        }
    }

    for (int i = 0; i <= n; i++)
        visited[i] = 0;
}

void Try(int i) {
    for (int j = 1; j <= n; j++) {
        if (visited[j] == 0) {
            visited[j] = 1;
            X[i] = j;
            d += c[X[i - 1]][X[i]];

            if (i == n) {
                ans = min(d + c[X[n]][1], ans);
            } else if (d + (n - i + 1) * cmin < ans) {
                Try(i + 1);
            }

            visited[j] = 0;
            d -= c[X[i - 1]][X[i]];
        }
    }
}

/*
4
0 85 26 81
85 0 77 97
26 77 0 26
81 97 26 0
*/

int main() {
    nhap();
    X[1] = 1; visited[1] = 1;
    Try(2);
    cout << ans << endl;

    return 0;
}
