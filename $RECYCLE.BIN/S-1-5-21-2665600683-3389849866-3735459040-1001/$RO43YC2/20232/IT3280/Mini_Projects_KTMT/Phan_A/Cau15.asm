.data
	Minput:		.asciiz "Nhap so M: "
	Ninput:		.asciiz "Nhap so N: "
	Message:	.asciiz "Uoc so chung lon nhat cua M va N la: "
	
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
	j	gcd

swap:
	add	$t8, $t8, $s0	# $t8 = M
	addi	$s0, $s1, 0	# M = N
	addi	$s1, $t8, 0	# N = $t8 

gcd:
	li	$t0, 1		# $t0 = i = 1
	addi	$s2, $s0, 1	# $s2 = M + 1 de co the kiem tra tu 1 den M
	
loop:
	beq	$t0, $s2, Print		# i = M + 1 => in ket qua
	div	$s0, $t0		# $s0 / $t0
	mfhi	$t9			# so du cua phep chia tren
	div	$s1, $t0		# $s0 / $t0
	mfhi	$t8			# so du cua phep chia tren
	add	$t1, $t9, $t8		# $t1 = tong hai so du 
	beq	$t1, 0, update		# $t1 = 0 tuc la ca M va N deu chia het cho i, thi update
	addi	$t0, $t0, 1		# i++
	j 	loop

update:
	move	$t2, $t0	# $t2 = uoc chung lon nhat hien tai
	addi	$t0, $t0, 1
	j	loop

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