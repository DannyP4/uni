#include <iostream>
#include <vector>

using namespace std;

int main() {
	int n; cin >> n;
	vector<int> v(n);
	for (int i = 0; i < n; i++) cin >> v[i];
	
	vector<int> prefix(n + 1);
	int sum = 0;
	prefix[0] = 0;
	for (int i = 1; i < n + 1; i ++) {
		sum+= v[i - 1];
		prefix[i] = sum;
	}
	
	
	int q; cin >> q;
	while(q > 0) {
		int a, b;
		cin >> a >> b;
		int res = prefix[b] - prefix[a - 1];
		cout << res << endl;
		q--;
	}
	
	
	return 0;
} 
