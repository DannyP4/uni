.data
    	A: 		.space 100  
    	Message: 	.asciiz "Nhap so phan tu mang: "  
    	Message1: 	.asciiz "Nhap so: "  
    	Message2: 	.asciiz "Nhap M: "  
    	Message3: 	.asciiz "Nhap N: "
    	Message4: 	.asciiz "Cac so nam ngoai khoang (M,N) la: "  
    	Space: 		.asciiz " "  
    	Eror: 		.asciiz "N phai lon hon M!\n"  

.text
main:
	# Nhập n số lượng phần tử:
	li 	$v0, 4  	
	la 	$a0, Message  	
	syscall  		
   
	li 	$v0, 5  	
	syscall  		
    
	move 	$s0, $v0  	# $s0 = n 
	la 	$a1, A  	# $a1 = địa chỉ A[0]
	j 	input_array  	

exit:
	li 	$v0, 10  		
	syscall  		

input_array:
	beq 	$t2, $s0, input_M_N  	# Nếu $t2 bằng $s0, nhảy đến nhãn input_M_N
	add 	$t0, $a1, $t1  		# $t0 = address of A[0] + 4 * $t1 = A[i]
	
	li 	$v0, 4  		
	la 	$a0, Message1 	 	
	syscall 			
    
	li 	$v0, 5  		
	syscall  			
	
	move 	$s1, $v0  		# Di chuyển số nguyên đã đọc vào $s1
	sw 	$s1, 0($t0)  		# Lưu giá trị của $s1 tại địa chỉ trong $t0
	addi 	$t2, $t2, 1  		# Tăng $t2 lên 1
	mul 	$t1, $t2, 4  		# Nhân $t2 với 4 và lưu kết quả vào $t1
	j 	input_array  		

input_M_N:
	li 	$v0, 4
    	la 	$a0, Message2  		
    	syscall  
    	
    	li 	$v0, 5  		
    	syscall 
    	
    	move 	$s1, $v0  		# Di chuyển M vào $s1
    	li 	$v0, 4  		
    	la 	$a0, Message3  		
    	syscall  
    	
    	li 	$v0, 5  
    	syscall
    	
    	move 	$s2, $v0  		# Di chuyển N vào $s2
    	bge 	$s1, $s2, PrintEror  	# Nếu $s1 lớn hơn hoặc bằng $s2, nhảy đến nhãn PrintEror
    	li 	$v0, 4  		
    	la 	$a0, Message4  		
    	syscall  
    	
    	li 	$t1, 0  		# $t1 = i = 0

loop:
    	beq 	$t1, $s0, exit  	# Nếu i bằng n, nhảy đến nhãn exit
    	lw 	$t0, 0($a1)  		# $t0 = A[0]
    	blt 	$t0, $s1, PrintNumber  	# Nếu $t0 < M, nhảy đến nhãn PrintNumber
    	bgt 	$t0, $s2, PrintNumber   # Nếu $t0 > N, nhảy đến nhãn PrintNumber
    	
continue:
    	addi 	$t1, $t1, 1  		# Tăng i lên 1
    	addi	$a1 $a1, 4  		# Tăng địa chỉ A[i] lên 4
    	j 	loop  					

PrintNumber:
	# In ra $t0
    	li 	$v0, 1  	
    	addi 	$a0, $t0, 0  		
    	syscall  
    	
    	li 	$v0, 4  		
    	la 	$a0, Space  		
    	syscall  
    	
    	j 	continue 

PrintEror:
    	li 	$v0, 4  		
	la 	$a0, Eror
	syscall
	j input_M_N
