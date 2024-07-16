.data
	Message: .asciiz "Nhap vao 1 so nguyen duong N: "   
	Message1: .asciiz "N la so chinh phuong\n"       
	Message2: .asciiz "N khong la so chinh phuong\n" 
	Message3: .asciiz "Cac so chinh phuong nho hon N la:\n"  
	Message4: .asciiz "Khong co so chinh phuong nho hon N"  
	Space: .asciiz " "                                  
	Eror: .asciiz "So nhap vao phai lon hon 0!\n"       

.text
main:
	# Input N
	li $v0, 4
	la $a0, Message
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0    # Lưu số nguyên nhập vào $s0 
	bltz $s0, PrintEror   # Kiểm tra N có nhỏ hơn 0 không, nếu đúng, in thông báo lỗi
	beqz $s0, Print_perfect_square  # Kiểm tra N có bằng 0 không, nếu đúng, N là số chính phương
	li $t0, 0    # Khởi tạo $t0 bằng 0 để bắt đầu kiểm tra số chính phương
	j check    # Nhảy tới check

exit:
	# Kết thúc chương trình
	li $v0, 10
	syscall

check:
	addi $t0, $t0, 1   # Tăng $t0 lên 1 để kiểm tra số tiếp theo có phải là số chính phương không
	div $s0, $t0    # Chia N cho số hiện tại ($t0)
	mfhi $t1    # Lấy phần dư của phép chia
	beqz $t1, check_perfect_square   # Nếu phần dư bằng 0 -> brach
	j check   # Nếu không, tiếp tục kiểm tra số tiếp theo

check_perfect_square:
	mflo $t2    # Lấy phần thương của phép chia
	beq $t2, $t0, Print_perfect_square   # Nếu phần thương bằng số hiện tại, đó là số chính phương
	blt $t2, $t0, Print_not_perfect   # Nếu phần thương nhỏ hơn số hiện tại, N không phải là số chính phương
	j check   # Nếu không, tiếp tục kiểm tra số tiếp theo

Print_perfect_square:
	# In thông báo N là số chính phương
	li $v0, 4
	la $a0, Message1
	syscall
	j Number_perfect_square

Print_not_perfect:
	# In thông báo N không phải là số chính phương
	li $v0, 4
	la $a0, Message2
	syscall
	j Number_perfect_square

PrintEror:
	# In thông báo lỗi khi N nhỏ hơn hoặc bằng 0
	li $v0, 4
	la $a0, Eror
	syscall
	j main

Number_perfect_square:
	beqz $s0, Print_no_number
	# In thông báo danh sách các số chính phương nhỏ hơn N
	li $v0, 4
	la $a0, Message3
	syscall
	# In các số chính phương nhỏ hơn N
	li $v0, 1
	li $a0, 0
	syscall
	# In dấu cách để căn chỉnh định dạng
	li $v0, 4
	la $a0, Space
	syscall
	# Khởi tạo biến $s1 là số chính phương đầu tiên là 1
	li $s1, 1
	li $t0, 1

loop:
	beq $s1, $s0, exit
	# Kiểm tra số hiện tại có phải là số chính phương không
	div $s1, $t0
	mfhi $t1
	beqz $t1, check_number  
	addi $s1, $s1, 1
	j loop

check_number:
	mflo $t2
	beq $t2, $t0, Print_Number
	blt $t2, $t0, reset # Thương < số bị chia -> Dừng lại 
	addi $t0, $t0, 1	
	# Tăng số bị chia lên 1 để kiểm tra tiếp cho đến khi số bị chia bằng số chia
	j loop

reset:
	addi $t0, $zero, 1 
	addi $s1, $s1, 1
	j loop

Print_Number:
	# In số chính phương
	li $v0, 1
	addi $a0, $s1, 0
	syscall
	# In dấu cách để căn chỉnh định dạng
	li $v0, 4
	la $a0, Space
	syscall
	j reset

Print_no_number:
	# In thông báo không có số chính phương nhỏ hơn N
	li $v0, 4
	la $a0, Message4
	syscall
	j exit
