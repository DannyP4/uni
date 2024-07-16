
.eqv SCREEN, 0x10010000
.eqv YELLOW, 0x00FFFF66
.eqv BACKGROUND, 0x00000000

# Thiết lập ký tự
.eqv KEY_A, 0x00000061         # Di chuyển sang trái
.eqv KEY_D, 0x00000064         # Di chuyển sang phải
.eqv KEY_S, 0x00000073         # Di chuyển xuống dưới
.eqv KEY_W, 0x00000077         # Di chuyển lên trên
.eqv KEY_Z, 0x0000007A         # Tăng tốc độ di chuyển
.eqv KEY_X, 0x00000078         # Giảm tốc độ di chuyển
.eqv KEY_ENTER, 0x0000000A     # Chương trình dừng lại

# Thiết lập khoảng cách giữa hai đường tròn
.eqv KHOANG_CACH, 10
.eqv KEY_CODE, 0xFFFF0004
.eqv KEY_READY, 0xFFFF0000

#==========================================================================================
.data
    Array: .space 512         # Cấp bộ nhớ lưu tọa độ các điểm của đường tròn
.text
    li  $s0, 256             # x = 256 khởi tạo tọa độ x ban đầu của tâm đường tròn
    li  $s1, 256             # y = 256 khởi tạo tọa độ y ban đầu của tâm đường tròn
    li  $s2, 20              # R = 20, R là bán kính của đường tròn
    li  $s3, 512             # SCREEN_WIDTH = 512, chiều rộng màn hình
    li  $s4, 512             # SCREEN_HEIGHT = 512, chiều dài màn hình
    li  $s5, YELLOW          # Đường tròn có màu vàng
    li  $t6, KHOANG_CACH     # Khoảng cách giữa các hình tròn
    li  $s7, 0               # dx = 0, tọa độ x hiện tại của tâm đường tròn
    li  $t8, 0               # dy = 0, tọa độ y hiện tại của tâm đường tròn
    li  $t9, 70              # Thanh ghi lưu trữ thời gian delay (tốc độ di chuyển của hình tròn)

#==========================================================================================
# HÀM KHỞI TẠO TỌA ĐỘ ĐƯỜNG TRÒN
#=========================================================================================
khoi_tao:
    li  $t0, 0               # Khởi tạo i = 0
    la  $t5, Array           # Lưu địa chỉ của mảng vào thanh ghi $t5
loop:
    slt $v0, $t0, $s2        # v0=1 nếu i < R
    beq $v0, $zero, ket_thuc # v0=0 <=> i >= R thì nhảy đến kết_thuc
    mul $s6, $s2, $s2        # s6 = R * R = R^2
    mul $t3, $t0, $t0        # t3 = i * i = i^2
    sub $t3, $s6, $t3        # t3 = R^2 - i^2
    move $v1, $t3            # v1 = t3
    jal sqrt                 # Nhảy đến hàm tính căn của t3

    sw  $a0, 0($t5)          # Lấy giá trị của thanh ghi a0 = sqrt(R^2 - i^2) lưu vào mảng dữ liệu
    addi $t0, $t0, 1         # i = i + 1
    add $t5, $t5, 4          # Đi đến vị trí tiếp theo của mảng dữ liệu
    j   loop
ket_thuc:

#==========================================================================================
# HÀM LÀM CHO CHƯƠNG TRÌNH DỪNG CHẠY TRONG MỘT KHOẢNG THỜI GIAN
#==========================================================================================
.macro delay(%r)
    addi $a0, %r, 0
    li   $v0, 32
    syscall
.end_macro

# Tạo hàm để đặt lại màu và vẽ thêm đường tròn ở vị trí mới
# Địa chỉ của màu lưu ở thanh ghi %color khi gọi hàm
.macro datmauveduongtron(%color)
    li   $s5, %color
    jal  ham_ve_duong_tron
.end_macro

