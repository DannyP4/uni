#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

int const maxn = 1e7 + 10;
int n, sum = 0, q = 0;
vector<int> v(maxn), prefixSum(maxn), prefixSumEven, prefixSumOdd;

int main() {
    cin >> n;
    v.resize(n);
    prefixSum.resize(n + 1);

    for (int i = 0; i < n; i++) cin >> v[i];

    prefixSum[0] = 0;
    prefixSumEven.push_back(0);
    for (int i = 1; i < n + 1; i++) {
        sum += v[i - 1];
        prefixSum[i] = sum;
        if (prefixSum[i] % 2 == 0) prefixSumEven.push_back(prefixSum[i]);
        else prefixSumOdd.push_back(prefixSum[i]);
    }

    for (int i = 0; i < prefixSumEven.size(); i++) q += i;
    for (int i = 0; i < prefixSumOdd.size(); i++) q += i;

    cout << q << endl;

    return 0;
}
