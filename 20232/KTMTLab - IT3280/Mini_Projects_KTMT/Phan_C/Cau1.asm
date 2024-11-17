.data
	m: .asciiz "nhap chuoi: "
	m1: .asciiz "day la chuoi doi xung"
	m2: .asciiz "day la chuoi khong doi xung"
	m3: .asciiz "chi nhap 1 chuoi"
	string: .space 100
.text
main:
	li $v0, 54
	la $a0, m
	la $a1, string
	la $a2 100
	syscall # nhập chuỗi 
	la $t0, string
	add $t1, $zero, $t0 # sao chéo t1 = t0
set: 
	li $t2, 10 #t2 = \n
	li $t3, 32 #t3 = space 
	add $t0, $t0, -1
end_point: # đưa con trỏ t1 đến cuối chuỗi 
	addi $t1, $t1, 1 
	lb $s0, 0($t1)
	beq $s0, $t2, compare
	j end_point
compare: 
	addi $t1, $t1, -1 # dịch con trỏ t1 sang bên trái
	add  $t0, $t0, 1 # dịch con trỏ t0 sang bên phải
	beq $t1, $t0, success # nếu 2 con trỏ trùng nhau => đối xứng
	lb $s0, 0($t1) # lấy giá trị 
	lb $s1, 0($t0)
	beq $s0, $t3, fail_2 # nếu có khoảng trắng thì thông báo lỗi
	beq $s1, $t3, fail_2 # nếu có khoảng trắng thì thông báo lỗi
	beq $s0, $zero, success # TH số ký tự chẵn thì khi duyệt hết các ký tự thì in kết quả là đối xứng
	beq $s0, $s1, compare # kiểm tra đối xứng
	# fail khi không đối xứng 
fail: 
	li $v0, 4
	la $a0, m2
	syscall
	j end
fail_2:
	li $v0, 4
	la $a0, m3
	syscall
	j end
success:
	li $v0, 4
	la $a0, m1
	syscall
end:
	li $v0, 10
	syscall
	