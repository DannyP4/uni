#include<iostream>
#include<vector>

using namespace std;

int main() {
	int n, m;
	cin >> n >> m;
	int a[n][m];
	for (int i = 0; i < n; i++) {
		for(int j = 0; j < m; j++)
			cin >> a[i][j];
	}
	
	int b[n + 1][m + 1];
	for (int i = 0; i <= n; i++) {
		for(int j = 0; j <= m; j++)
			b[i][j] = 0;
	}
	
	for (int i = 1; i <= n; i++) {
		for(int j = 1; j <= m; j++) 
			b[i][j] = b[i - 1][j] + b[i][j - 1] - b[i - 1][j - 1] + a[i - 1][j - 1];
	}
	
	int q; cin >> q;
	while(q > 0) {
		int r1, c1, r2, c2;
		cin >> r1 >> c1 >> r2 >> c2;
		int res = b[r2][c2] - b[r1 - 1][c2] - b[r2][c1 - 1] + b[r1 - 1][c1 - 1];
		cout << res << endl;
		q--;
	}
	
	return 0;
}
