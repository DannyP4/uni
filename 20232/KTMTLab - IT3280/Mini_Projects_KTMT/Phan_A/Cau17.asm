.data	
	m3: .asciiz "Yeu cau: nhap 2 so nguyen M va N voi M lon hon N"
	m: .asciiz "nhap M: "
	m2: .asciiz "nhap N: "
	m4: .asciiz "so nguyen nho nhat la uoc cua M : "
	Error: .asciiz "M phai lon hon N"
	newline: .asciiz "\n"
.text
main: # in các dòng thông báo và nhập số
	li $v0, 4
	la $a0, m3
	syscall
	
	li $v0, 4
	la $a0, newline
	syscall
	
	li $v0, 4
	la $a0, m
	syscall
	li $v0, 5
	syscall
	add $t0, $zero, $v0
	
	li $v0, 4
	la $a0, m2
	syscall
	li $v0, 5
	syscall
	add $t1, $zero, $v0
	
	li $v0, 4
	la $a0, newline
	syscall
	 
	# t0 la M, t1 la N
condition:
	ble $t0, $t1, error # nếu M nho hơn hoac = N thì báo lỗi
	add $s0, $t1, 1
divide: # chia lần lượt với các số N++
	div $t0, $s0 # lấy M chia cho N-->
	mfhi $s1 # phần dư 
	beq $s1, $zero, print
	add $s0, $s0, 1 # N++
	j divide
print: # in kết quả
	li $v0, 4
	la $a0, m4
	syscall
	li $v0, 1
	add $a0, $zero, $s0
	syscall
	j end
error: # in lỗi
	li $v0, 4
	la $a0, Error
	syscall
end:
	li $v0, 10
	syscall