.data
	inputN:		.asciiz "Nhap so N: "
	Message:	.asciiz "Luy thua cua 2 lon nhat nho hon N la: "
	Error:		.asciiz "N phai lon hon 1, vui long nhap lai N: "
	
.text
input:
	# Nhap so N:
	li	$v0, 4
	la	$a0, inputN
	syscall
	
	li	$v0, 5
	syscall
	
	move	$s0, $v0	# luu N vao $s0 ($s0 = N)
	blt 	$s0, 2, error	# neu N < 2 thi error

init:
	li	$t0, 1		# gan so luy thua 2 lon nhat = 1 = $t0	 = max
	li	$t1, 2	
			
check:
	slt	$t9, $t0, $s0		# neu max >= N => update
	beqz	$t9, update			
	mul	$t0, $t0, $t1		# max = max * 2
	j	check
	
update:
	div	$t0, $t0, 2
	
print:
	li	$v0, 4
	la	$a0, Message
	syscall
	
	li	$v0, 1
	move	$a0, $t0
	syscall
	j 	exit
error:
	li	$v0, 4
	la	$a0, Error
	syscall
	j	input

exit:
	li	$v0, 10
	syscall