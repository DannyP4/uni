.data
	A: 		.space 100            
	Message: 	.asciiz "Nhap so phan tu mang: "    
	Message1: 	.asciiz "Nhap so: "                   
	Message2: 	.asciiz "Cap phan tu lien ke co tich lon nhat la: "   
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 2!\n"   
	Space: 		.asciiz " "                 
	    
.text
main:
	li 	$v0, 4                
	la 	$a0, Message         
	syscall                  
	
	# Nhập số phần tử:
	li 	$v0, 5                
	syscall
	                   
	move 	$s0, $v0             
	blt 	$s0, 2, PrintEror	# Nếu số phần tử mảng < 2 => PrintEror branch

	la 	$a1, A			# Đưa địa chỉ của mảng A vào $a1
	j 	input_array             

exit:
	li 	$v0, 10			
	syscall			

input_array:
	beq 	$t2, $s0, CheckMul      # Nếu $t2 = $s0 = N => CheckMul branch
	add 	$t0, $a1, $t1           # Address of A[i]
	li 	$v0, 4                 
	la 	$a0, Message1          
	syscall                   

	li 	$v0, 5                 
	syscall           
	       
	move 	$s1, $v0		# $s1 = $v0
	sw 	$s1, 0($t0)		# A[i] = $s1
	addi 	$t2, $t2, 1		# $t2++
	mul 	$t1, $t2, 4		# $t1 = 4 * $t2
	j 	input_array		

CheckMul:
	addi 	$s0, $s0, -1            # Giảm số phần tử mảng đi 1
	li 	$s1, -1			# max_mul = -1
	li 	$t0, 0                  # Biến đếm $t0 = i = 0

loop:
	beq 	$t0, $s0, PrintMul	# Nếu $t0 (biến đếm) bằng $s0 (số phần tử mảng), nhảy đến nhãn PrintMul
	lw 	$t1, 0($a1)             # $t1 = A[i]
	lw 	$t2, 4($a1)             # $t2 = A[i + 1]
	mul 	$t3, $t1, $t2           # Tính tích của cặp phần tử hiện tại và phần tử tiếp theo
	bgt 	$t3, $s1, Update        # Nếu tích > max_mul => Update branch
	j 	continue

continue:
	addi 	$t0, $t0, 1          # i++
	addi 	$a1, $a1, 4          # $a1 += 4 
	j 	loop                 

Update:
	addi 	$s1, $t3, 0          # Cập nhật max_mul
	addi 	$s2, $t1, 0          # $s2 = A[i]
	addi 	$s3, $t2, 0          # $s3 = A[i + 1]
	j 	continue

PrintMul:
	# In ra kết quả 
	li 	$v0, 4              
	la 	$a0, Message2  
	syscall

	li 	$v0, 1
	addi 	$a0, $s2, 0
	syscall

	li 	$v0, 4
	la 	$a0, Space
	syscall 

	li 	$v0, 1 
	addi 	$a0, $s3, 0
	syscall

	j 	exit

PrintEror:
	li 	$v0, 4        
	la 	$a0, Eror             
	syscall                   
	j 	main                   
