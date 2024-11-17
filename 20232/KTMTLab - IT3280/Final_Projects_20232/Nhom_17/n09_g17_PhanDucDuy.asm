.data 
	m:	.space 5000
	menu:	.asciiz "\nmenu: \n1. in hinh anh goc\n2. in hinh anh khong co mau\n3. in hinh anh dao nguoc chu\n4. doi mau chu\n5. exit\n"
	m7:	.asciiz "mau cua D(0-9): "
	m8:	.asciiz "mau cua C(0-9): "
	m9:	.asciiz "mau cua E(0-9): "
	m10:    .asciiz "yeu cau khong hop le vui long chon tu 1 den 5\n"
	m11:	.asciiz "so khong hop le vui long chon tu 0 den 9\n"
.text
continue:
main:
#------------------hien thi menu--------------------#
	li 	$v0, 4
	la 	$a0, menu
	syscall
	# menu:
#------------------nhap yeu cau---------------------#		
	li 	$v0, 5
	syscall
	add 	$s4, $zero, $v0
	# luu yeu cau nguoi dung vao s4
#----------------kiem tra dieu kien-----------------#	
	bge 	$s4, 6, error
	ble 	$s4, 0, error
	# neu nguoi dung nhap so khong hop le (lon hon 5 hoac nho hon 1) thi nhay den error 	
	bne 	$s4, 5, setup
	# neu yeu cau nguoi dung la 1,2,3,4 thi nhay den setup
	# neu yeu cau la 5 thi thuc hien exit
exit:
	li 	$v0, 10
	syscall
	# thoat chuong trinh
#-------------thiet lap bien, tham so---------------#	
setup:
	la 	$s0, m # con tro
	la 	$s1, 0 # bo dem
	la 	$s2, 0 # so lan in ky tu 
	li 	$t0, 42 # *
	li 	$t1, 50 # mau cua D
	li 	$t2, 49 # mau cua C
	li	$t3, 51 # mau cua E
	li 	$t4, 32 # space 
	li 	$t5, 10 # /n
	bne 	$s4, 4, create_image
	# neu yeu cau nguoi dung la 1,2,3 thi thuc hien tao hinh
	
#-------------------doi mau chu---------------------#
	li 	$v0, 4
	la 	$a0, m7
	syscall
	# mau cua D(0-9):
	li 	$v0, 5
	syscall
	addi 	$t1, $v0, 48
	# luu mau cua D vao t1
	bge 	$t1, 58, error2
	ble 	$t1, 47, error2
	# kiem tra ky tu khong hop le
	
	
	li 	$v0, 4
	la 	$a0, m8
	syscall
	# mau cua C(0-9):
	li 	$v0, 5
	syscall
	addi 	$t2, $v0, 48
	# luu mau cua C vao t1
	bge 	$t2, 58, error2
	ble 	$t2, 47, error2
	# kiem tra ky tu khong hop le
	
	
	li 	$v0, 4
	la 	$a0, m9
	syscall
	# mau cua E(0-9):
	li 	$v0, 5
	syscall
	addi 	$t3, $v0, 48
	# luu mau cua E vao t1
	bge 	$t3, 58, error2
	ble 	$t3, 47, error2
	# kiem tra ky tu khong hop le
	j create_image

#------------------ham tao ky tu--------------------#
# cac ham ben duoi nhan tham so (s2) la so ky tu duoc in ra 

create_border: # tao vien "*"
	sb 	$t0, 0($s0)			# luu ky tu * vao bo nho 
	addi 	$s0, $s0, 1			# di chuyen con tro den o nho tiep theo
	addi 	$s1, $s1, 1			# bo dem + 1
	bne 	$s1, $s2, create_border		
	# neu bo dem != s2(so ky tu dc in ra) thi tiep tuc in 
	li 	$s1, 0				# thiet lap lai s1 ve 0 
	jr 	$ra 		
								
create_color_D: # tao mau cho D
		# cach hoat dong giong ham tren
	beq 	$s4, 2, create_space		
	# neu nguoi dung chon "2. in hinh anh khong co mau" thi tao khoang trong
	sb 	$t1, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	bne 	$s1, $s2, create_color_D
	li 	$s1, 0
	jr 	$ra 
create_color_C: # tao mau cho D
		# cach hoat dong giong ham tren
	beq 	$s4, 2, create_space		
	# neu nguoi dung chon "2. in hinh anh khong co mau" thi tao khoang trong
	sb 	$t2, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	bne 	$s1, $s2, create_color_C
	li 	$s1, 0
	jr 	$ra 
create_color_E: # tao mau cho D
		# cach hoat dong giong ham tren
	beq 	$s4, 2, create_space		
	# neu nguoi dung chon "2. in hinh anh khong co mau" thi tao khoang trong
	sb 	$t3, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	bne 	$s1, $s2, create_color_E
	li 	$s1, 0
	jr 	$ra 
