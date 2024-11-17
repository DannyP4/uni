.data	
	m3: .asciiz "Yeu cau: nhap 2 so nguyen M va N voi M lon hon N"
	m: .asciiz "nhap M: "
	m2: .asciiz "nhap N: "
	m4: .asciiz "so nguyen lon nhat chia het cho N va nho hon M la: "
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
	la $a0, newline
	syscall
	
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
divide:
	div $t0, $t1 # lấy M chia cho N
	mflo $s0 # lấy phần thương
	mul $s1, $s0, $t1 # nhân phần thương với N để ra kết quả
print: # in kết quả
	li $v0, 4
	la $a0, m4
	syscall
	li $v0, 1
	add $a0, $zero, $s1
	syscall
	j end
error: # in lỗi
	li $v0, 4
	la $a0, Error
	syscall
end:
	li $v0, 10
	syscall