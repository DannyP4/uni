.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014

.text
main: 
	li 	$t1, IN_ADDRESS_HEXA_KEYBOARD
 	li 	$t2, OUT_ADDRESS_HEXA_KEYBOARD
 	addi 	$s1, $zero, 0

start:
	li 	$t3, 0x01 # check row 1
	addi 	$t0, $zero, 0
	addi 	$s0, $zero, 1

polling: 
	sb 	$t3, 0($t1 ) # must reassign expected row
 	lb 	$a0, 0($t2) # read scan code of key button
 	bnez 	$a0, print
 	addi 	$t0, $t0, 1
 	sllv 	$t3, $s0, $t0
 	bgt 	$t3, 8, start
 	j 	polling

print: 
	beq 	$a0, $s1, sleep
 	li 	$v0, 34 # print integer (hexa)
	syscall
	add 	$s1, $zero, $a0
	
sleep: 
 	li 	$a0, 100 # sleep 100ms
 	li 	$v0, 32
	syscall
	
back_to_polling: 
	j 	start # continue polling

end:
	li 	$v0, 10
	syscall