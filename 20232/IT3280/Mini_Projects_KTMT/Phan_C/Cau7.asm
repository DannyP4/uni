.data
	m: .asciiz "nhap sau thu nhat: "
	m2: .asciiz "nhap sau thu hai: "
	m3: .asciiz "xau 2 là con cua xau 1"
	m4: .asciiz "xau 2 khong phai con cua xau 1"
	string: .space 100
	string2: .space 100
	
.text
main: 
	li $v0, 54
	la $a0, m
	la $a1, string
	la $a2 100
	syscall # nhập chuỗi 1
	li $v0, 54
	la $a0, m2
	la $a1, string2
	la $a2 100
	syscall # nhập chuỗi 2
set:
	la $t0, string
	la $t1, string2
	lb $s1, 0($t1)
	li $t2, 10 # \n
	addi $t0, $t0, -1
head_check: # hàm này duyệt cho đến khi kí tự đầu của chuỗi 2 = một ký tự nào đó của chuỗi 1
	lb $s0, 1($t0)
	beq $s0, $t2, fail 
	# nếu đã duyệt hết chuỗi 1 mà vẫn ko = nhau thì 2 ko phải con của 1
	addi $t0, $t0, 1
	bne $s0, $s1, head_check
compare: # kiểm tra từng ký tự có = nhau ko
	lb $s0, 0($t0)
	lb $s1, 0($t1)
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	beq $s1, $t2, success 
	# nếu đã duyệt hết chuỗi 2 mà vẫn = nhau thì 2 là con của 1
	beq $s0, $s1, compare 
	la $t1, string2 
	# duyệt lại chuỗi 2 nếu như 2 ký tự trên ko = nhau
	j head_check
success:
	li $v0, 4
	la $a0, m3
	syscall
	j end
fail:
	li $v0, 4
	la $a0, m4
	syscall
end:
	
	
