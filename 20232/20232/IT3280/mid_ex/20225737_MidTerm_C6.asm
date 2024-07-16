.data
	String: 		.space 100
	Message1: 		.asciiz "Nhap xau: "
	Message2: 		.asciiz "Nhap ky tu: "
	Message3: 		.asciiz "\nSo lan ky tu nay xuat hien trong xau la: "

.text
input:
	# nhap xau: 
	li	$v0, 4
	la	$a0, Message1
	syscall
	
	li 	$v0, 8
	li	$a1, 100
	syscall 
	
	li	$v0, 4
	la	$a0, Message2
	syscall 
	
	# nhap ky tu:
	li 	$v0, 12
	syscall 
	
	move	$s1, $v0 	# luu ky tu vao $s1
	
set: 
	li 	$s2, 0 		# $s2 = bien dem = count
	li 	$t2, 10 	# \n
	la 	$t0, String	# dia chi cua String[0]
	
check:
	# kiem tra neu ky tu in thuong
	slti	$s3, $s1, 123
	sgtu	$s4, $s1, 96
	add	$s5, $s3, $s4
	beq	$s5, 2, compare1
	# kiem tra neu ky tu in hoa 
	slti	$s3, $s1, 91
	sgtu	$s4, $s1, 64
	add	$s5, $s3, $s4
	beq	$s5, 2, compare2
	
compare1: 
	# lay tung ky tu cua xau de so sanh neu C in thuong
	lb 	$s0, 0($t0)		# lay ky tu String[i]
	beq 	$s0, $t2, print 	# duyet het xau thi in ket qua
	add 	$t0, $t0, 1		# tang dia chi len 1
	beq 	$s0, $s1, update1	# neu String[i] = C thi update count
	sub 	$s3, $s1, 32		# $s3 = $s1 - 32 = ky tu C o dang in hoa
	beq 	$s0, $s3, update1	# neu String[i] = C thi update count
	j 	compare1
	
compare2: 
	# lay tung ky tu cua xau de so sanh neu C in hoa
	lb 	$s0, 0($t0)		# lay ky tu String[i]
	beq 	$s0, $t2, print	 	# duyet het xau thi in ket qua
	add 	$t0, $t0, 1		# tang dia chi len 1
	beq 	$s0, $s1, update2	# neu String[i] = C thi update count
	addi 	$s3, $s1, 32		# $s3 = $s1 + 32 = ky tu C o dang in thuong
	beq 	$s0, $s3, update2	# neu String[i] = C thi update count
	j 	compare2
	
update1:
	add 	$s2, $s2, 1	# count++
	j 	compare1
	
update2:  
	add 	$s2, $s2, 1	# count++
	j 	compare2 
	
print: 
	# in ket qua:
	li 	$v0, 4
	la 	$a0, Message3
	syscall
	
	li 	$v0, 1
	addi 	$a0, $s2, 0
	syscall

end:
	li	$v0, 10
	syscall
	
