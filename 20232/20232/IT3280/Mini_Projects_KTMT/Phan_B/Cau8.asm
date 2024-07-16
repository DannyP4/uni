.data
	A:	 	.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "Tong cac phan tu chan la: "
	Message3: 	.asciiz "Tong cac phan tu le la: "
	NewLine: 	.asciiz "\n"
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	# Nhap N: 
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0		# $s0 = N
	blt 	$s0, 1, PrintEror	# N < 1 => Error branch
	la 	$a1, A			# $a1 = address A[0]
	j 	input_array
	
exit:
	li 	$v0, 10
	syscall
	
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
	li 	$s1, 0		# $s1 = SumEven
	li 	$s2, 0		# $s2 = SumOdd
	li 	$s3, 2
	li 	$t0, 0		# $t0 = i = 0
	
loop:
	beq 	$t0, $s0, PrintSum	# $t0 = N => Print branch
	lw 	$t1, 0($a1)		# $t1 = A[i]
	div 	$t1, $s3		# $t1 / 2
	mfhi 	$t2			# $t2 = mod 2 of $t1 / 2 
	beq 	$t2, 0, SumEven		# $t2 = 0 => even
	bne 	$t2, 0, SumOdd		# $t2 = 1 => odd
	
continue:
	addi 	$t0, $t0, 1		# i++
	addi 	$a1 $a1, 4
	j 	loop
	
SumEven:
	add 	$s1, $s1, $t1		# update SumEven
	j 	continue
	
SumOdd:
	add 	$s2, $s2, $t1		# update SumOdd
	j 	continue
	
PrintSum:
	# Print output
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
	
PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	j 	main