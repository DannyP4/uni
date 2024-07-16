# có thể dùng div thay cho phần divisor bên dưới vì nó khá lâu 

.data 
	m1: .asciiz "nhap mot so bat ky: "
	m2: .asciiz " "
.text 
input: # nhập N
	li $v0, 51 
	la $a0, m1
	syscall
	add $s0, $zero, $a0
	
	li $s1, 2 # i
set: 
	addi $s1, $s1, 1 # i++
	beq $s1, $s0, end  # đã kiểm tra hết các số
	li $s2 , 1 # j (tìm ước của i)
	li $s4, 1 # sum
loop2:
	add $s5 , $s2, $s2
	slt $t0, $s5, $s1 
	beq $t0, $zero, check
	# nếu 2j >= i thì kết thúc vòng lặp và kiểm tra 
	addi $s2, $s2, 1 # j++
	add $s3, $zero, $s1 # i'
divisor: # có thể dùng div thay thế
	sub $s3, $s3, $s2 
	slt $t0, $s3, $s2 
	# nếu i' >= j -> t0 = 0
	# nếu i' < j -> t0 = 1
	beq $t0, $zero, divisor
	# nếu i' >= j quay lại  
	beq $s3 , $zero, sum
	# nếu i' = 0 thì chia hết 
	bne $s3 , $zero, loop2
	# nếu i' != 0 thì khong chia het
sum:	
	add $s4, $s4, $s2
	j loop2
check:
	beq $s4, $s1, perfect_num
	j set
perfect_num: 
	li $v0, 1
	add $a0, $zero, $s1 
	syscall
	li $v0, 4
	la $a0, m2
	syscall
	j set
end:
	li $v0, 10
	syscall
