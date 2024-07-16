.data
	Message: 	.asciiz "Nhap vao 1 so nguyen duong N: "
	Message1: 	.asciiz "Tong cac chu so le cua N la: "
	Message2: 	.asciiz "Tong cac chu so chan cua N la: "
	Eror: 		.asciiz "So nhap vao phai lon hon 0!\n"
	Eror1: 		.asciiz "So nhap vao phai co it nhat 2 chu so!\n"
	Space:		.asciiz "\n"
	
.text	
	li	$t0, 10		# Gan 10 cho $t0
	li	$t3, 2		# Gan 2 cho $t3
	li	$a2, 0		# Tong cac so chan la $a2
	li	$a3, 0		# Tong cac so le la $a3
Input:
	li	$v0, 4
	la	$a0, Message
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0		# Luu N vao $s0
	bltz $s0, PrintEror		# N < 0 => Error
	blt $s0, $t0, PrintEror2	# N co it hon hai chu so

main:
	beq	$s0, 0, PrintResult	# Ket thuc main va in ket qua
	div	$s0, $t0		# Chia N cho 10
	mfhi	$t1			# So du cua phep chia N cho 10
	mflo	$t2			# Thuong cua phep chia N cho 10
	addi	$s0, $t2, 0		# Cap nhat gia tri moi cho N
	
	# Kiem tra so chan so le:
	div	$t1, $t3	# Chia $t1 cho 2
	mfhi	$t4		# Lay thuong cua phep chia tren de kiem tra odd - even
	beq 	$t4, 0, even	# So du la 0 thi $t1 la so chan
	beq 	$t4, 1, odd	# So du la 0 thi $t1 la so le

even:
	add 	$a2, $a2, $t1	# sum_even += $t4
	j	main				
	
odd:
	add 	$a3, $a3, $t1	# sum_odd += $t4
	j	main		

PrintEror:
	# Error neu N < 0
	li $v0, 4
	la $a0, Eror
	syscall
	
	# Quay lai nhap N
	j Input
	
PrintEror2:
	# Error neu N it hon hai chu so
	li 	$v0, 4
	la 	$a0, Eror1
	syscall
	
	# Quay lai nhap N
	j Input
	
PrintResult:
	# Tong cac chu so le:
	li	$v0, 4
	la	$a0, Message1
	syscall
	
	li	$v0, 1
	move	$a0, $a3
	syscall
	
	# Xuong dong:
	li	$v0, 4
	la	$a0, Space
	syscall
	
	# Tong cac chu so chan:
	li	$v0, 4
	la	$a0, Message2
	syscall
	
	li	$v0, 1
	move	$a0, $a2
	syscall

End:
	li	$v0, 10
	syscall
	
