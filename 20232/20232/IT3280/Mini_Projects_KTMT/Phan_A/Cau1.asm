.data 
	message: .asciiz "so nguyen la: "
	message2: .asciiz ", "
	
.text
	li $v0, 51 
	la $a0, message 
	syscall
	add $s0, $zero, $a0 # s0 = N
 	li $s1, 0 # i = 0 
 	
kiem_tra_i:
	addi $s1, $s1, 1 # i = i + 1
 	beq $s1, $s0, END # nếu i = n thì nhảy đến END 
 	add $s2, $zero, $s1 # lưu i vào biến tạm i'
 	
chia_het_cho_3:
	sub $s2, $s2, 3 
	#lấy i' - 3 = i'
	slti $t0, $s2, 3 
	# nếu i' >= 3 -> t0 = 0
	# nếu i' < 3 -> t0 = 1
	beq $t0, $zero, chia_het_cho_3
	# nếu i' >= 3 quay lại  
	beq $s2 , $zero, print_3
	# nếu i' = 0 thì chia hết 
	add $s2, $zero, $s1
	
chia_het_cho_5:
	sub $s2, $s2, 5
	#lấy i - 5 = i'
	slti $t0, $s2, 5
	# nếu i' >= 5 -> t0 = 0
	# nếu i' < 5 -> t0 = 1
	beq $t0, $zero, chia_het_cho_5
	# nếu i' = 0 thì chia hết 
	# nếu không chia hết cho số nào quay lại từ đầu
	
print_5: 
	li $v0, 1
	add $a0, $zero, $s1
	syscall 
	addi $s4, $s1, 5
	slt $t0, $s4, $s0
	# nếu s4 >= i -> t0 = 0
	# nếu s4 < i -> t0 = 1
	beq $t0, $zero, END
	# nếu s4 >= i thì ta không in dấu , nữa 
	li $v0, 4
	la $a0, message2
	syscall
	j kiem_tra_i	
	
print_3: 
	li $v0, 1
	add $a0, $zero, $s1
	syscall 
	addi $s4, $s1, 2
	addi $s4, $s1, 3
	slt $t0, $s4, $s0
	# nếu s4 >= i -> t0 = 0
	# nếu s4 < i-> t0 = 1
	beq $t0, $zero, END
	# nếu s4 >= i thì ta không in dấu , nữa 
	li $v0, 4
	la $a0, message2
	syscall
	j kiem_tra_i
	
END:
	li $v0, 10
	syscall
