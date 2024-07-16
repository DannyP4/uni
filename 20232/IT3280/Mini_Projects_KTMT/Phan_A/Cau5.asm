.data
	m1: .asciiz "nhap so: "
	m2: .asciiz "vui long nhap so co chu so chan"
	m3: .asciiz "day la so hoan hao"
	m4: .asciiz "day khong phai la so hoan hao"
.text 
input: 
	li $v0, 51
	la $a0, m1
	syscall
	add $s0, $zero, $a0
set:	
	li $t1, 0 # đếm số chữ số 
	li $t2, 1 
	li $t4, 2
	li $t3, 10
dk_1: # chia số đã nhập cho đến khi < 10 và sử dụng một thanh ghi để đếm mỗi lần chia để xác định có bao nhiêu chữ số 
	addi $t1, $t1, 1 # đếm chữ số 
	div $s0, $t2 # chia số đã nhập với các số 10^N
	mflo $t5 
	slti $t0, $t5, 10 # so sánh số thu được với 10
	
	mult $t2, $t3 # 10^N
	mflo $t2
	beq $t0, $zero, dk_1 
	
	div $t1, $t4 # chia số chữ số cho 2
	mfhi $t6 
	mflo $t1 # chia số chữ số làm 2 để dùng cho phần dk2
	beq $t6, $zero, set2 # nếu là số chữ số lẻ thì báo lỗi, còn lại xét đk2
	li $v0, 55
	la $a0, m2
	syscall
	j end
set2:
	li $s1, 0 # sum1
	li $s3, 0 # sum2
sum_1:	
	beq $t1, $zero, sum_2 
	div $s0, $t3 # chia số đã cho với 10
	mfhi $s2 # phần dư ta thu được từng chữ số riêng lẻ
	mflo $s0 # gán thương vào lại s0 và làm tương tự như trên để lấy từng chữ số 
	add $s1, $s1, $s2 # cộng với tổng
	sub $t1, $t1, 1 # số đếm - 1
	j sum_1
sum_2: # cách làm cơ bản giống sum_1
	div $s0, $t3
	mfhi $s2
	mflo $s0
	slti $t0, $s2, 1 
	bne $t0, $zero, dk_2
	add $s3, $s3, $s2
	j sum_2
dk_2:
	beq $s1, $s3, lucky_num # so sánh 2 tổng 
	li $v0, 55
	la $a0, m4
	la $a1, 1
	syscall
	j end
lucky_num:
	li $v0, 55
	la $a0, m3
	la $a1, 1
	syscall
end:
	li $v0, 10
	syscall


	
	

	
	
	
	
	
	
