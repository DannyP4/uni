.data
	String:		.space 256
	Message: 	.asciiz "Nhap vao xau ky tu: "
	Output:		.asciiz "So nguyen am trong cau la: "
	Space:		.asciiz "\n"

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

length:
	# kiem tra do dai String
	add 	$t9, $t9, 1		# $t9 = length
	lb 	$s0, 0($a1)
	addi	$a1, $a1, 1
	bne 	$s0, 10, length		# kiem tra neu ky tu do la '\n' thi ket thuc kiem tra

init:
	addi	$t8, $t8, 0	# $t8 = i = 0
	la 	$a1, String	# address of String[0]
	sub	$t9, $t9, 1	# length = $t9 - 1 vi khong tinh ky tu '\n' o cuoi
	li	$s0, 0		# $s0 = count = 0
	
check:
	beq	$t8, $t9, print		# kiem tra xem da kiem tra het String chua, het roi thi in ket qua
	lb	$t0, 0($a1)	
	
	# kiem tra nguyen am:
	# kiem tra 'a'
	beq	$t0, 97, update
	beq	$t0, 65, update
	
	# kiem tra 'i'
	beq	$t0, 105, update
	beq	$t0, 73, update
	
	# kiem tra 'u'
	beq	$t0, 117, update
	beq	$t0, 85, update
	
	# kiem tra 'e'
	beq	$t0, 101, update
	beq	$t0, 69, update
	
	# kiem tra 'o'
	beq	$t0, 111, update
	beq	$t0, 79, update
	
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check

update:
	addi	$s0, $s0, 1	# count++
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j 	check
	
print:
	# in ra ket qua:
	li	$v0, 4
	la	$a0, Output
	syscall
	
	li	$v0, 1
	move	$a0, $s0
	syscall

exit:
	li	$v0, 10
	syscall