.data
	#(21+21+21+1)x16 = 1024
	String: .asciiz "                                           *************       \n**************                            *3333333333333*      \n*222222222222222*                         *33333********       \n*22222******222222*                       *33333*              \n*22222*      *22222*                      *33333********       \n*22222*       *22222*      *************  *3333333333333*      \n*22222*       *22222*    **11111*****111* *33333********       \n*22222*       *22222*  **1111**       **  *33333*              \n*22222*      *222222*  *1111*             *33333********       \n*22222*******222222*  *11111*             *3333333333333*      \n*2222222222222222*    *11111*              *************       \n***************       *11111*                                  \n     ---               *1111**                                 \n   / o o \\              *1111****   *****                      \n   \\   > /               **111111***111*                       \n    -----                  ***********    dce.hust.edu.vn      \n" 
	 "                                           *************       \n"
	 "**************                            *3333333333333*      \n"
	 "*222222222222222*                         *33333********       \n"
	 "*22222******222222*                       *33333*              \n"
	 "*22222*      *22222*                      *33333********       \n"
	 "*22222*       *22222*      *************  *3333333333333*      \n"
	 "*22222*       *22222*    **11111*****111* *33333********       \n"
	 "*22222*       *22222*  **1111**       **  *33333*              \n"
	 "*22222*      *222222*  *1111*             *33333********       \n"
	 "*22222*******222222*  *11111*             *3333333333333*      \n"
	 "*2222222222222222*    *11111*              *************       \n"
	 "***************       *11111*                                  \n"
	 "     ---               *1111**                                 \n"
	 "   / o o \\              *1111****   *****                      \n"
	 "   \\   > /               **111111***111*                       \n"
	 "    -----                  ***********    dce.hust.edu.vn      \n"           
	Menu:.asciiz "\n\n\n=============================MENU===========================\n|1. Hien thi hinh anh tren giao dien                       |\n|2. Hien thi hinh anh chi con lai vien, khong co mau o giua|\n|3. Hien thi hinh anh sau khi hoan doi vi tri              |\n|4. Nhap tu ban phim ki tu mau cho chu D, C, E roi hien thi|\n|(Nhap exit de thoat chuong trinh)                         |\n============================================================\n\n\n"
	Message: .asciiz "\nNhap 3 ky tu tuong ung voi 3 mau moi lan luot cua D,C,E\n\n\n"
	Error: .asciiz "\nSo khong phu hop, Xin nhap lai!\n"
	newline: .asciiz "\n"
	
.text
main:
 la $a0, Menu
 li $v0, 4
 syscall
 
 li $v0, 5
 syscall
 
 case1:
 	addi $v1, $0, 1
 	bne $v0, $v1, case2
 	j c1
 case2:
 	addi $v1, $0, 2
 	bne $v0, $v1, case3
 	j c2
 case3:
 	addi $v1, $0, 3
 	bne $v0, $v1, case4
 	j c3
 case4:
 	addi $v1, $0, 4
 	bne $v0, $v1, case5
 	j c4
 case5:
 	addi $v1, $0, 5
 	bne $v0, $v1, default
 	j Exit
 default:
 	j main
	
#------------------------------------------
 c1:
 	li $v0, 4
 	la $a0, String
 	syscall
 	j main
#-------------------------------------------
 c2:
 	la $s0, String # luu dia chi co so cua String
 	li $s1, 0	# con tro cua String
 loop2:
 	beq $s1, 1024, main # Ket thuc khi in du ky tu
 	lb $t0, 0($s0)	     # $t0 luu gia tri phan tu trong String
 	bgt $t0, 57, print2
 	bgt $t0, 47, digit2  # Neu la 0->9 (ma ascii 48->57) thi thay so bang ky tu space (32)
 	j print2
 digit2:
 	li $t0, 32
 print2:
 	li $v0, 11          # In tung ky tu
 	move $a0, $t0
 	syscall
 	addi $s0, $s0, 1    # Tang dia chi String
 	addi $s1, $s1, 1    #Tang gia tri con tro
 	j loop2
