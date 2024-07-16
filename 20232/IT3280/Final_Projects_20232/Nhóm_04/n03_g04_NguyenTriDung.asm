.eqv SEVENSEG_LEFT 0xFFFF0011 		#Địa chỉ của đèn led 7 đoạn trái

.eqv SEVENSEG_RIGHT 0xFFFF0010 		# Địa chỉ của đèn led 7 đoạn phải

.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012  #Địa chỉ bàn phím

.eqv MASK_CAUSE_COUNTER 0x00000400 	#Bit 10: Counter interrupt

.eqv COUNTER 0xFFFF0013 		#Time Counter

.eqv KEY_CODE   0xFFFF0004         	#ASCII code from keyboard, 1 byte 

.eqv KEY_READY  0xFFFF0000        	#=1 if has a new keycode?  
.data

mang_so: .byte 	63, 6,  91, 79, 102, 109 ,125, 7, 127, 111	 #mảng chứa số 0-9 để hiển thị ra 7segs LED (mỗi số 1 byte)

string: .asciiz "Bo mon ky thuat may tinh" 

message1: .asciiz "Tong thoi gian chay chuong trinh "

message2: .asciiz "(s) \nToc do go trung binh: "

message3: .asciiz " tu/phut\n"

Continue: .asciiz "Tiep tuc nhap?"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

# MAIN 

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.text	

MAIN:	  

	# Kích hoạt ngắt COUNTER

	li	$k0,  KEY_CODE              

	li  	$k1,  KEY_READY 

	li 	$t1, COUNTER		

	sb 	$t1, 0($t1)		#Kích hoạt

	addi	$s0, $0, 0		#Đếm số ký tự từng giây

	addi	$s1, $0, 0		#Số ký tự đúng

	addi	$s2, $0, 0		#Tổng số ký tự nhập vào

	addi	$s3, $0, 0		#Tổng số lần ngắt Counter

	addi	$s4, $0, 0		#Lưu ký tự trước đó

	addi	$s5, $0, 0		#Tổng thời gian chạy chương trình

	la	$a1, string		#Chuỗi cần so sánh

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#Vòng lặp vô hạn

loop: 

	lw   	$t1, 0($k1)                 	#$t1 = [$k1] = KEY_READY              

	bne  	$t1, $zero, make_Keyboard_Intr	#tạo interrupt khi có phím nhấn vào

	addi	$v0, $0, 32

	li	$a0, 5				#Ngủ 5ms

	syscall

	b 	loop				#Cứ lặp 5 lần tạo 1 counter interrupt

	nop

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

make_Keyboard_Intr:

	teqi	$t1, 1				#Check để nhảy vào ngắt .ktext

	b	loop				# Khi return từ chương trình ngắt thì kiểm tra tiếp char tiếp theo nhập vào

	nop

end_Main:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#PHẦN PHỤC VỤ NGẮT

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

.ktext 0x80000180

dis_int:li 	$t1, COUNTER 			#Vô hiệu hoá bộ đếm thời gian

	sb 	$zero, 0($t1)				

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

#LAY GIA TRI CUA THANH GHI C0.cause DE KIEM TRA LOAI INTERRUPT

get_Caus:mfc0 	$t1, $13 			#$t1 = Coproc0.cause

isCount:li 	$t2, MASK_CAUSE_COUNTER		#if Cause value confirm Counter..

	 and 	$at, $t1,$t2	

	 bne 	$at,$t2, keyboard_Intr			#Kiểm tra xem nếu không phải do bộ đếm thì nhảy đến ngắt bàn phím

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

#NGẮT DO BỘ ĐẾM COUNTER

counter_Intr:

	blt	$s3, 40, continue		#40 lần ngắt tương đương 40 lần ngủ 5ms -> tổng là 200 ms ngủ -> 40 lần ngắt tương đương 1 giây chương trình-> khoi tao lai $s3, chieu toc do go ra DLS, tăng biến đếm thời gian lên 1

	jal	hien_thi			#Nếu đủ 1s thì nhảy đến phần hiển thị

	addi	$s3, $0, 0			# reset số lần ngắt

	addi	$s5, $s5, 1			# Tăng thời gian chạy

	j	en_int 		

	nop

continue:

	addi	$s3, $s3, 1			# Tăng số lần ngắt nếu chưa đủ 1s

	j 	en_int

	nop

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

#NGẮT DO BÀN PHÍM

keyboard_Intr:

kiem_tra_ky_tu:					#Kiểm tra ký tự nhập vào

	lb	$t0, 0($a1)			#Get char string test case 

	lb	$t1, 0($k0)			#Lấy kí tự nhập vào

	beq	$t1, $0, en_int			#Check ở string test case tới NULL thì dừng

	beq 	$t1, '\n', end_Program		#Kí tự là “\n” tiến hành kiểm tra và in

	bne	$t0, $t1, kiem_tra_dau_cach	#Nếu kí tự nhập vào và kí tự thứ i trong mảng giống nhau -> đếm số ký tự đúng , nếu không thì chuyển đến phần kiểm tra dấu cách

	nop

	addi	$s1, $s1, 1			#tăng biến đếm số ký tự đúng

