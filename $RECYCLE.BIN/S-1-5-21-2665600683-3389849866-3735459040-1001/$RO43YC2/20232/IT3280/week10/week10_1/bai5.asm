.eqv MONITOR_SCREEN 	0x10010000
.eqv RED 		0x00FF0000
.eqv GREEN 		0x0000FF00
.data
	Message_x1: 	.asciiz "Nhap vao x1: "
	Message_y1: 	.asciiz "Nhap vao y1: "
	Message_x2: 	.asciiz "Nhap vao x2: "
	Message_y2: 	.asciiz "Nhap vao y2: "

.text
	# nhap cac gia tri x1, y1, x2, y2
	li 	$v0, 4
	la 	$a0, Message_x1
	syscall

	li 	$v0, 5
	syscall
	move 	$t1, $v0	# gan $t1 = x1
	
	li 	$v0, 4
	la 	$a0, Message_y1
	syscall
	
	li 	$v0, 5
	syscall
	move 	$s1, $v0	# gan $s1 = y1

	li 	$v0, 4
	la 	$a0, Message_x2
	syscall
	
	li 	$v0, 5
	syscall
	move 	$t2, $v0	# gan $t2 = x2
	
	li 	$v0, 4
	la 	$a0, Message_y2
	syscall
	
	li 	$v0, 5
	syscall
	move 	$s2, $v0	# gan $s2 = y2

MONITOR:
	# chinh sua cac gia tri
	li 	$k0, MONITOR_SCREEN
	li 	$t0, RED
	addi 	$v0, $zero, 0
	addi 	$t3, $t1, -1	# x1--
	addi 	$s3, $s1, -1	# y1--
	addi 	$t4, $t2, 1	# x2++
	addi 	$s4, $s2, 1	# y2++

# to mau hinh chu nhat
BORDER:
	mul 	$k1, $s4, 8
	add 	$k1, $k1, $t4
	mul 	$k1, $k1, 4
	add 	$k1, $k1, $k0
	# goc phai ben duoi

LOOP:
	mul 	$a0, $s3, 8
	add 	$a0, $a0, $t3
	mul 	$a0, $a0, 4
	add 	$a0, $a0, $k0
	# goc trai ben tren
	beq 	$a0, $k1, RESET_BORDER	# $a0 = $k1 thi ve duong vien
	beq 	$t3, $t4, RESET		# x1 = x2 thi reset de ve tiep hinh chu nhat
	sw 	$t0, 0($a0)		# to mau do
	addi 	$t3, $t3, 1
	j 	LOOP

RESET:
	addi 	$t3, $t1, -1		# reset lai x1 ve lai tu dau
	add 	$t3, $t3, $v1
	addi 	$s3, $s3, 1		# tang y1 len 1 de xuong dong
	j 	LOOP

# to mau vien
RESET_BORDER:
	bnez 	$v1, EXIT
	addi 	$v1, $v1, 1	# tang $v1 len 1 den ket thuc chuong trinh voi lenh bnez o tren
	li 	$t0, GREEN
	addi 	$t3, $t1, 0
	addi 	$s3, $s1, 0
	addi 	$t4, $t2, 0
	addi 	$s4, $s2, 0
	j 	BORDER

EXIT:
	# ket thuc chuong trinh
	li 	$v0, 10
	syscall