#===========================================================================================
# HÀM NHẬP DỮ LIỆU TỪ BÀN PHÍM
#===========================================================================================
Start:
doc_ky_tu:
    lw  $k1, KEY_READY       # Kiểm tra đã nhập ký tự nào chưa?
    beqz $k1, check_vi_tri   # Nếu k1 != 0 => đã nhập ký tự thì nhảy đến hàm kiểm tra vị trí
    lw  $k0, KEY_CODE        # Thanh ghi k0 lưu giá trị ký tự nhập vào
    beq $k0, KEY_A, case_a   # Di chuyển qua trái
    beq $k0, KEY_D, case_d   # Di chuyển qua phải
    beq $k0, KEY_S, case_s   # Di chuyển xuống dưới
    beq $k0, KEY_W, case_w   # Di chuyển lên trên
    beq $k0, KEY_Z, case_z   # Tăng tốc độ
    beq $k0, KEY_X, case_x   # Giảm tốc độ
    beq $k0, KEY_ENTER, case_enter # Dừng chương trình
    j   check_vi_tri
    nop

case_a:
    jal di_sang_trai
    j   check_vi_tri

case_d:
    jal di_sang_phai
    j   check_vi_tri

case_s:
    jal di_chuyen_xuong
    j   check_vi_tri

case_w:
    jal di_chuyen_len
    j   check_vi_tri

case_x:
    addi $t9, $t9, 30
    j    check_vi_tri

case_z:
    addi $t9, $t9, -30
    j    check_vi_tri

case_enter:
    j   endProgram

endProgram:
    li  $v0, 10
    syscall

#==========================================================================================
# CÁC HÀM DI CHUYỂN
#==========================================================================================
di_sang_trai:
    sub $s7, $zero, $t6     # Tọa độ x hiện tại của đường tròn = - khoảng cách giữa 2 đường tròn
    li  $t8, 0
    jr  $ra

di_sang_phai:
    add $s7, $zero, $t6     # Tọa độ x hiện tại của đường tròn = + khoảng cách giữa 2 đường tròn
    li  $t8, 0
    jr  $ra

di_chuyen_len:
    li  $s7, 0
    sub $t8, $zero, $t6     # Tọa độ y hiện tại của đường tròn = - khoảng cách giữa 2 đường tròn
    jr  $ra

di_chuyen_xuong:
    li  $s7, 0
    add $t8, $zero, $t6     # Tọa độ y hiện tại của đường tròn = + khoảng cách giữa 2 đường tròn
    jr  $ra

#===============================================================================================
# HÀM KIỂM TRA VỊ TRÍ
#===============================================================================================
check_vi_tri:
phia_ben_phai:
    add $v0, $s0, $s2        # v0 = x0 + R, tọa độ tâm hiện tại + bán kính
    add $v0, $v0, $s7        # Nếu x0 + R + khoảng cách > 512 thì nhảy đến hàm di_sang_trai
    slt $v1, $v0, $s3        # v1 = 1 nếu v0 < 512
    bne $v1, $zero, phia_ben_trai
    jal di_sang_trai
    nop

phia_ben_trai:
    sub $v0, $s0, $s2        # v0 = x0 - R
    add $v0, $v0, $s7        # Nếu x0 - R + khoảng cách < 0 thì nhảy đến hàm di_sang_phai
    slt $v1, $v0, $zero      # v1 = 1 nếu v0 < 0
    beq $v1, $zero, phia_tren
    jal di_sang_phai
    nop

phia_tren:
    sub $v0, $s1, $s2        # v0 = y0 - R
    add $v0, $v0, $t8        # Nếu y0 - R + khoảng cách < 0 thì nhảy đến hàm di_chuyen_len
    slt $v1, $v0, $zero      # v1 = 1 nếu v0 < 0
    beq $v1, $zero, phia_duoi
    jal di_chuyen_xuong
    nop

phia_duoi:
    add $v0, $s1, $s2        # v0 = y0 + R
    add $v0, $v0, $t8        # Nếu y0 + R + khoảng cách > 512 thì nhảy đến hàm di_chuyen_xuong
    slt $v1, $v0, $s4        # v1 = 1 nếu v0 < 512
    bne $v1, $zero, draw
    jal di_chuyen_len
    nop

