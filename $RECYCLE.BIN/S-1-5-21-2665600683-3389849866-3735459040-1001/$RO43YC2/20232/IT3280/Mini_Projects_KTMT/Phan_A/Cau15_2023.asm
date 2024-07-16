.data
	inputM:		.asciiz "Nhap M: "
	inputN:		.asciiz "Nhap N: "
	inputQ:		.asciiz "Nhap Q: "
	Error1:		.asciiz "M phai nho hon N, nhap lai N: "
	Error2:		.asciiz "Q phai lon hon hoac bang M * N, nhap lai Q: "
	Enter:		.asciiz "\n"
	Space:		.asciiz " "

.text
input_M:
	# nhap M:
	li	$v0, 4
	la	$a0, inputM
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0	# gan $s0 = M

input_N:
	# nhap N:
	li	$v0, 4
	la	$a0, inputN
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s1, $v0		# gan $s1 = N
	
	blt	$s0, $s1, input_Q	# neu M < N => tiep tuc nhap Q
	j	error1			# neu nguoc lai M >= N => error
	
input_Q:
	# nhap Q:
	li	$v0, 4
	la	$a0, inputQ
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s2, $v0		# gan $s2 = Q
	
	mul	$t9, $s0, $s1		# $t9 = M * N
	blt	$s2, $t9, error2	# neu Q < M * N => error

enter:	
	li	$v0, 4
	la 	$a0, Enter
	syscall

init:
	li	$t0, 0		# khoi tao $t0 = count la bien dem
	addi	$s1, $s1, 1	# tang N len 1 den kiem tra tu M den N
	
check:
	beq	$s0, $s1, checkCount	# neu da kiem tra het tu M den N thi ket thuc chuong trinh
	div	$s2, $s0		# Q / M
	mfhi	$t1			# $t1 luu phan du cua phep chia tren
	beq	$t1, 0, print		# neu $t1 = 0, tuc la chia M|Q thi in ket qua
	addi	$s0, $s0, 1		# tang M len 1
	j	check
	
print:
	# in ra ket qua:
	li	$v0, 1
	addi	$a0, $s0, 0
	syscall
	
	li	$v0, 4
	la	$a0, Space
	syscall
	
	addi	$s0, $s0, 1		# tang M len 1
	addi	$t0, $t0, 1		# count++
	j	check

checkCount:
	# kiem tra xem neu khong co so nao thoa man thi in ra -1
	bnez	$t0, exit
	
	li	$v0, 1
	li	$a0, -1
	syscall
	j	exit
	
error1:
	li	$v0, 4
	la	$a0, Error1
	syscall
	j	input_N

error2:
	li	$v0, 4
	la	$a0, Error2
	syscall
	j	input_Q
	
exit:
	li	$v0, 10
	syscall
	