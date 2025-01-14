#include <bits/stdc++.h>
using namespace std;
int n, k;
int c[50][50];
int cmin = 1e6;
int visited[50];
int track[50];
int visited_cnt = 0;
int f = 0;
int npob = 0;
int f_s = 1e8;
bool check(int i)
{
    if (f + (2*n + 1 - visited_cnt)*cmin > f_s) return false;
    if (npob > k) return false;
    if (i >= n + 1 && i <= 2*n && visited[i - n] == 0) return false;
    return true;
}
void Try(int num, int last)
{
    if (num > 2*n){
        if (f + c[last][0] < f_s) f_s = f + c[last][0];
        return;
    }
    for (int i = 1; i <= 2*n; i++){
        if (visited[i] == 0){
            visited[i] = 1;
            visited_cnt += 1;
            track[visited_cnt] = i;
            f += c[last][i];
            if (i >= 1 && i <= n) npob++;
            if (i >= n + 1 && i <= 2*n && visited[i - n] == 1) npob--;
            if (check(i)) {
                Try(num + 1, i);
            }
            if (i >= n + 1 && i <= 2*n && visited[i - n] == 1) npob++;
            if (i >= 1 && i <= n) npob--;
            f -= c[last][i];
            visited_cnt -= 1;
            visited[i] = 0;
        }
    }
}

int main()
{
    cin >> n >> k;
    for (int i= 0;i <= 2*n; i++){
        for (int j = 0; j <= 2*n; j++){
            cin >> c[i][j];
            if  (i != j && c[i][j] < cmin) cmin = c[i][j];
        }
    }
    for (int i= 0; i <= 2*n; i++) {
        visited[i] = 0;
    }
    Try(1, 0);
    cout << f_s;
}
