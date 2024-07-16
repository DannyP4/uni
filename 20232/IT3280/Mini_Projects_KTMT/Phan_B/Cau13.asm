.data
	A: 		.space 100
	Message: 	.asciiz "Nhap so phan tu mang: "
	Message1: 	.asciiz "Nhap so: "
	Message2: 	.asciiz "So cac phan tu khac nhau trong mang la: "
	Eror: 		.asciiz "So phan tu mang phai lon hon bang 1!\n"
	
.text
main:
	li 	$v0, 4
	la 	$a0, Message
	syscall
	
	# Nhap so phan tu N:
	li 	$v0, 5
	syscall
	
	move 	$s0, $v0	# luu N vao $s0
	blt 	$s0, 1, PrintEror
	la 	$a1, A		# $a1 = address of A[0]
	j 	input_array
	
exit:
	li 	$v0, 10
	syscall
	
input_array:
	# Nhap cac phan tu cua mang:
	beq 	$t2, $s0, Check
	add 	$t0, $a1, $t1
	li 	$v0, 4
	la 	$a0, Message1
	syscall
	
	li 	$v0, 5
	syscall
	
	move 	$s1, $v0
	sw 	$s1, 0($t0)
	addi 	$t2, $t2, 1
	mul 	$t1, $t2, 4
	j 	input_array
	
Check:
	li 	$t0, 0		# i = 0
	li 	$s1, 0		# $s1 = count = 0
	addi 	$s2, $a1, 0	# $s2 = address of A[0]
	
Reset:
	li 	$t1, 0		# j = 0
	addi 	$s3, $a1, 0	# $s3 = address of A[0]
	
loop1:
	beq 	$t0, $s0, PrintResult	# i = N => In ket qua
	lw 	$v0, 0($s2)		# v0 = A[i]
	
loop2:
	beq 	$t1, $t0, Update	# i = j => update
	lw 	$v1, 0($s3)		# $v1 = A[j]
	beq 	$v1, $v0, Break		# A[i] = A[j] => break
	addi 	$t1, $t1, 1		# j++
	addi 	$s3, $s3, 4		# address of next index
	j 	loop2
	
Break:
	addi 	$t0, $t0, 1	# i++
	addi 	$s2, $s2, 4	# Chuyen sang A[i + 1]
	j 	Reset
	
Update:
	addi 	$s1, $s1, 1	# count++
	j 	Break
	
PrintResult:
	# In ra ket qua:
	li 	$v0, 4
	la 	$a0, Message2
	syscall
	
	li 	$v0, 1
	addi 	$a0, $s1, 0
	syscall
	j exit
	
PrintEror:
	li 	$v0, 4
	la 	$a0, Eror
	syscall
	j 	main
	
	
#    int count = 0;
#    for (int i = 0; i < N; i++) {
#        int j = 0;
#        while (j < i) {
#            if (A[j] == A[i])
#                break;
#            j++;
#        }
#        if (j == i)
#            count++;
#    }
