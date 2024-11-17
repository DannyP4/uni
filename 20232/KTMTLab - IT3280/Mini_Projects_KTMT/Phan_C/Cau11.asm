.data 
	String: 	.space 256
	Message: 	.asciiz "Nhap vao xau ky tu: "
	Message1: 	.asciiz "Xau sau khi dao nguoc cac tu la: "
	Space:		.asciiz " "
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

PrintMessage:
	li	$v0, 4
	la	$a0, Message1
	syscall
			
init:
	addi	$t8, $t8, 0	# $t8 = i = 0
	la 	$a1, String	# address of String[0]
	add	$a2, $a1, $t9	# address of String[n]
	addi	$a2, $a2, 3	# address of new String (String2)
	addi	$a3, $a2, 0	# $a3 = $a2
	sub	$t9, $t9, 1	# length = $t9 - 1 vi khong tinh ky tu '\n'
	j 	Check

PrintSpace:
	li	$v0, 4
	la	$a0, Space
	syscall

Check:
	beq	$t8, $t9, Reverse	# kiem tra xem da kiem tra het String chua, het roi thi dung
	lb	$t0, 0($a1)		# lay ra ky tu dang tro toi
	beq	$t0, 32, Reverse
	sb	$t0, 0($a2)		# luu ky tu vao mang String2
	addi	$a2, $a2, 1 		# tang dia tri cua $a2 di 1
	addi	$a1, $a1, 1		# $a1++ tro den dia chi tiep theo
	addi	$t8, $t8, 1		# i++
	j 	Check	

Reverse:
	addi	$a1, $a1, 1		# $a1++ tro den dia chi tiep theo
	addi	$t8, $t8, 1		# i++
	sub	$a2, $a2, 1		# giam dia tri cua $a2 di 1
	bgt	$t8, $t9, ResersePrint2	# neu da xet den tu cuoi cung thi in ra dao nguoc tu do va ket thuc
	j 	ResersePrint	
	
ResersePrint:
	# in ra ket qua:
	li	$v0, 11
	lb	$a0, 0($a2)
	syscall
	
	beq	$a2, $a3, PrintSpace
	sub	$a2, $a2, 1
	j 	ResersePrint
	
ResersePrint2:
	# in ra ket qua khi da xet den tu cuoi cung:
	li	$v0, 11
	lb	$a0, 0($a2)
	syscall
	
	beq	$a2, $a3, exit
	sub	$a2, $a2, 1
	j 	ResersePrint2

	