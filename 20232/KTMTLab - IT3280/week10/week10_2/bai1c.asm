.eqv 	HEADING 0xffff8010 # Integer: An angle between 0 and 359
.eqv 	MOVING 0xffff8050 # Boolean: whether or not to move
.eqv 	LEAVETRACK 0xffff8020 # Boolean (0 or non-0):
.text
main:
	addi 	$a0, $zero, 90

running:
	jal 	ROTATE
	jal 	GO

sleep:
	addi 	$v0, $zero, 32
	li 	$a0, 10000
	syscall
	
goDown:
	addi 	$a0, $zero, 180
	jal 	ROTATE
	
sleep1:
	addi 	$v0, $zero, 32
	li 	$a0, 5000
	syscall
	jal 	TRACK

goASEW_1:
	addi 	$a0, $zero, 162
	jal 	ROTATE

sleep2:
	addi 	$v0, $zero, 32
	li 	$a0, 9000
	syscall
	jal 	UNTRACK
	jal 	TRACK

goASEW_2:
	addi 	$a0, $zero, 306
	jal 	ROTATE

sleep3:
	addi 	$v0, $zero, 32
	li 	$a0, 9000
	syscall
	jal 	UNTRACK
	jal 	TRACK

goRIGHT:
	addi 	$a0, $zero, 90
	jal 	ROTATE

sleep4:
	addi 	$v0, $zero, 32
	li 	$a0, 9000
	syscall
	jal 	UNTRACK
	jal 	TRACK

goASEW_3:
	addi 	$a0, $zero, 234
	jal 	ROTATE

sleep5:
	addi 	$v0, $zero, 32
	li 	$a0, 9000
	syscall
	jal 	UNTRACK
	jal 	TRACK

goASEW_4:
	addi 	$a0, $zero, 18
	jal 	ROTATE

sleep6:
	addi 	$v0, $zero, 32
	li 	$a0, 9000
	syscall
	jal 	UNTRACK

ESC:
	addi 	$a0, $zero, 270
	jal 	ROTATE

sleep7:
	addi 	$v0, $zero, 32
	li 	$a0, 5000
	syscall

end_main:
	jal 	STOP
	li 	$v0, 10
	syscall

GO:
	li 	$at, MOVING
	addi 	$k0, $zero,1
	sb 	$k0, 0($at)
	jr 	$ra

STOP:
	li 	$at, MOVING 	# change MOVING port to 0
	sb 	$zero, 0($at) 	# to stop
	jr 	$ra

TRACK:
	li 	$at, LEAVETRACK 	# change LEAVETRACK port
	addi 	$k0, $zero,1 		# to logic 1,
	sb 	$k0, 0($at) 		# to start tracking
	jr 	$ra

UNTRACK:
	li 	$at, LEAVETRACK # change LEAVETRACK port to 0
	sb 	$zero, 0($at) # to stop drawing tai	l
	jr 	$ra

ROTATE:
	li 	$at, HEADING # change HEADING port
	sw 	$a0, 0($at) # to rotate robot
	jr 	$ra