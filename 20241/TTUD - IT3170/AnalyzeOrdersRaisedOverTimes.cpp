#include <iostream>
#include <unordered_map>
#include <vector>
#include <string>
#include <algorithm>
using namespace std;

int timeToSeconds(const string& time) {
    if (time.size() != 8 || time[2] != ':' || time[5] != ':') return -1;
    int h = (time[0] - '0') * 10 + (time[1] - '0');
    int m = (time[3] - '0') * 10 + (time[4] - '0');
    int s = (time[6] - '0') * 10 + (time[7] - '0');
    if (h < 0 || h > 23 || m < 0 || m > 59 || s < 0 || s > 59) return -1;
    return h * 3600 + m * 60 + s;
}

int main() {
    unordered_map<int, int> freq; 
    int min_time = 86400, max_time = 0; 
    string line;

    while (getline(cin, line) && line != "#") {
        size_t spacePos = line.find(' ');
        if (spacePos == string::npos || spacePos + 1 >= line.size()) continue;
        string timePoint = line.substr(spacePos + 1);
        int timeInSeconds = timeToSeconds(timePoint);
        if (timeInSeconds >= 0) {
            freq[timeInSeconds]++;
            min_time = min(min_time, timeInSeconds);
            max_time = max(max_time, timeInSeconds);
        }
    }

    int range = max_time - min_time + 1;
    vector<int> prefixSum(range, 0);
    for (const auto& [time, count] : freq) {
        prefixSum[time - min_time] = count;
    }
    for (int i = 1; i < range; ++i) {
        prefixSum[i] += prefixSum[i - 1];
    }

    while (getline(cin, line) && line != "###") {
        if (line.find("?number_orders_at_time") == 0) {
            string timePoint = line.substr(22);
            int timeInSeconds = timeToSeconds(timePoint);
            if (timeInSeconds >= min_time && timeInSeconds <= max_time) {
                cout << freq[timeInSeconds] << endl;
            } else {
                cout << 0 << endl;
            }
        } else if (line.find("?number_orders_in_period") == 0) {
            size_t firstSpace = line.find(' ');
            size_t secondSpace = line.find(' ', firstSpace + 1);
            string fromTime = line.substr(firstSpace + 1, secondSpace - firstSpace - 1);
            string toTime = line.substr(secondSpace + 1);

            int fromSec = timeToSeconds(fromTime);
            int toSec = timeToSeconds(toTime);

            if (fromSec > max_time || toSec < min_time) {
                cout << 0 << endl;
            } else {
                fromSec = max(fromSec, min_time);
                toSec = min(toSec, max_time);
                int result = prefixSum[toSec - min_time] - (fromSec > min_time ? prefixSum[fromSec - min_time - 1] : 0);
                cout << result << endl;
            }
        } else if (line == "?number_orders") {
            cout << prefixSum[range - 1] << endl;
        }
    }

    return 0;
}

