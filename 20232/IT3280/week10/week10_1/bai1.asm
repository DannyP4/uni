.eqv 	SEVENSEG_RIGHT   0xFFFF0010
.eqv 	SEVENSEG_LEFT   0xFFFF0011
.textmain:
	li    	$a0,  79	# hien thi so 3
	jal   	SHOW_7SEG_LEFT
	li    	$a0,  7		# hien thi so 7
	jal   	SHOW_7SEG_RIGHT
	
exit:     
	li    $v0, 10		# ket thuc chuong trinh
	syscall
	
endmain:
SHOW_7SEG_LEFT:  
	li   	$t0,  SEVENSEG_LEFT
	sb   	$a0,  0($t0)
	jr   	$ra
	
SHOW_7SEG_RIGHT: 
	li   	$t0,  SEVENSEG_RIGHT
	sb   	$a0,  0($t0)
	jr   	$ra 