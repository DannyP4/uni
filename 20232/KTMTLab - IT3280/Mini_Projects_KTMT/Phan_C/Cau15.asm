.data
	m: .asciiz "nhap xau A: "
	m2: .asciiz "nhap xau B"
	m3: .asciiz "Nhung chu so khong xuat hien trong A va B la: "
	space: .asciiz " "
	strA: .space 100
	strB: .space 100
.text
main:
	li $v0, 54
	la $a0, m
	la $a1, strA
	la $a2 100
	syscall # nhập xâu A
	li $v0, 54
	la $a0, m2
	la $a1, strB
	la $a2 100
	syscall # nhập xâu B
	la $t0, strA # con trỏ mảng A
	la $t1, strB # con trỏ mảng B
	li $t3, 10 # \n
	add $fp, $zero, $sp
	li $s3, 48 # số 0
	li $v0, 4
	la $a0, m3
	syscall
loop: # kiểm tra xem số i có trong A và B hay không
	lb $s0, 0($t0)
	lb $s1, 0($t1)
	beq $s0, $t3, print
	beq $s1, $t3, print
	# nếu như xét hết mà không có số nào trùng thì in số đang xét i ra 
	beq $s0, $s3, next
	beq $s1, $s3, next
	# nếu số i đang xét trùng với A hoặc B thì không xét nữa i++
	addi $t0, $t0, 1
	addi $t1, $t1, 1
	j loop
print:# in số i
	li $v0, 11
	add $a0, $zero, $s3
	syscall 
	li $v0, 4
	la $a0, space
	syscall
next: # i++
	addi $s3, $s3, 1
	beq $s3, 58, end
	la $t0, strA 
	la $t1, strB
	j loop
end:
	li $v0, 10
	syscall
	
	