create_space:  	# tao khoang trong
		# cach hoat dong giong ham tren
	sb 	$t4, 0($s0)
	addi 	$s0, $s0, 1
	addi 	$s1, $s1, 1
	bne 	$s1, $s2, create_space
	li 	$s1, 0
	jr 	$ra 
#------------------ham tao hinh---------------------#
create_image:
	# chieu rong cua D la 22
	# chieu rong cua C la 20
	# chieu rong cua E la 16
	
	li 	$s2, 22 			# so ky tu duoc in la 22
	jal 	create_space			# nhay den ham in ky tu tuong ung
	
	li 	$s2, 20 
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_space
	li 	$s2, 13 
	jal 	create_border
	li 	$s2, 2 
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 1	
						
	li 	$s2, 14
	jal 	create_border
	li 	$s2, 8 
	jal 	create_space
	
	li 	$s2, 20 
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13 
	jal 	create_color_E
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1 
	jal	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 2
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 15 
	jal 	create_color_D
	li	$s2, 1 
	jal 	create_border
	li 	$s2, 5 
	jal 	create_space
	
	li 	$s2, 20 
	jal	create_space
	
	li 	$s2, 1 
	jal	create_border
	li 	$s2, 5 
	jal 	create_color_E
	li 	$s2, 8
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 3
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5 
	jal 	create_color_D
	li 	$s2, 6 
	jal 	create_border
	li 	$s2, 6 
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 3 
	jal 	create_space
	
	li 	$s2, 20 
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5 
	jal 	create_color_E
	li 	$s2, 1
	jal 	create_border
	li 	$s2, 9 
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 4
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 6
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	
	li 	$s2, 20
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_E
	li 	$s2, 8 
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 5
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 7
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1
	jal 	create_space
	
	li 	$s2, 5
	jal 	create_space
	li 	$s2, 13 
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13
	jal 	create_color_E
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1 
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 6
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 7
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1
	jal 	create_space
	
	li 	$s2, 3
	jal 	create_space
	li 	$s2, 2 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_C
	li 	$s2, 5 
	jal 	create_border
	li 	$s2, 3
	jal 	create_color_C
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_E
	li 	$s2, 8 
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 7
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 7
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1
	jal 	create_space
	
	li 	$s2, 1
	jal 	create_space
	li 	$s2, 2
	jal 	create_border
	li 	$s2, 4
	jal	create_color_C
	li 	$s2, 2
	jal 	create_border
	li 	$s2, 7
	jal 	create_space
	li 	$s2, 2
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5 
	jal 	create_color_E
	li 	$s2, 1
	jal 	create_border
	li 	$s2, 9 
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 8
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 6
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 6
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 1
	jal 	create_space
	
	li 	$s2, 1
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 4
	jal 	create_color_C
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_E
	li 	$s2, 8 
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 9
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5 
	jal 	create_color_D
	li 	$s2, 7 
	jal 	create_border
	li 	$s2, 6 
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_C
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13 
	jal 	create_color_E
	li 	$s2, 1 
	jal 	create_border
	li	$s2, 1 
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 10
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 16 
	jal 	create_color_D
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 4
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_C
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_space
	li 	$s2, 13 
	jal 	create_border
	li 	$s2, 2 
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 11
	
	li 	$s2, 15
	jal 	create_border
	li 	$s2, 7 
	jal 	create_space
	
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 5
	jal 	create_color_C
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 13
	jal 	create_space
	
	li 	$s2, 16
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 12
	
	li 	$s2, 6
	jal 	create_space
	li 	$s3, 45
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 13
	jal 	create_space
	
	li 	$s2, 1
	jal 	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 4
	jal 	create_color_C
	li 	$s2, 2
	jal 	create_border
	li 	$s2, 12
	jal 	create_space
	
	li 	$s2, 16
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 13
	
	li 	$s2, 4
	jal 	create_space
	li 	$s3, 47
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 1
	jal 	create_space
	li 	$s3, 111
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 1
	jal 	create_space
	li 	$s3, 111
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 1
	jal 	create_space
	li 	$s3, 92
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 11
	jal 	create_space
	
	li 	$s2, 2
	jal	create_space
	li 	$s2, 1 
	jal 	create_border
	li 	$s2, 4
	jal 	create_color_C
	li 	$s2, 4 
	jal 	create_border
	li 	$s2, 3
	jal 	create_space
	li 	$s2, 5
	jal 	create_border
	li 	$s2, 1
	jal 	create_space
	
	li 	$s2, 16
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 14
	
	li 	$s2, 4
	jal 	create_space
	li 	$s3, 92
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 3
	jal 	create_space
	li 	$s3, 62
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 1
	jal 	create_space
	li 	$s3, 47
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 1
	jal 	create_space
	li 	$s2, 10
	jal 	create_space
	
	li 	$s2, 3
	jal	create_space
	li 	$s2, 2
	jal 	create_border
	li 	$s2, 6
	jal 	create_color_C
	li 	$s2, 3
	jal 	create_border
	li 	$s2, 3
	jal 	create_color_C
	li 	$s2, 1
	jal 	create_border
	li 	$s2, 2
	jal 	create_space
	
	li 	$s2, 16
	jal 	create_space
	sb 	$t5, 0($s0)
	addi 	$s0, $s0, 1
	# dong 15
	
	li 	$s2, 5
	jal 	create_space
	li 	$s3, 45
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 45
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 45
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 45
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 45
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 12
	jal 	create_space
	
	li 	$s2, 5
	jal 	create_space
	li 	$s2, 11 
	jal 	create_border
	li 	$s2, 4
	jal 	create_space
	
	li 	$s3, 100
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 99
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 101
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 46
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 104
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 117
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 115
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 116
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 46
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 101
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 100
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 117
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 46
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 118
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s3, 110
	sb 	$s3, 0($s0)
	addi 	$s0, $s0, 1
	li 	$s2, 1
	jal 	create_space
	# dong 16

	
	li 	$s6, 16		# bien dem so dong 
	la 	$s0, m
	beq 	$s4, 3, print_option_3
	# neu nguoi dung chon "3. in hinh anh dao nguoc chu"
