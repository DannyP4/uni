.data 
	m: .asciiz "nhap xau ki tu: "
	m2: .asciiz "nhung ky tu co trong xau la: "
	space: .asciiz " "
	string: .space 100
.text
main:
	li $v0, 54
	la $a0, m
	la $a1, string
	la $a2 100
	syscall # nhập chuỗi
	li $v0, 4
	la $a0, m2
	syscall 
	la $t0, string # lấy địa chỉ đầu của xâu
	add $t1, $zero, $t0
set: 
	li $t2, 10 # ký tự \n
	li $t3, 32 # ký tự " "
length: # đưa con trỏ t1 về cuối chuỗi
	add $t1, $t1, 1
	lb $s0, 0($t1)
	bne $s0, $t2, length
browser: 
	lb $s0, 0($t0) # lấy ký tự tại con trỏ t0
	add $t4, $zero, $t1 # con trỏ t4 dùng cho mảng những ký tự đã có
	j check
next:
	add $t0, $t0, 1
	beq $t0, $t1, end # kết thúc khi duyệt hết các ký tự
	j browser
check:
	addi $t4, $t4, 1
	lb $s1, 0($t4) # lấy ký tự tại t4
	beq $s0, $s1, next # nếu ký tự đã tồn tại thì next
	beq $t3, $s0, next # nếu đó là khoảng trắng thì next
	beq $s1, $zero, save # nếu không trùng với ký tự nào đã có thì lưu 
	j check
save:
	sb $s0, 0($t4)
print: # in ký tự đó ra 
	li $v0, 4
	add $a0, $zero, $t4
	syscall
	li $v0, 4
	la $a0, space
	syscall
	j next
end:
	li $v0, 10
	syscall
	
# độ phức tạo O(n^2)

	