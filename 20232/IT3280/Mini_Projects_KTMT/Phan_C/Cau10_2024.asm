.data
	String:		.space 256
	Message: 	.asciiz "Nhap vao xau ky tu: "
	Sum1:		.asciiz "Tong cac ky tu chu so la: "
	Sum2:		.asciiz "Tong gia tri ma ASCII cua ky tu chu cai la: "
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
	li	$s0, 0		# $s0 = count_num
	li	$s1, 0		# $s1 = count_character

check:
	beq	$t8, $t9, print		# kiem tra xem da kiem tra het String chua, het roi thi in ket qua
	lb	$t0, 0($a1)	
	
	# kiem tra chu cai: 
	# kiem tra in hoa
	slti	$s3, $t0, 91
	sgtu	$s4, $t0, 64
	add	$s5, $s3, $s4
	beq	$s5, 2, update_character
	
	# kiem tra in thuong
	slti	$s3, $t0, 123
	sgtu	$s4, $t0, 96
	add	$s5, $s3, $s4
	beq	$s5, 2, update_character
	
	# kiem tra chu so:
	slti	$s3, $t0, 58
	sgtu	$s4, $t0, 47
	add	$s5, $s3, $s4
	beq	$s5, 2, update_num
	
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check

update_num:
	sub	$t0, $t0, 48	# tru di 48 de lay gia tri nguyen goc
	add	$s0, $s0, $t0	# count_num = (chu so) + count_num
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check
	
update_character:
	add	$s1, $s1, $t0	# count_num = (ky tu) + count_num
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check

print:
	# in ra ket qua:
	li	$v0, 4
	la	$a0, Sum1
	syscall
	
	li	$v0, 1
	move	$a0, $s0
	syscall
	
	li	$v0, 4
	la	$a0, Space
	syscall
	
	li	$v0, 4
	la	$a0, Sum2
	syscall
	
	li	$v0, 1
	move	$a0, $s1
	syscall

exit:
	li	$v0, 10
	syscall