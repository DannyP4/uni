.data
	m: .asciiz "nhap xau: "
	m2: .asciiz "nhap ky tu: "
	m3: .asciiz "so lan ky tu xuat hien trong xau la: "
	m4: .asciiz "ky tu khong hop le"
	string: .space 100
	string2: .space 100
.text
	li $v0, 54
	la $a0, m
	la $a1, string
	la $a2 100
	syscall # nhập xâu
	li $v0, 54
	la $a0, m2
	la $a1, string2
	la $a2 100
	syscall # nhập ký tự
set: 
	li $s2, 0 # biến đếm
	li $t2, 10 # \n
	la $t0, string 
	la $t1, string2
	lb $s1, 0($t1) # ký tự cần đếm
check:
	bgt $s1, 122, error
	blt $s1, 65, error
	bge $s1, 97, compare1 # khi ký tự in thường
	ble $s1, 90, compare2 # khi ký tự in hoa
	j error
compare1: # lấy từng ký tự của xâu ra để so sánh
	lb $s0, 0($t0)
	beq $s0, $t2, print # khi duyệt hết thì in kết quả 
	add $t0, $t0, 1
	beq $s0, $s1, up1
	addi $s3, $s1, -32
	beq $s0, $s3, up1
	j compare1
compare2: # lấy từng ký tự của xâu ra để so sánh
	lb $s0, 0($t0)
	beq $s0, $t2, print # khi duyệt hết thì in kết quả 
	add $t0, $t0, 1
	beq $s0, $s1, up2
	addi $s3, $s1, 32
	beq $s0, $s3, up2
	j compare2
up1:  # cộng 1 cho biến đếm trong trường hợp trùng
	add $s2, $s2, 1
	j compare1
up2:  # cộng 1 cho biến đếm trong trường hợp trùng
	add $s2, $s2, 1
	j compare2 
print: # in kết quả 
	li $v0, 4
	la $a0, m3
	syscall
	li $v0, 1
	add $a0, $zero, $s2
	syscall
	j end
error: 
	li $v0, 4
	la $a0, m4
	syscall
end:


	
# o(n)

	
