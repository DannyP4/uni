#include <iostream>
#include <vector>
#include <string>
#include <cmath>
#include <algorithm> 
using namespace std;

int stringToInt(string s) {
    int len = s.length();
    int res = 0;
    for (int i = 0; i < len; i++) 
        res = res * 10 + (s[i] - '0');
    return res;
}

int binarySearch(vector<int> v, int val) {
	int l = 0, r = v.size() - 1;
	
	int res = -1;
	while (l <= r) {
		int m = (l + r) / 2;
		
		if (v[m] > val) {
            res = v[m];  
            r = m - 1;   
        } else 
            l = m + 1; 
	}
	
	return res;
}

int main() {
    int n;
    cin >> n; 

    vector<int> v(n);
	for(int i = 0; i < n; i++)
		cin >> v[i]; 
		
	cin.ignore();    
    
    sort(v.begin(), v.end());
    
	string s = ""; 
	
	while(1) {
		getline(cin, s);
	    if (s == "#") break;
		
		if (s.length() >= 5) {
			string k = s.substr(5);
			int val = stringToInt(k);
			
			int res = binarySearch(v, val);
			
			cout << res << endl;
		}
	}
    
//5
//4 8 2 3 7 => 2 3 4 7 8
    
    return 0;
}

