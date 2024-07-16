.data
	A: 		.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "Nhap M: "
	Message3: 	.asciiz "Mang nhap vao phai la mang tang! Vui long nhap lai mang:\n"
	Message4: 	.asciiz "Mang sau khi chen M la:\n"
	Space: 		.asciiz " "
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	# Nhap so phan tu N:
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0	# $s0 = $v0 = N
	move 	$t9, $s0	# $t9 = $s0 de kiem tra day co tang khong
	blt 	$s0, 1, PrintEror
	la 	$a1, A
	j 	input_array

exit:
	li 	$v0, 10
	syscall
	
input_array:
	# Nhap cac phan tu:
	beq 	$t2, $s0, Check
	add 	$t0, $a1, $t1
	li 	$v0, 4
	la 	$a0, Message1
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0
	sw 	$s1, 0($t0)
	addi 	$t2, $t2, 1
	mul 	$t1, $t2, 4
	j 	input_array
	
Check:
	li 	$t0, 0		# $t0 = i = 0
	addi 	$t1, $a1, 0	# $t1 = address of A[0]
	addi 	$t2, $s0, -1	# $t2 = N - 1
	
CheckArray:
	beq 	$t0, $t2, input_M	# i = N - 1 => input_M branch
	
	# Duyet A[i] va A[i + 1]
	lw 	$t3, 0($t1)		
	lw 	$t4, 4($t1)
	bgt 	$t3, $t4, PrintEror1	# A[i] > A[i + 1] => Error
	addi 	$t0, $t0, 1		# i++
	addi 	$t1, $t1, 4		# address of next index
	j 	CheckArray
	
input_M:
	# Nhap M:
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0	# $s1 = M
	
Insert:
	li 	$t0, 0		# $t0 = i = 0
	addi 	$t1, $a1, 0	# $t1 = address of A[i]
	
loop:
	beq 	$t0, $s0, InsertNumber	# i = N => InsertNumber branch
	lw 	$t2, 0($t1)		# duyet phan tu A[i]
	bgt 	$t2, $s1, UpdateArray	# A[i] > M => UpdateArray branch
	addi 	$t1, $t1, 4		# address of next index
	addi 	$t0, $t0, 1		# i++
	j 	loop
	
InsertNumber:
	sw 	$s1, 0($t1)
	j 	PrintResult
	
UpdateArray:
	addi 	$t3, $s1, 0 	# $t3 = M

Update:
	bgt 	$t0, $s0, PrintResult	# i > N, tuc la i = N + 1 thi in ket qua
	lw 	$t2, 0($t1)		# lay gia tri A[i] > M luu vao $t2
	sw 	$t3, 0($t1)		# thay the M vao vi tri i do
	addi 	$t0, $t0, 1		# i++
	addi 	$t1, $t1, 4		# address of next index
	addi 	$t3, $t2, 0		# gan $t3 = $t2 = A[i]
	j 	Update 
	
PrintResult:
	li 	$t0, 0		# cho lai i = 0
	addi 	$s0, $s0, 1	# tang N len 1 sau khi da chen M
	li 	$v0, 4
	la 	$a0, Message4
	syscall
	
Print:
	beq 	$t0, $s0, exit
	li 	$v0, 1
	lw 	$a0, 0($a1)
	syscall
	
	li 	$v0, 4
	la 	$a0, Space
	syscall
	
	addi 	$t0, $t0, 1
	addi 	$a1, $a1, 4
	j 	Print
	
PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	
	j 	main

PrintEror1:
	li 	$v0, 4
	la 	$a0, Message3
	syscall
	
	# Khoi tao lai cac bien
	move 	$s0, $t9
	li 	$t0, 0
	li 	$t1, 0
	li 	$t2, 0
	j 	input_array