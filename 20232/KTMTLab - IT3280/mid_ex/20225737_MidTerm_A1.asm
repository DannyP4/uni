.data 
	Input:		.asciiz "Nhap so N: "
	Message: 	.asciiz "Cac so chia het cho 3 hoac 5 nho hon N la: "
	Message2: 	.asciiz ", "
	Error:		.asciiz "N phai lon hon 0, nhap lai N: "
	
.text
input:
	# Nhap N:
	li 	$v0, 4 
	la 	$a0, Input
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0	# gan $s0 = N
	blt	$s0, 0, error	# N < 0 thi error

message:
	li	$v0, 4
	la	$a0, Message
	syscall

init:
	li	$t0, 0		# $t0 = i = 0
	li	$t9, 0		# $t9 = j = 0, dem xem co bao nhieu output, de xoa dau phay o cuoi
	li	$t1, 3		# $t1 = 3
	li	$t2, 5		# $t2 = 5

count_output:
	beq	$t0, $s0, restart	# neu i = N thi dung chuong trinh
	div	$t0, $t1		# i / 3
	mfhi	$t3			# $t3 la so du cua phep chia tren
	beq	$t3, 0, count		# $t3 = 0 nghia la 3|i => count++
	div	$t0, $t2		# i / 5
	mfhi	$t4			# $t4 la so du cua phep chia tren
	beq	$t4, 0, count		# $t4 = 0 nghia la 5|i => count++
	addi	$t0, $t0, 1		# i++
	j	count_output

count:
	addi	$t9, $t9, 1	# j++
	addi	$t0, $t0, 1	# i++
	j	count_output

restart:
	li	$t0, 0		# gan lai i = 0
	sub	$t9, $t9, 1	# j -= 1 vi so dau phay luon it hon output 1 cai
	j	check
	
dauphay:
	li	$v0, 4
	la	$a0, Message2
	syscall
	sub	$t9, $t9, 1	# j--
	
check:
	beq	$t0, $s0, exit		# neu i = N thi dung chuong trinh
	div	$t0, $t1		# i / 3
	mfhi	$t3			# $t3 la so du cua phep chia tren
	beq	$t3, 0, print		# $t3 = 0 nghia la 3|i => in ra ket qua
	div	$t0, $t2		# i / 5
	mfhi	$t4			# $t4 la so du cua phep chia tren
	beq	$t4, 0, print 		# $t4 = 0 nghia la 5|i => in ra ket qua
	addi	$t0, $t0, 1		# i++
	j	check

print:
	li	$v0, 1
	move	$a0, $t0
	syscall

update:
	addi	$t0, $t0, 1	# i++
	beq	$t9, 0, check
	j	dauphay
	
error:
	li	$v0, 4
	la	$a0, Error
	syscall
	j	input

exit:
	li	$v0, 10
	syscall
 	
