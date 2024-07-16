.data
	mes1: .asciiz "Nhap N: "
	mes2: .asciiz "Ket qua so chinh phuong lon nhat lon hon N: "
.text
	li $v0, 4 #In ra mes1
	la $a0, mes1
	syscall

	li $v0, 5 #Nhap so N vao t1
	syscall
	move $t1, $v0

	li $s0, 0 #Gan gia tri index =0

loop:
	mul $s1, $s0, $s0 #k = Index mu 2 la so can in ra
	slt $t9, $t1, $s1 #Neu k>N thi $t9 = 1 , k<= N thi t9 = 0
	bne $t9, $zero, endlp #Neu $t9 = 1 khac 0 thi ket thuc vong lap, duoc so k can tim
	addi $s0, $s0, 1 #Tang Index len 1 don vi
	j loop

endlp:
	li $v0, 4 #In mes 2
	la $a0, mes2
	syscall

	li $v0, 1 #In so k
	move $a0, $s1
	syscall

	li $v0, 10 #Ket thuc
	syscall 