.data
	m: .asciiz "nhap so A: "
	m1: .asciiz "nhap so B: "
	m5: .asciiz "nhap so C: "
	m2: .asciiz "ABC la mot tam giac va la tam giac thuong"
	m3: .asciiz "ABC khong phai la mot tam giac"
	m4: .asciiz "ABC la mot tam giac vuong"
	m6: .asciiz "\n"
.text
main:
	li $v0, 4
	la $a0, m
	syscall
	li $v0, 5
	syscall
	add $t0, $zero, $v0
	li $v0, 4
	la $a0, m6
	syscall
	
	li $v0, 4
	la $a0, m1
	syscall
	li $v0, 5
	syscall
	add $t1, $zero, $v0
	li $v0, 4
	la $a0, m6
	syscall
	
	li $v0, 4
	la $a0, m5
	syscall
	li $v0, 5
	syscall
	add $t2, $zero, $v0
condition: # điều kiện để là tam giác và tam giác vuong VD A + B > C .....
	add $s0, $t0, $t1 
	add $s1, $t0, $t2
	add $s2, $t1, $t2
	blt $s0, $t2, unsatisfactory
	blt $s1, $t1, unsatisfactory
	blt $s2, $t3, unsatisfactory
	
	mul $t0, $t0, $t0
	mul $t1, $t1, $t1
	mul $t2, $t2, $t2
	
	add $s0, $t0, $t1 
	add $s1, $t0, $t2
	add $s2, $t1, $t2
	beq $s0, $t2, right_triangle
	beq $s1, $t1, right_triangle
	beq $s2, $t0, right_triangle
	j normal
right_triangle:
	li $v0, 4
	la $a0, m4
	syscall
	j end
normal:
	li $v0, 4
	la $a0, m2
	syscall
	j end
unsatisfactory:
	li $v0, 4
	la $a0, m3
	syscall
end:
	li $v0, 10
	syscall
	