kiem_tra_dau_cach:				#kiểm tra nhập vào có phải dấu cách không

#-----------------------------------------------------------------  

# Kiểm tra để đếm số TỪ nhập vào:

# Nếu nhập vào space cần kiểm tra 2 TH

# TH1: trước space vừa nhập là 1 char -> Tính +1 từ

# TH2: trước space vừa nhập cũng là 1 space -> Không tính từ -> về main

# Nếu KHÔNG nhập vào space thì tiếp tục đọc ký tự nhập vào tiếp (về main)

#-----------------------------------------------------------------  

	bne	$t1, ' ', end_Process		#Nếu ký tự nhập vào == ' ' && ký tự trước đó != ' ' thì đếm số từ đã nhập

	nop

	beq	$s4, ' ', end_Process

	nop

	addi	$s2, $s2, 1			#Tăng số từ +1

end_Process:

	addi	$s0, $s0, 1			#Tang so ky tu trong 1s len 1

	addi	$s4, $t1, 0			# Save lại char vừa check

	addi	$a1, $a1, 1 			# Tăng con trỏ string test case thêm 1 byte

	j en_int

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# CHIẾU RA MÀN HÌNH DIGITAL LAB SIM SỐ KÝ TỰ ĐÚNG MỖI GIÂY

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

hien_thi:

	addi	$sp, $sp, -4			#Giảm giá trị 4 byte tăng kích thước ngăn xếp  để lưu trữ giá trị mới

	sw	$ra, ($sp)			#Lưu giá trị của thanh ghi ra ( địa chỉ trả về ) vào địa chỉ của $sp

	addi	$t0, $0, 10			#gán giá trị 10 cho $t0

	div	$s0, $t0			#$s0 là số ký tự đúng cần chia 10 để lấy hàng chục và hàng đơn vị hiển thị ra đèn led

	mflo	$v1				# Lấy số hàng chục

	mfhi	$v0				# Lấy số hàng đơn vị

	la 	$a0, mang_so		# lấy địa chỉ mảng số

	add	$a0, $a0, $v1			#Lấy địa chỉ có giá trị  hàng chục để hiển thị

	lb 	$a0, 0($a0) 			#Set value for segments

	jal 	SHOW_7SEG_LEFT 			#Hien thi

	la 	$a0, mang_so 

	add	$a0, $a0, $v0			#Lấy địa chỉ có giá trị  hàng đơn vị để hiển thị

	lb 	$a0, 0($a0) 			#Set value for segments

	jal 	SHOW_7SEG_RIGHT 		#Hien thi

	addi	$s0, $0, 0			#Sau khi chiếu ra màn hình thì khởi tạo lại biến đếm $s0 

	lw	$ra, ($sp)

	addi	$sp, $sp, 4

	jr 	$ra				#Return về ngắt

SHOW_7SEG_LEFT: 

	li 	$t0, SEVENSEG_LEFT 		#Assign port's address

	sb 	$a0, 0($t0) 			#Assign new value

	jr 	$ra

SHOW_7SEG_RIGHT: 

	li 	$t0, SEVENSEG_RIGHT 		#Assign port's address

	sb 	$a0, 0($t0) 			#Assign new value

	jr 	$ra

	nop

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# KET THUC CHUONG TRINH VA HIEN THI SO KY TU DUNG

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

end_Program:

	 addi	$v0, $0, 4

	 la	$a0, message1		#Tong thoi gian chay chuong trinh

	 syscall

	 addi	$v0, $0, 1

	 addi	$a0, $s5, 0		#in ra gia tri thoi gian chay chuong trinh

	 syscall

	 addi	$v0, $0, 4

	 la	$a0, message2		#Toc do go trung binh

	 syscall

	 addi	$v0, $0, 1

	 addi	$a0, $0, 60

	 mult	$s2, $a0		#So tu * 60

	 mflo	$s2

	 div	$s2, $s5		#So tu / tong thoi gian(s)

	 mflo	$a0

	 syscall

	 addi	$v0, $0, 4

	 la	$a0, message3		

	 syscall

	 addi	$s0, $s1, 0		#Gan tong so tu dung cho $s0

	 jal	hien_thi		#Hien thi den led

CONTINUE:

	li $v0, 50

	la $a0, Continue		#Tiep tuc nhap hay khong

	syscall

	beq $a0, 0, MAIN		# So sánh giá trị của thanh ghi $a0 với 0 và nhảy đến nhãn MAIN nếu chúng bằng nhau.

	li $v0, 10			# Ket thuc chuong trinh

	syscall	 

# ----------------------- Ket thuc ngat va quay lai chuong trinh --------------------------------------

en_int: 

	li 	$t1, COUNTER			#kich hoat lai ngat

	sb 	$t1, 0($t1)

	mtc0 	$zero, $13 			#Must clear cause reg

next_pc: mfc0 	$at, $14 			#$at <= Coproc0.$14 = Coproc0.epc

	 addi 	$at, $at, 4 			#$at = $at + 4 (next instruction)

	 mtc0 	$at, $14 			#Coproc0.$14 = Coproc0.epc <= $at

return: eret 					#Return from exception

