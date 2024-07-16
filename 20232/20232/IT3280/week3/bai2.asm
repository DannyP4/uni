.data
	array: .word 2, 4, 6, 8
.text
	addi	$s5, $zero, 0	# khoi tao sum
	addi	$s1, $zero, 0	# khoi tao i
	addi	$s3, $zero, 4	# khoi tao n
	addi	$s4, $zero, 1	# khoi tao step
	la	$s2, array	# khoi tao array 
loop:	slt 	$t2, $s1, $s3	# i<n	
	beq	$t2, $zero, endloop
	add	$t1, $s1, $s1
	add	$t1, $t1, $t1	# t1 = 4*i dia chi address them vao
	add	$t1, $t1, $s2   
	lw	$t0, 0($t1)	# load gia tri A[i] vao $t0
	add     $s5, $s5, $t0 	# sum = sum + A[i]
	add 	$s1, $s1, $s4	# i = i + step
	j	loop
endloop:
