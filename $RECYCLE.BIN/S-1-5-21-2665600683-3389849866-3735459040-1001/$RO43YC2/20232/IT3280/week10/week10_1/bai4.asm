.eqv MONITOR_SCREEN 0x10010000
.eqv RED            0x00FF0000
.eqv YELLOW         0x00FFFF00
.text
	li 	$k0, MONITOR_SCREEN
	addi 	$k1, $k0, 256		# co 64 o => phai co 4 * 64 = 256 lan nhay
	addi 	$a0, $zero, 0

LOOP:
	beq 	$k0, $k1, END
	beq 	$a0, 4, REVERSE		# $a0 = 4 thi xuong hang duoi		
	li 	$t0, YELLOW
	sw  	$t0, 0($k0)
	li 	$t0, RED
	sw  	$t0, 4($k0)	# cach mot o mau vang la mot o mau do
	addi 	$a0, $a0, 1	# $a0++
	addi 	$k0, $k0, 8	# $k0 +=8 de to hai o tiep theo
	j 	LOOP

REVERSE:
	# xuong hang duoi va dao nguoc mau so voi cac hang ben tren (vang -> do, do -> vang)
	beq 	$k0, $k1, END
	beqz 	$a0, LOOP	# $a0 = 0 thi xuong hang duoi
	li 	$t0, RED
	sw  	$t0, 0($k0)
	li 	$t0, YELLOW
	sw  	$t0, 4($k0)
	addi 	$a0, $a0, -1    # $a0--
	addi 	$k0, $k0, 8	 # $k0 +=8 de to hai o tiep theo
	j 	REVERSE
	
END:
	# ket thuc chuong trinh
	li 	$v0, 10
	syscall