#================================================================================================
# HÀM VẼ ĐƯỜNG TRÒN
#================================================================================================
draw:
    datmauveduongtron(BACKGROUND)  # Vẽ đường tròn trung màu nền
    add $s0, $s0, $s7              # Cập nhật tọa độ x của đường tròn
    add $s1, $s1, $t8              # Cập nhật tọa độ y của đường tròn

    datmauveduongtron(YELLOW)      # Vẽ đường tròn mới màu vàng
    delay($t9)                     # Dừng 1 khoảng thời gian rồi vẽ đường tròn mới
    j Start

ham_ve_duong_tron:
    add  $sp, $sp, -4
    sw   $ra, 0($sp)
    li   $t0, 0                   # Khởi tạo biến i = 0

loop_ve_duong_tron:
    slt  $v0, $t0, $s2            # v0 = 1 nếu i < R
    beq  $v0, $zero, ket_thuc_ve  # Nếu v0 = 0 <=> i >= R => ket_thuc_ve
    sll  $t5, $t0, 2              # Dịch trái thanh ghi t0 2 bit
    lw   $t3, Array($t5)          # Nạp sqrt(R^2-i^2) lưu ở Array vào thanh ghi $t3(y)
    move $a0, $t0                 # i = $t0 = $a0
    move $a1, $t3                 # j = $t3 = $a1
    jal  ve_diem                  # Vẽ 2 điểm (x0 + i, y0 + j), (x0 + j, y0 + i) trên phần tử thứ I
    sub  $a1, $zero, $t3
    jal  ve_diem                  # Vẽ 2 điểm (x0 + i, y0 - j), (x0 + j, y0 - i) trên phần tử thứ II
    sub  $a0, $zero, $t0
    jal  ve_diem                  # Vẽ 2 điểm (x0 - i, y0 - j), (x0 - j, y0 - i) trên phần tử thứ III
    add  $a1, $zero, $t3
    jal  ve_diem                  # Vẽ 2 điểm (x0 - i, y0 + j), (x0 - j, y0 + i) trên phần tử thứ IV
    addi $t0, $t0, 1
    j    loop_ve_duong_tron

ket_thuc_ve:
    lw   $ra, 0($sp)
    add  $sp, $sp, 0
    jr   $ra

# Ham vẽ điểm trên đường tròn
ve_diem:
    add  $t1, $s0, $a0           # xi = x0 + i
    add  $t4, $s1, $a1           # yi = y0 + j
    mul  $t2, $t4, $s3           # yi * SCREEN_WIDTH
    add  $t1, $t1, $t2           # yi * SCREEN_WIDTH + xi (Tọa độ 1 chiều của điểm ảnh)
    sll  $t1, $t1, 2             # Địa chỉ tương đối của điểm ảnh
    sw   $s5, SCREEN($t1)        # Vẽ ảnh

    add  $t1, $s0, $a1           # xi = x0 + j
    add  $t4, $s1, $a0           # yi = y0 + i
    mul  $t2, $t4, $s3           # yi * SCREEN_WIDTH
    add  $t1, $t1, $t2           # yi * SCREEN_WIDTH + xi (Tọa độ 1 chiều của điểm ảnh)
    sll  $t1, $t1, 2             # Địa chỉ tương đối của điểm ảnh
    sw   $s5, SCREEN($t1)        # Vẽ ảnh
    jr   $ra

# Ham tính căn của t3
sqrt:
    mtc1 $v1, $f1                # Đưa giá trị trong thanh ghi v1 vào thanh ghi f1
    cvt.s.w $f1, $f1             # Chuyển giá trị của f1 tương đương với giá trị số nguyên 32 bit
    sqrt.s $f1, $f1              # Tính căn bậc hai của giá trị thanh ghi f1
    cvt.w.s $f1, $f1             # Chuyển f1 về dạng 32-bit
    mfc1 $a0, $f1                # Đặt giá trị thanh ghi a0 = f1
    jr   $ra

# End of project
