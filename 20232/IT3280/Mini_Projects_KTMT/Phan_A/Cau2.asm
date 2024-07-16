.data
	msg1:	.asciiz "Nhap so N: "
	msg2: 	.asciiz "Day so Fibonacci nho hon N la: "
	msg3: 	.asciiz "N phai la mot so lon hon 0!"
	space:	.asciiz ", "

.text
	li	$s0, 0		# F(0) = 0
	li	$s1, 1		# F(1) = 1
Input:
	li	$v0, 4
	la	$a0, msg1
	syscall
	
	li	$v0, 5		# Nhap N
	syscall
	
	blez 	$v0, Error	# Kiem tra xem N > 0 hay khong
	
	move	$a1, $v0	# Cho N vao thanh $a1
	j	Msg2

Error:
	li	$v0, 4
	la	$a0, msg3
	syscall
	j	Exit

Case1:
	li	$v0, 1
	li	$a0, 0
	syscall 
	j 	Exit	

Exit:
	li	$v0, 10		# Out
	syscall

Msg2:
	li	$v0, 4
	la	$a0, msg2
	syscall

	beq 	$a1, 1, Case1	# Neu N bang 1 thi chi co F(0) thoa man
	
	# In them F(0) = 0 va F(1) = 1
	li	$v0, 1
	li	$a0, 0
	syscall 
	
	li	$v0, 4
	la	$a0, space
	syscall
	
	li	$v0, 1
	li	$a0, 1
	syscall 
Fibo:	
	add	$s2, $s1, $s0	# F(2) = F(1) + F(0)
	move	$s0, $s1	# F(0) = F(1)
	move	$s1, $s2	# F(1) = F(2)
	# Lam nhu vay de cap nhat cac so Fibonacci moi 
	slt	$t9, $s2, $a1	# Neu F(hien tai) < N thi loop 
	beqz 	$t9, Exit
	j	Print
			
Print:
	# In ra output
	li	$v0, 4
	la	$a0, space
	syscall
	
	li	$v0, 1
	addi	$a0, $s2, 0
	syscall
	
	j 	Fibo
	
	
