.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "		
	Message1: .asciiz "Cac chu so cua N theo thu tu dao nguoc la: "	
	Eror: .asciiz "So nhap vao phai lon hon 0!\n"		
	Eror1: .asciiz "So nhap vao phai co it nhat 2 chu so!\n"

.text
main:
	# In thông báo yêu cầu nhập số nguyên dương N
	li $v0, 4
	la $a0, Message
	syscall
	# Nhập số nguyên dương N từ bàn phím
	li $v0, 5
	syscall
	move $s0, $v0		# Lưu giá trị nhập vào vào $s0
	bltz $s0, PrintEror	# Nếu số nhập vào là số âm hoặc bằng 0, in thông báo lỗi và quay lại nhập lại số N
	li $t0, 10			# Gán $t0 = 10 để sử dụng cho việc chia N cho 10 để lấy từng chữ số
	blt $s0, $t0, PrintEror2	# Nếu N có ít hơn 2 chữ số, in thông báo lỗi và quay lại nhập lại số N
	li $v0, 4			# Load syscall để in thông báo kết quả
	la $a0, Message1	# Load địa chỉ của chuỗi thông báo kết quả
	syscall
	li $s1, 0			# Khởi tạo $s1 để lưu từng chữ số của N theo thứ tự đảo ngược
	j loop				# Gọi hàm loop để in từng chữ số của N theo thứ tự đảo ngược

exit:
	li $v0, 10			# Kết thúc chương trình
	syscall
	
loop:
	beqz $s0, exit		# Nếu N = 0, thoát khỏi vòng lặp và kết thúc chương trình
	div $s0, $t0		# Chia N cho 10 để lấy chữ số cuối cùng
	mfhi $t1			# Lấy phần dư của phép chia và lưu vào $t1
	mflo $t2			# Lấy phần nguyên của phép chia và lưu vào $t2
	addi $s0, $t2, 0	# Cập nhật lại giá trị của N bằng phần nguyên sau khi chia
	# In chữ số cuối cùng của N theo thứ tự đảo ngược
PrintResult:
	li $v0, 1
	addi $a0, $t1, 0
	syscall
	j loop				# Lặp lại cho đến khi N = 0 để in ra tất cả các chữ số của N theo thứ tự đảo ngược
	
PrintEror:
	# In thông báo lỗi khi N là số âm hoặc bằng 0
	li $v0, 4
	la $a0, Eror
	syscall
	j main				# Quay lại để nhập lại số N
	
PrintEror2:
	# In thông báo lỗi khi N có ít hơn 2 chữ số
	li $v0, 4
	la $a0, Eror1
	syscall
	j main				# Quay lại để nhập lại số N
