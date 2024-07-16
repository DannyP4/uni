.data
	String:		.space 256
	Message: 	.asciiz "Nhap vao xau ky tu: "
	inHoa:		.asciiz "So ky tu in hoa la: "
	inThuong:	.asciiz "So ky tu in thuong la: "
	chuSo:		.asciiz "So chu so la: "
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
	li	$s0, 0		# $s0 dem ky tu in hoa
	li	$s1, 0		# $s1 dem ky tu in thuong
	li	$s2, 0		# $s2 dem chu so

check:
	beq	$t8, $t9, print		# kiem tra xem da kiem tra het String chua, het roi thi in ket qua
	lb	$t0, 0($a1)	
	
	# kiem tra in hoa
	slti	$s3, $t0, 91
	sgtu	$s4, $t0, 64
	add	$s5, $s3, $s4
	beq	$s5, 2, in_hoa
	
	# kiem tra in thuong
	slti	$s3, $t0, 123
	sgtu	$s4, $t0, 96
	add	$s5, $s3, $s4
	beq	$s5, 2, in_thuong
	
	# kiem tra chu so
	slti	$s3, $t0, 58
	sgtu	$s4, $t0, 47
	add	$s5, $s3, $s4
	beq	$s5, 2, chu_so
	
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check
	
in_hoa:
	addi	$s0, $s0, 1	# tang bien dem ky tu in hoa len 1
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check

in_thuong:
	addi	$s1, $s1, 1	# tang bien dem ky tu in hoa len 1
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check

chu_so:
	addi	$s2, $s2, 1	# tang bien dem ky tu in hoa len 1
	addi	$a1, $a1, 1	# dia chi cua ky tu tiep theo trong chuoi
	addi	$t8, $t8, 1	# i++
	j	check

print:
	# in ra ket qua:
	li	$v0, 4
	la	$a0, inHoa
	syscall
	
	li	$v0, 1
	move	$a0, $s0
	syscall
	
	li	$v0, 4
	la	$a0, Space
	syscall
	
	li	$v0, 4
	la	$a0, inThuong
	syscall
	
	li	$v0, 1
	move	$a0, $s1
	syscall
	
	li	$v0, 4
	la	$a0, Space
	syscall
	
	li	$v0, 4
	la	$a0, chuSo
	syscall
	
	li	$v0, 1
	move	$a0, $s2
	syscall

exit:
	li	$v0, 10
	syscall