.data 
	String: 	.space 256
	Message: 	.asciiz "Nhap vao xau ky tu: "
	Message1: 	.asciiz "Xau sau khi xu ly la: "

.text
	main:
	# Nhap sau:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	li 	$v0, 8
	la 	$a0, String
	li 	$a1, 256
	syscall
	
	la 	$a1, String	# address of String[0]
	j 	length
	
exit:
	li 	$v0, 10
	syscall
	
length:
	# kiem tra do dai String
	add 	$t9, $t9, 1		# $t9 = length
	lb 	$s0, 0($a1)
	addi	$a1, $a1, 1
	bne 	$s0, 10, length		# kiem tra neu ky tu do la '\n' thi ket thuc kiem tra
		
init:
	addi	$t8, $t8, 0	# $t8 = i = 0
	la 	$a1, String	# address of String[0]
	sub	$t9, $t9, 1	# length = $t9 - 1 vi khong tinh ky tu '\n'
	
Check:
	beq	$t8, $t9, init2		# kiem tra xem da kiem tra het String chua, het roi thi in ket qua
	lb	$t0, 0($a1)
	
	# neu ky tu khong phai chu cai thi bo qua
	blt	$t0, 65, Continue
	bgt	$t0, 122, Continue	
	slti 	$s7, $t0, 97
	sgtu 	$s6, $t0, 91
	add	$s5, $s6, $s7
	beq	$s5, 2, Continue
	
	# xet in hoa, in thuong:
	blt	$t0, 91, MakeLowerCase	# neu ky tu in hoa => in thuong
	bgt	$t0, 96, MakeUpperCase	# neu ky tu in thuong => in hoa

MakeLowerCase:
	addi	$t0, $t0, 32	# in thuong ky tu
	sb	$t0, 0($a1)	# save lai vao String
	j	Continue
		
MakeUpperCase:
	addi	$t0, $t0, -32	# in hoa ky tu
	sb	$t0, 0($a1)	# save lai vao String

Continue:
	addi	$t8, $t8, 1	# i++
	addi	$a1, $a1, 1	# dia chi cua String[i + 1]
	j	Check

init2:
	la	$a1, String
	
Print:
	# in ra ket qua:
	li	$v0, 4
	la	$a0, Message1
	syscall

PrintResult:
	beq	$t9, 0, exit
	
	lb	$t7, 0($a1)
	li	$v0, 11
	move	$a0, $t7
	syscall
	
	sub	$t9, $t9, 1
	addi	$a1, $a1, 1
	j 	PrintResult
