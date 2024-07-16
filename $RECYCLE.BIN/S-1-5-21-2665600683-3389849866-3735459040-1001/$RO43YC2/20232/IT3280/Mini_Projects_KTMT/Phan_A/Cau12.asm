.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "
	Message1: .asciiz "Bieu dien o he co so 8 cua N la: "
	Eror: .asciiz "So nhap vao phai lon hon 0!\n"
.text
main:
	li $v0, 4
	la $a0, Message
	syscall
	li $v0, 5
	syscall
	move $s0, $v0		# Lưu giá trị nhập vào vào $s0
	bltz $s0, PrintEror	# Nếu số nhập vào là số âm hoặc bằng 0, in thông báo lỗi và quay lại nhập lại số N
	
	# In thông báo kết quả biểu diễn của N ở hệ cơ số 8
	li $v0, 4
	la $a0, Message1
	syscall
	li $t0, 8		# Gán $t0 = 8 để chuyển đổi N sang hệ cơ số 8
	j Oct			# Gọi hàm Oct để thực hiện chuyển đổi
	
exit:
	li $v0, 10		# Kết thúc chương trình
	syscall
	
Oct:
	div $s0, $t0			# Chia N cho 8 để lấy từng chữ số ở hệ cơ số 8
	mfhi $t1			# Lấy phần dư của phép chia và lưu vào $t1
	sw $t1, 0($sp)			# Lưu phần dư vào ngăn xếp để in từ phải sang trái
	mflo $t2			# Lấy phần nguyên của phép chia và lưu vào $t2
	addi $s0, $t2, 0		# Cập nhật lại giá trị của N bằng phần nguyên sau khi chia
	beqz $s0, PrintResult		# Nếu N = 0, kết thúc vòng lặp
	addi $sp, $sp, 4		# Dịch con trỏ ngăn xếp để lưu chữ số tiếp theo
	addi $t3, $t3, -1		# Giảm biến đếm số chữ số còn lại
	j Oct
	
PrintResult:
	bgtz $t3, exit			# Nếu số chữ số lưu trong ngăn xếp lớn hơn 0, kết thúc chương trình
	li $v0, 1
	lw $a0, 0($sp)			# Load chữ số từ ngăn xếp và in ra màn hình
	syscall
	addi $sp , $sp, -4		# Dịch con trỏ ngăn xếp để lấy chữ số tiếp theo
	addi $t3, $t3, 1		# Tăng biến đếm số chữ số đã in ra
	j PrintResult			
	
PrintEror:
	# In thông báo lỗi khi N là số âm hoặc bằng 0
	li $v0, 4
	la $a0, Eror
	syscall
	j main				# Quay lại để nhập lại số N