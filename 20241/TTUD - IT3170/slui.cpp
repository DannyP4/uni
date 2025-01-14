#include<iostream>
#include<set>
#include<vector>
#include<algorithm>

using namespace std;

int const maxn = 1e7 + 10;
int n;
vector<int> v;
set<int> ss;

int main() {
    cin >> n;
    v.resize(n);

    for (int i = 0; i < n; i++) {cin >> v[i]; ss.insert(v[i]);}

    for(auto i : ss) cout << i << " ";

    string s ="";
    int val;
    while (s != "#") {
        cin >> s >> val;
        if (s == "min_greater_equal") {
            auto it = lower_bound(ss.begin(), ss.end(), val);
            if (it == ss.end()) cout << "NULL";
            else cout << *it << endl;
        } else if (s == "min_greater") {
            auto it = upper_bound(ss.begin(), ss.end(), val);
            if (it == ss.end()) cout << "NULL";
            else cout << *it << endl;
        } else if (s == "insert") {
            ss.insert(val);
        } else if (s == "remove") {
            for(auto i : ss) {
                if (i == val) i = -1;
            }
        }
    }

    return 0;
}
