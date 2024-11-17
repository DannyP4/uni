.data
	A: 		.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "Phan tu am lon nhat la: "
	Message4:	.asciiz "\nVi tri cua phan tu am lon nhat la vi tri thu "
	Message3: 	.asciiz "Khong co phan tu am lon nhat!"
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0
	blt 	$s0, 1, PrintEror
	la 	$a1, A
	j 	input_array
	
exit:
	li 	$v0, 10
	syscall
	
input_array:
	beq 	$t2, $s0, Check
	add 	$t0, $a1, $t1
	li 	$v0, 4
	la 	$a0, Message1
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0
	sw 	$s1, 0($t0)
	addi 	$t2, $t2, 1
	mul 	$t1, $t2, 4
	j 	input_array
	
Check:
	li 	$s1, 0x80000000		# $s1 = so am be nhat
	li 	$t0, 0			# $t0 = i = 0
	
loop:
	beq 	$t0, $s0, PrintResult	# i = N => Print
	lw 	$t1, 0($a1)		# $t1 = A[i]
	bgt  	$t1, 0, continue	# $t1 > 0 => Lap lai
	bgt	$t1, $s1, Update	# tim so am lon nhat	
	
continue:
	addi 	$t0, $t0, 1		# i++
	addi 	$a1 $a1, 4	
	j 	loop
	
Update:
	addi 	$s1, $t1, 0		# luu gia tri
	addi 	$s2, $t0, 0		# luu vi tri
	j 	continue
	
PrintResult:
	beq 	$s1, 0x80000000, Print 	# neu $s1 khong doi => Khong co phan tu am lon nhat
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
	li 	$v0, 1
	addi 	$a0, $s1, 0
	syscall
	
	li	$v0, 4
	la	$a0, Message4
	syscall
	
	li	$v0, 1
	addi	$a0, $s2, 1
	syscall
	
	j 	exit
	
Print:
	li 	$v0, 4
	la 	$a0, Message3
	syscall
	j 	exit
	
PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	j 	main
