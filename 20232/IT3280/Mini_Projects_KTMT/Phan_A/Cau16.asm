.data
	Minput:		.asciiz "Nhap so M: "
	Ninput:		.asciiz "Nhap so N: "
	Message:	.asciiz "Boi so chung nho nhat cua M va N la: "
	
.text
input:
	# Nhap M:
	li	$v0, 4
	la	$a0, Minput
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0	# $s0 = M
	
	# Nhap N:
	li	$v0, 4
	la	$a0, Ninput
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s1, $v0	# $s1 = N

compare:
	# so sanh M va N, neu M > N thi swap de cho M < N
	sub	$t9, $s0, $s1	# $t9 = M - N
	bgez	$t9, swap	# $t9 > 0 = > swap
	j	lcm

swap:
	add	$t8, $t8, $s0	# $t8 = M
	addi	$s0, $s1, 0	# M = N
	addi	$s1, $t8, 0	# N = $t8 

lcm:
	add	$t0, $t0, $s1		# $t0 = i = N
	
loop:
	div	$t0, $s0		# $t0 / $s0
	mfhi	$t9			# so du cua phep chia tren
	div	$t0, $s1		# $t0 / $s1
	mfhi	$t8			# so du cua phep chia tren
	add	$t1, $t9, $t8		# $t1 = tong hai so du 
	beq	$t1, 0, update		# $t1 = 0 tuc la ca M va N deu chia het cho i, thi update
	addi	$t0, $t0, 1		# i++
	j 	loop

update:
	move	$t2, $t0	# $t2 = uoc chung lon nhat hien tai
	addi	$t0, $t0, 1

Print:
	# in ra ket qua:
	li	$v0, 4
	la	$a0, Message
	syscall
	
	li	$v0, 1
	move	$a0, $t2
	syscall
	
	# exit
	li	$v0, 10
	syscall
	