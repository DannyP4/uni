.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "
	Message1: .asciiz "Chu so nho nhat cua N la: "
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
	# Lưu giá trị nhập vào vào $s0
	move $s0, $v0
	# Kiểm tra N có nhỏ hơn 0 không
	bltz $s0, PrintEror
	# Kiểm tra N có ít nhất 2 chữ số không
	li $t0, 10
	blt $s0, $t0, PrintEror2
	# Khởi tạo biến $s1 để lưu giá trị chữ số nhỏ nhất, ban đầu gán bằng 9
	li $s1, 9
	# Gọi hàm check để tìm chữ số nhỏ nhất
	j check
	
exit:
	# Kết thúc chương trình
	li $v0, 10
	syscall
	
check:
	# Kiểm tra N có bằng 0 không
	beqz $s0, PrintResult
	# Chia N cho 10 để lấy chữ số cuối cùng và phần dư
	div  $s0, $t0
	mfhi $t1
	mflo $t2
	# Lấy chữ số cuối cùng và cập nhật giá trị của N
	addi $s0, $t2, 0
	# So sánh chữ số hiện tại với chữ số nhỏ nhất hiện tại
	blt  $t1, $s1, Update  
	# Nếu chữ số hiện tại không lớn hơn chữ số lớn nhất, tiếp tục kiểm tra các chữ số khác
	j check
	
Update:
	# Nếu chữ số hiện tại nhỏ hơn chữ số nhỏ nhất, cập nhật lại giá trị của chữ số nhỏ nhất
	addi $s1, $t1, 0
	# Tiếp tục kiểm tra các chữ số khác
	j check
	
PrintEror:
	# In thông báo lỗi khi N nhỏ hơn hoặc bằng 0
	li $v0, 4
	la $a0, Eror
	syscall
	# Quay lại nhập lại số N
	j main
	
PrintEror2:
	# In thông báo lỗi khi N không có ít nhất 2 chữ số
	li $v0, 4
	la $a0, Eror1
	syscall
	# Quay lại nhập lại số N
	j main
	
PrintResult:
	# In thông báo chữ số nhỏ nhất của N
	li $v0, 4
	la $a0, Message1
	syscall
	# In chữ số nhỏ nhất
	li $v0, 1
	addi $a0, $s1, 0
	syscall
	# Kết thúc chương trình
	j exit

	
