#include <iostream>
#include <vector>
#include <set>
using namespace std;

// Các biến toàn cục
int n1, n2, L, M, P;
vector<pair<int, int>> conflicts; // Danh sách các cặp không thể chọn cùng nhau
int result = 0; // Đếm số chiến lược hợp lệ

// Hàm kiểm tra xem tổ hợp hiện tại có hợp lệ không
bool isValid(const vector<int>& chosen) {
    // Phân nhóm cổ phiếu
    int techCount = 0, retailCount = 0;
    set<int> chosenSet(chosen.begin(), chosen.end()); // Để kiểm tra nhanh xung đột

    for (int stock : chosen) {
        if (stock <= n1) techCount++;       // Nhóm công nghệ
        else retailCount++;                // Nhóm bán lẻ
    }

    // Kiểm tra điều kiện số lượng cổ phiếu mỗi nhóm
    if (techCount == 0 || retailCount == 0) return false; // Mỗi nhóm ít nhất 1 mã
    if (techCount > M || retailCount > M) return false;   // Không vượt quá M mã mỗi nhóm

    // Kiểm tra các cặp không thể chọn cùng nhau
    for (const auto& conflict : conflicts) {
        if (chosenSet.count(conflict.first) && chosenSet.count(conflict.second)) {
            return false; // Nếu chọn cả hai mã trong cặp cấm
        }
    }

    return true;
}

// Hàm quay lui
void backtrack(vector<int>& chosen, int index) {
    // Nếu đã chọn đủ mã cổ phiếu
    if (chosen.size() > L) return; // Vượt quá số lượng tối đa L
    if (isValid(chosen)) result++; // Nếu hợp lệ, tăng kết quả

    // Thử từng mã cổ phiếu tiếp theo
    for (int i = index; i <= n1 + n2; i++) {
        chosen.push_back(i);
        backtrack(chosen, i + 1); // Tiếp tục quay lui với mã tiếp theo
        chosen.pop_back();        // Bỏ mã cuối để thử tổ hợp khác
    }
}

int main() {
    // Nhập dữ liệu
    cin >> n1 >> n2; // Số mã cổ phiếu nhóm công nghệ và bán lẻ
    cin >> L >> M >> P; // Các thông số L, M, P

    // Nhập các cặp không thể chọn cùng nhau
    for (int i = 0; i < P; i++) {
        int u, v;
        cin >> u >> v;
        conflicts.emplace_back(u, v);
    }

    // Bắt đầu quay lui
    vector<int> chosen;
    backtrack(chosen, 1);

    // Xuất kết quả
    cout << result << endl;
    return 0;
}
