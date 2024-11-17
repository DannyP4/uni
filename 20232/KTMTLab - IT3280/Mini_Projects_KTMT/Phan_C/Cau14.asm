.data
	m: .asciiz "nhap xau A: "
	m2: .asciiz "nhap xau B"
	m3: .asciiz "chuoi khong hop le"
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
	syscall # nhập xâu 
	la $t0, strA # con trỏ mảng A
	la $t1, strB # con trỏ mảng B
	li $t3, 10 # \n
	li $t4, 32 # " "
	add $fp, $zero, $sp
condition:
	la $t1, strB 
	addi $t2, $t0, 1# con trỏ phụ của A dùng để xóa các trường hợp bị trùng ký tự
	lb $s0, 0($t0)
	lb $s1, 0($t1)
	# lấy giá trị tại 2 con trỏ 
	
	beq $s0, $zero, next 
	# nếu A[i] = 0 thì xét tiếp A[i + 1]
	beq $s0, $t4, next
	# nếu A[i] = space thì xét tiếp A[i + 1]
	
	beq $s0, $t3, print
	# khi đã xét hết mảng A thì in kết quả 
	blt $s0, 65, error
	blt $s1, 65, error
	bgt $s0, 122, error
	bgt $s1, 122, error
	# các trường hợp ký tự không hợp lệ
	bge $s0, 97, next
	# nếu A[i] in thường thì xét tiếp 
	ble $s0, 90, loop1
	# nếu A[i] in hoa thì xét 
	j error 
loop1: # loop 1 kiểm tra xem A[i] có trùng với ký tự nào trong B hay không 
	beq $s0, $s1, loop2
	addi $t1, $t1, 1
	lb $s1, 0($t1)
	beq $s1, $t3, next 
	j loop1
loop2: # nếu A[i] tồn tại trong B thì xóa tất cả các kí tự giống A[i] trong A để không xét lại nữa
	lb $s2, 0($t2)
	beq $s2, $t3, save
	bne $s2, $s0, next2
	li $s2, 0
	sb $s2, 0($t2)
	j loop2
next2:
	addi $t2, $t2, 1
	j loop2
next:	
	addi $t0, $t0, 1
	j condition
error:
	li $v0, 4
	la $a0, m3
	syscall
	j end
save: # lưu ký tự hợp lệ vào mảng lưu kết quả 
	sb $s0, 0($sp)
	addi $sp, $sp, 1
	j next
print:
	sb $t3, 0($sp)
	li $v0, 4
	add $a0, $zero, $fp
	syscall
end:
	li $v0, 10
	syscall
	
# cách làm giống hệt bài 13