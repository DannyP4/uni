.eqv HEADING 0xffff8010 # Integer: An angle between 0 and 359
.eqv MOVING 0xffff8050 # Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # Boolean (0 or non-0):
.eqv KEY_CODE 0xFFFF0004
.eqv KEY_READY 0xFFFF0000
.eqv DISPLAY_CODE 0xFFFF000C
.eqv DISPLAY_READY 0xFFFF0008
.text
main:
	li 	$k0, KEY_CODE
	li 	$k1, KEY_READY
	li 	$s0, DISPLAY_CODE
	li 	$s1, DISPLAY_READY

loop: 
WaitForKey:
	lw 	$t1, 0($k1) 			# $t1 = [$k1] = KEY_READY
	beq 	$t1, $zero, WaitForKey 	# if $t1 == 0 then Polling

ReadKey:
	lw 	$t0, 0($k0) 		# $t0 = [$k0] = KEY_CODE

WaitForDis:
	lw 	$t2, 0($s1) 			# $t2 = [$s1] = DISPLAY_READY
	beq 	$t2, $zero, WaitForDis 	# if $t2 == 0 then Polling

Check:
	beq 	$t0, 32, Start 		# show key #W87 w119 A65 a97 S83 s115 D67 d100

space32:
	beq 	$t0, 87, goTop
	beq 	$t0, 119, goTop
	beq 	$t0, 83, goDown
	beq 	$t0, 115, goDown
	beq 	$t0, 67, goRight
	beq 	$t0, 100, goRight
	beq 	$t0, 65, goLeft
	beq 	$t0, 97, goLeft
	j 	loop

Start:
	bnez 	$t3, Exit
	addi 	$t3, $t3, 1
	jal 	GO
	jal 	TRACK
	j 	loop

goTop:
	addi 	$a0, $zero, 0
	jal 	ROTATE
	addi 	$v0, $zero, 32
	li 	$a0, 1000
	syscall
	jal 	UNTRACK
	jal 	TRACK
	j 	loop

goDown:
	addi 	$a0, $zero, 180
	jal	ROTATE
	addi 	$v0, $zero, 32
	li 	$a0, 1000
	syscall
	jal 	UNTRACK
	jal 	TRACK
	j 	loop

goRight:
	addi 	$a0, $zero, 90
	jal 	ROTATE
	addi 	$v0, $zero, 32
	li 	$a0, 1000
	syscall
	jal 	UNTRACK
	jal 	TRACK
	j 	loop

goLeft:
	addi 	$a0, $zero, 270
	jal 	ROTATE
	addi 	$v0, $zero, 32
	li 	$a0, 1000
	syscall
	jal 	UNTRACK
	jal 	TRACK
	j 	loop	

Exit:
	jal 	STOP
	li 	$v0, 10
	syscall

GO:
	li 	$at, MOVING
	addi 	$v1, $zero,1
	sb 	$v1, 0($at)
	jr 	$ra

STOP:
	li 	$at, MOVING 	# change MOVING port to 0
	sb 	$zero, 0($at) 	# to stop
	jr 	$ra

TRACK:
	li 	$at, LEAVETRACK 	# change LEAVETRACK port
	addi 	$v1, $zero,1 		# to logic 1,
	sb 	$v1, 0($at) 		# to start tracking
	jr 	$ra

UNTRACK:
	li 	$at, LEAVETRACK 	# change LEAVETRACK port to 0
	sb 	$zero, 0($at) 		# to stop drawing tail
	jr 	$ra

ROTATE:
	li 	$at, HEADING 		# change HEADING port
	sw 	$a0, 0($at) 		# to rotate robot
	jr 	$ra