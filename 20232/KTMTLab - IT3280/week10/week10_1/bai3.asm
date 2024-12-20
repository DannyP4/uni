.eqv SEVENSEG_LEFT  	0xFFFF0010
.eqv SEVENSEG_RIGHT   	0xFFFF0011
.data
	Message: 	.asciiz "Nhap ky tu: "
	
.text
main:
	# nhap vao mot ky tu tu ban phim:
	li 	$v0, 4
	la 	$a0, Message
	syscall

	li 	$v0, 12
	syscall
	
	div 	$v0, $v0, 10
	mfhi 	$a0
	jal 	CHECK
	jal   	SHOW_7SEG_LEFT
	div 	$v0, $v0, 10
	mfhi 	$a0
	jal 	CHECK
	jal	SHOW_7SEG_RIGHT
	
exit:     
	# ket thuc chuong trinh
	li    	$v0, 10
	syscall

endmain:
CHECK:
	# kiem tra xem gia tri cua so la bao nhieu:
	beq 	$a0, 0, v0
	beq 	$a0, 1, v1
	beq 	$a0, 2, v2
	beq 	$a0, 3, v3
	beq 	$a0, 4, v4
	beq 	$a0, 5, v5
	beq 	$a0, 6, v6
	beq 	$a0, 7, v7
	beq 	$a0, 8, v8
	beq 	$a0, 9, v9

	# neu la cac so (tu 0 den 9) thi sau do hien thi tren led 7 thanh:
v0: 
	addi 	$a0, $zero, 63
	jr 	$ra

v1: 
	addi 	$a0, $zero, 6
	jr 	$ra

v2: 
	addi 	$a0, $zero, 91
	jr 	$ra

v3: 
	addi 	$a0, $zero, 79
	jr 	$ra

v4: 
	addi 	$a0, $zero 102
	jr 	$ra

v5: 
	addi 	$a0, $zero, 109
	jr 	$ra

v6: 
	addi 	$a0, $zero, 125
	jr 	$ra

v7: 
	addi 	$a0, $zero, 7
	jr 	$ra

v8: 
	addi 	$a0, $zero, 127
	jr 	$ra

v9: 
	addi 	$a0, $zero, 111
	jr 	$ra

SHOW_7SEG_LEFT:  
	li   	$t0,  SEVENSEG_LEFT
	sb   	$a0,  0($t0)
	jr   	$ra

SHOW_7SEG_RIGHT: 
	li   	$t0,  SEVENSEG_RIGHT
	sb   	$a0,  0($t0)
	jr   	$ra 
