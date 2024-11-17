.data
	String1: 	.space 256
	String2: 	.space 256
	Message: 	.asciiz "Nhap vao xau ky tu 1: "
	Message1: 	.asciiz "Nhap vao xau ky tu 2: "
	Message2: 	.asciiz "2 xau giong nhau"
	Message3: 	.asciiz "2 xau khong giong nhau"
	
.text
main:
	# Nhap sau s1:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	li 	$v0, 8
	la 	$a0, String1
	li 	$a1, 256
	syscall
	
	# Nhap sau s2:
	li 	$v0, 4
	la 	$a0, Message1
	syscall
	
	li 	$v0, 8
	la 	$a0, String2
	li 	$a1, 256
	syscall
	
	la 	$a0, String1	# $a0 = address of String1[0]
	la 	$a1, String2	# $a1 = address of String2[0]
	j 	Compare
	
exit:
	li 	$v0, 10
	syscall
	
Compare:
	li 	$t2, 10   	# \n
	li	$t9, 0		# $t9 la do dai String1
	li	$t8, 0		# $t8 la do dai String2

length1:
	# kiem tra do dai String1
	add 	$t9, $t9, 1		
	lb 	$s0, 0($a0)
	addi	$a0, $a0, 1
	bne 	$s0, $t2, length1

length2:
	# kiem tra do dai String2
	add 	$t8, $t8, 1
	lb 	$s1, 0($a1)
	addi	$a1, $a1, 1
	bne 	$s1, $t2, length2

Check1:
	sub	$t7, $t8, $t9		# xet hieu do dai hai mang
	bnez	$t7, PrintNotSame	# neu do dai hai mang khong bang nhau => khong giong nhau
	li	$t6, 0			# $t6 = i = 0
	
	sub	$t8, $t8, 1		# $t8 = $t8 - 1 vi khong tinh ki tu xuong dong
	la 	$a0, String1		# $a0 = address of String1[0]
	la 	$a1, String2		# $a1 = address of String2[0] 
		
Check2:
	beq	$t6, $t8, PrintResult
	lb 	$v0, 0($a0)		# $v0 = String1[i]
	lb 	$v1, 0($a1)		# $v1 = String2[i]
	sub 	$t0, $v0, $v1		# xet hieu cua cac ki tu trong hai string
	abs 	$t0, $t0		# lay tri tuyet doi cua hieu
	beqz 	$t0, skip		# neu hieu = 0 => skip
	beq 	$t0, 32, skip		# neu hieu = 32 => skip (hieu cua in hoa va in thuong)
	j 	PrintNotSame
	
skip:
	addi 	$a0, $a0, 1		# tang dia chi cua string1 len 1 byte
	addi 	$a1, $a1, 1		# tang dia chi cua string2 len 1 byte
	addi	$t6, $t6, 1		# i++
	j 	Check2

PrintResult:
	# in ra ket qua
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
	j 	exit
	
PrintNotSame:
	li 	$v0, 4
	la 	$a0, Message3
	syscall
	j 	exit