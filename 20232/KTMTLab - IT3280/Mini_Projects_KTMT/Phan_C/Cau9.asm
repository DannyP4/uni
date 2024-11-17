.data
	m: .asciiz "nhap xau: "
	m2: .asciiz "xau khong hop le"
	string: .space 100
.text
main:
	li $v0, 54
	la $a0, m
	la $a1, string
	la $a2 100
	syscall # nhập xâu
	la $t0, string
	li $t1, 10 # \n
	li $t2, 32 # " "
check:
	lb $s0, -1($t0)# lấy ký tự trước đó
	lb $s1, 0($t0) # lấy ký tự hiện tại
	beq $s1, $t2, next # nếu ký tự hiện tại là khoảng trắng thì không xét
	beqz $s0, head 
	beq $s0, $t2, head
	# nếu ký tự trước đó là 0 hoặc khoảng trắng thì đó là ký tự đầu 
	j mid
	# còn lại là ký tự giữa
head:
	lb $s1, 0($t0)
	bgt $s1, 122, error
	blt $s1, 65, error 
	# các trường hợp ko hợp lệ
	ble $s1, 90, next
	# nếu đó là ký tự in hoa thì giữ nguyên
	bge $s1, 97, up
	# nếu là ký tự thường thì đổi thành in hoa 
	j error
mid:
	lb $s1, 0($t0)
	bgt $s1, 122, error
	blt $s1, 65, error 
	ble $s1, 90, down
	# nếu đó là ký tự in hoa thì đổi thành thường
	bge $s1, 97, next
	# nếu là ký tự thường thì giữ nguyên
	j error
up:
	addi $s1, $s1, -32
	sb $s1, 0($t0)
	j next
down: 
	addi $s1, $s1, 32
	sb $s1, 0($t0)
	j next
next: # xét đến ký tự tiếp theo
	addi $t0, $t0, 1
	lb $s1, 0($t0)
	bne $s1, $t1, check
	j print
error:
	li $v0, 4
	la $a0, m2
	syscall
	j end
print:
	li $v0, 4
	la $a0, string
	syscall
end:
	 li $v0, 10
	 syscall
	

	