#------------------------------------------
 c3:
 	la $s0, String
 	li $s2, -1       # Luu tung do cua con tro vao $s2
 loop3j:
 	addi $s2, $s2, 1
 	beq $s2, 16, main   # Ket thuc khi duyet du 16 dong
 	sll $s1, $s2, 6	     # $s1 = $s2*64
 	add $s1, $s1, $s0   # $s1 la dia chi dau moi dong cua hinh ve
 	
 	# In E
 	addi $s3, $s1, 42   # Chu E bat dau tu ky tu 42 tren dong
 	jal print21char
 	
 	# In C
 	addi $s3, $s1, 21   # Chu C bat dau tu ky tu 21 tren dong
 	jal print21char
 	
 	# In D
 	addi $s3, $s1, 0    # Chu D bat dau tu dau dong
 	jal print21char
 	
 	# In \n
 	lb $t0, 63($s1)
 	li $v0, 11         # In ky tu
 	move $a0, $t0
 	syscall
 	
 	j loop3j
 
 # Ham in 21 ky tu
 print21char:
 	li $t4, 0
 	loop3i:
 		lb $t0, 0($s3)   # $t0 luu gia tri phan tu trong String
 		li $v0, 11       # In ky tu
 		move $a0, $t0
 		syscall
 		
 		addi $s3, $s3, 1 # $s3 ++
 		addi $t4, $t4, 1 # $t4 ++
 		bne $t4, 21, loop3i
 		jr $ra
#----------------------------------------
 c4:
  Input:
  	li $v0, 4
  	la $a0, Message
  	syscall
  	
  	li $v0, 12
  	syscall
  	
  	bgt $v0, 57, error
  	blt $v0, 48, error
  	addi $t7, $v0, 0  # $t7 chua mau chu D
  	
  	li $v0, 12
  	syscall
  	
  	bgt $v0, 57, error
  	blt $v0, 48, error
  	addi $t8, $v0, 0  # $t8 chua mau chu C
  	
  	li $v0, 12
  	syscall
  	
  	bgt $v0, 57, error
  	blt $v0, 48, error
  	addi $t9, $v0, 0  # $t9 chua mau chu E
  	j Inputend
  	
  error:
  	la $a0, Error
  	li $v0, 4
  	syscall
  	j Input
  	
  Inputend:
  	la $a0, newline
  	li $v0, 4
  	syscall
  	la $s0, String
  	li $s2, -1  # $s2 la tung do con tro
  loop4j:
  	addi $s2, $s2, 1
  	beq $s2, 16, main # Ket thuc khi duyet du 16 dong
  	sll $s1, $s2, 6   # $s1 = $s2 * 64
  	add $s1, $s1, $s0 # $s1 la dia chi dau moi dong cua hinh ve
  	
  	addi $s3, $s1, 0  # Chu D bat dau tu dau dong
  	move $t6, $t7
  	jal print21charc4
  	
  	addi $s3, $s1, 21 # Chu C bat dau tu ky tu 21 tren dong
  	move $t6, $t8
  	jal print21charc4
  	
  	addi $s3, $s1, 42 # Chu E bat dau tu ky tu 42 tren dong
  	move $t6, $t9
  	jal print21charc4
  	
  	lb $t0, 63($s1)
  	li $v0, 11        # In ky tu
  	move $a0, $t0
  	syscall
  	j loop4j
  print21charc4:
  	li $t4, 0
   loop4i:
   	lb $t0, 0($s3)         # $t0 luu gia tri phan tu trong String
   	bgt $t0, 57, print4
   	bgt $t0, 47, digit4    # Cac chu so 0 -> 9 co ma ascii 48 -> 57
   	j print4
   digit4:
   	move $t0, $t6          # Doi ky tu ban dau thanh ky tu moi nhap
   print4:
   	li $v0, 11             # In ky tu
   	move $a0, $t0
   	syscall
   	
   	addi $s3, $s3, 1       # $s3 ++
   	addi $t4, $t4, 1       # $t4 ++
   	bne $t4, 21, loop4i
   	jr $ra
 Exit:
	
	
	
	
	
	
	