#------------------in hinh 1, 2, 4---------------------#	
print_option_1_2:
	li 	$v0, 11
	lb 	$a0, 0($s0)
	syscall
	# in ky tu
	beq 	$a0, 0, end 
	# gap ky tu NULL thi ket thuc
	addi 	$s0, $s0, 1
	# con tro + 1
	j 	print_option_1_2
#--------------------in hinh 3----------------------#	
# ham nay thuc hien in hinh dao nguoc chu ECD
# chieu rong cua D la 22
# chieu rong cua C la 20
# chieu rong cua E la 16
print_option_3:
	addi 	$s0, $s0, 42 # chuyen con tro den chu E
	li 	$s1, 0	     # thiet lap bien dem ve 0
loop:	# thuc hien in mot dong cua chu E
	li 	$v0, 11
	lb 	$a0, 0($s0)
	syscall
	addi 	$s1, $s1, 1
	addi 	$s0, $s0, 1
	bne 	$s1, 16, loop	# in den khi nao du 16 ky tu
	addi 	$s0, $s0, -36	# chuyen con tro den chu C
	li 	$s1, 0		# thiet lap bien dem ve 0
loop2: 	# thuc hien in mot dong cua chu C
	li 	$v0, 11
	lb 	$a0, 0($s0)
	syscall
	addi 	$s1, $s1, 1
	addi 	$s0, $s0, 1
	bne 	$s1, 20, loop2	# in den khi nao du 20 ky tu
	addi 	$s0, $s0, -42	# chuyen con tro den chu D
	li 	$s1, 0		# thiet lap bien dem ve 0
loop3:	# thuc hien in mot dong cua chu D
	li 	$v0, 11
	lb 	$a0, 0($s0)
	syscall
	addi 	$s1, $s1, 1
	addi 	$s0, $s0, 1
	bne 	$s1, 22, loop3	# in den khi nao du 22 ky tu
	addi 	$s0, $s0, 79	# chuyen con tro den chu E cua dong tiep theo
	li 	$s1, 0		# thiet lap bien dem ve 0
	addi 	$s6, $s6, -1	# so dong -1
	li 	$v0, 11
	li 	$a0, 10
	syscall
	# xuong dong
	bne 	$s6, 0, loop	
	j 	end		# in du 16 dong thi ket thuc 
#---------------------bao loi-----------------------#
error:
	li 	$v0, 4
	la 	$a0, m10
	syscall	
	# bao loi "yeu cau khong hop le vui long chon tu 1 den 5"
	li 	$v0, 4
	la 	$a0, menu
	syscall
	# hien thi lai menu lua chon
		
	li 	$v0, 5
	syscall
	add 	$s4, $zero, $v0
	# doc lai yeu cau
	
	bge 	$s4, 6, error
	ble 	$s4, 0, error	
	# tiep tuc kiem tra loi
	bne 	$s4, 5, setup
	# neu chon 5 thi ket thuc
error2:
	li 	$v0, 4
	la 	$a0, m11
	syscall
	# bao loi "so khong hop le vui long chon tu 1 den 9"
	j 	setup
	# chon lai mau
end:
	j 	main	
	
	
	
	

