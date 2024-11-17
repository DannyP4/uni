.data
	A:	 	.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "Tong cac phan tu le la: "
	Message3: 	.asciiz "Tong cac phan tu am la: "
	NewLine: 	.asciiz "\n"
	Error: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	# Nhap N: 
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0		# $s0 = N
	blt 	$s0, 1, PrintError	# N < 1 => error
	la 	$a1, A			# $a1 = address A[0]
	
input_array:
	# Nhap cac phan tu cua array:
	beq 	$t2, $s0, CheckSum
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
	
CheckSum:
	li 	$s1, 0		# $s1 = SumOdd = tong phan tu le
	li 	$s2, 0		# $s2 = SumNega = tong phan tu am
	li 	$s3, 2
	li 	$t0, 0		# $t0 = i = 0
	
loop:
	beq 	$t0, $s0, PrintSum	# $t0 = N => Print branch
	lw 	$t1, 0($a1)		# $t1 = A[i]
	
	# kiem tra phan tu le:
	div	$t1, $s3		# A[i] / 2
	mfhi	$t9			# lay so du phep chia tren
	jal	CheckOdd 
	
	# kiem tra phan tu am:
	jal	CheckNega
	
continue:
	addi 	$t0, $t0, 1		# i++
	addi 	$a1, $a1, 4
	j 	loop

CheckOdd:
	beq	$t9, 1, SumOdd		# neu $t9 = 1 nghia la A[i] le => tinh tong
	beq	$t9, -1, SumOdd		# neu $t9 = -1 nghia la A[i] vua am vua le => tinh tong
	jr	$ra			# neu khong thi kiem tra tiep co am khong?
	
SumOdd:
	add 	$s1, $s1, $t1		# update SumPosi
	jr 	$ra			# neu co thi kiem tra tiep co am khong?

CheckNega:
	blt	$t1, 0, SumNega		# neu A[i] < 0 => tinh tong
	jr	$ra			# neu khong thi tiep vong lap moi
	
SumNega:
	add 	$s2, $s2, $t1		# update SumNega
	j 	continue
	
PrintSum:
	# in ket qua:
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
	li 	$v0, 1
	addi 	$a0, $s1, 0
	syscall
	
	li 	$v0, 4
	la 	$a0, NewLine
	syscall
	
	la 	$a0, Message3
	syscall
	
	li 	$v0, 1
	addi 	$a0, $s2, 0
	syscall
	j 	exit
	
PrintError:
	# in ra loi:
	li 	$v0, 4
	la 	$a0, Error
	syscall
	j 	main

exit:
	# ket thuc chuong trinh
	li 	$v0, 10
	syscall
