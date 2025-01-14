#include <bits/stdc++.h>

using namespace std;

int c[105][105], n, k, X[100];
int visited[105];
int d = 0, ans = 1e7 + 1, cmin = 1e7 + 1, npob = 0;

void nhap() {
    cin >> n >> k;
    for (int i = 0; i <= 2 * n; i++) {
        for (int  j = 0; j <= 2 * n; j++) {
            cin >> c[i][j];
            if (c[i][j] != 0 && i != j) cmin = min(cmin, c[i][j]);
        }
    }

    for (int i = 0; i <= 2 * n; i++)
        visited[i] = 0;
}

bool check(int i) {
    if (npob > k) return false;
    if (i >= n + 1 && i <= 2 * n && visited[i - n] == 0) return false;

    return true;
}

void Try(int i) {
    for (int j = 1; j <= 2 * n; j++) {
        if (visited[j] == 0) {
            visited[j] = 1;
            X[i] = j;
            d += c[X[i - 1]][X[i]];

            if (j >= 1 && j <= n) npob++;
            if (j >= n + 1 && j <= 2 *n && visited[j - n] == 1) npob--;

            if (i == 2 * n) ans = min(ans, d + c[X[2 * n]][0]);
            else if (check(j) && (d + (2 * n + 1 - i) * cmin < ans)) Try(i + 1);

            visited[j] = 0;
            d -= c[X[i - 1]][X[i]];
            if (j >= 1 && j <= n) npob--;
            if (j >= n + 1 && j <= 2 *n && visited[j - n] == 1) npob++;
        }
    }
}

int main() {
    nhap();
    X[0] = 0; visited[0] = 1;
    Try(1);
    cout << ans << endl;

    return 0;
}
