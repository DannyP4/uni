.data
	A:          	.space 100       
	Message:    	.asciiz "Nhap so phan tu mang: "
	Space:      	.asciiz " "
	Message1:   	.asciiz "Nhap so: "
	Newline:    	.asciiz "\n"
	Prompt:     	.asciiz ": "
	Result:     	.asciiz "Phan tu xuat hien it nhat la: "
	Eror:		.asciiz "So phan tu mang phai lon hon bang 1!\n"

.text
main:
	li 	$v0, 4               
	la 	$a0, Message         
	syscall                 
	
	# Nhập N:
    	li 	$v0, 5               
    	syscall               
    	
    	move 	$s0, $v0		# $s0 = N
    	blt 	$s0, 1, PrintEror	# N < 1 => Error branch

    	la 	$a1, A          # $a1 = address of A[0]
    	li 	$t0, 0          # $t0 = i = 0

input_array:
	# Nhập các phần tử:
    	beq 	$t0, $s0, init		# Nếu i = N => find_min branch 
    	li 	$v0, 4			
    	la 	$a0, Message1		
    	syscall

    	li 	$v0, 5
    	syscall
   	
   	sw 	$v0, 0($a1)		# $a1 = A[i]
    	addi 	$a1, $a1, 4		# Di chuyển con trỏ đến phần tử tiếp theo trong mảng
    	addi 	$t0, $t0, 1             # i++
    	j 	input_array

init:
    	li 	$t0, 0			# $t0 = i = 0
    	la 	$a1, A  		# $a1 = address of A[0]
    	move 	$s1, $s0           	# $s1 = $s0 = N
    	li 	$t1, 0x7fffffff      	# $t1 = count_min = 99999.. ( phần tử xuất hiện ít nhất) 
    	li 	$t2, 0               	# $t2 = biến lưu phần tử xuất hiện ít nhất
    	li 	$t3, 0               	# $t3 = count = 0

count:
    	beq 	$t0, $s1, print_result	# Nếu i = N => print_result branch
    	lw 	$t4, 0($a1)		# $t4 = A[i]
    	li 	$t5, 0			# j = 0
    	move 	$s2, $t0		# $s2 = i = $t0
    	la 	$a2, A 			# $a2 = address of A[0]

compare:
    	beq 	$t5, $s1, update    	# Nếu j = N => update branch
    	lw 	$t6, 0($a2)		# $t6 = A[j]
    	beq 	$t6, $t4, increment_count	# Nếu A[j] = A[i] => increment_count branch
    	addi 	$t5, $t5, 1                     # j++
    	addi 	$a2, $a2, 4                     # address of next index
    	j 	compare

increment_count:
    	addi 	$t3, $t3, 1                    # count++
    	addi 	$t5, $t5, 1                    # j++
    	addi 	$a2, $a2, 4                    # address of next index
    	j 	compare

update:
    	blt 	$t3, $t1, update_min	# Nếu count < count_min => update count = count_min 
    	addi 	$t0, $t0, 1		# i++
    	addi 	$a1, $a1, 4 		# Di chuyển con trỏ đến index tiếp ( là A[i + 1])
    	li 	$t3, 0			# Đặt lại count = 0
    	j 	count

update_min:
    	move 	$t1, $t3	# Cập nhật count_min vào $t1
    	move 	$t2, $t4	# Cập nhật phần tử xuất hiện ít nhất là phần tử thứ i vào $t2
    	addi 	$t0, $t0, 1	# i++
    	addi 	$a1, $a1, 4	# Di chuyển con trỏ đến index tiếp ( là A[i + 1])
    	li 	$t3, 0		# Đặt lại count = 0
    	j 	count

print_result:
	# In ra kết quả 
    	li 	$v0, 4               
    	la 	$a0, Result         
    	syscall   

    	li 	$v0, 1    
    	move 	$a0, $t2       
    	syscall    

    	li 	$v0, 4         
    	la 	$a0, Newline    
    	syscall
    	j 	exit                

PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	j 	main
    
exit:
	li 	$v0, 10
	syscall
