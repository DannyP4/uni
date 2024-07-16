.eqv 	IN_ADDRESS_HEXA_KEYBOARD 	0xFFFF0012
.eqv 	OUT_ADDRESS_HEXA_KEYBOARD 	0xFFFF0014
.eqv 	SEVENSEG_LEFT 	0xFFFF0011 # Dia ch icua  led 7 doan trai.
.eqv 	SEVENSEG_RIGHT 	0xFFFF0010 # Dia chi cua  led 7 doan phai.
.data
 # ma hoa so 0-9 trong digital lab sim
 khong: 	.byte 0x3f
 mot: 		.byte 0x6
 hai: 		.byte 0x5b
 ba: 		.byte 0x4f
 bon: 		.byte 0x66
 nam: 		.byte 0x6d
 sau: 		.byte 0x7d
 bay: 		.byte 0x7
 tam: 		.byte 0x7f
 chin: 		.byte 0x6f
 mess1: .asciiz "Ket qua khong ton tai.Khong the chiacho so 0 \n"
 .text
 
 main:
 
 
 Khoi_tao_Gia_Tri:
 	li $s0,0 #Bien kiem tra xem toan bien nhap vao la so(0) hay toan tu(1)
 	li $s1,0 # gia tri bit cua so hien thi o led phai
 	li $s2,0 # gia tri bit cua so hien thi o led trai
 	li $s3,0 #Bien kiem tra loai toan tu (1: +, 2:-, 3: *,4: /,5:%)
 	li $s4,0 #So thu nhat
 	li $s5,0 #So thu hai
 	li $s6,0 #Ket qua phep tinh: '+','-','*','/','%'
 	li $t9, 0 #Bien luu gia tri tam thoi
 	li $t0,SEVENSEG_LEFT # khoi tao bien gia tri  cua  LED trai
 	li $t5,SEVENSEG_RIGHT #khoi tao bien gia tri  cua  LED phai
 	li $t1, IN_ADDRESS_HEXA_KEYBOARD #bien dieukhien hang keyboard vaenable keyboard interrupt
 	li $t2, OUT_ADDRESS_HEXA_KEYBOARD #bien chuavi tri key nhap vaothe hang va cot
 	li $t3, 0x80 # bit dung enable keyboard interrupt va enable kiem tra tung hang keyboard
 	sb $t3, 0($t1)
 	li $t7, 0 #Gia tri cua so hien tren led
 	li $t4, 0 #byte hien thi len led, zero->nine
Gia_Tri_Ban_dau:
 	li $t7, 0 #Gia tri cua bit can hien thi ban dau(bat dau voi so 0)
 	addi $sp,$sp, 4 #day vao stack
 	sb $t7, 0($sp)
 	lb $t4, khong #bit dau tien can hien thi
 	addi $sp,$sp, 4 #day vao stack
 	sb $t4, 0($sp)
Loop1:
 	nop
 	nop
 	nop
 	nop
 	b  Loop1	 #Wait for interrupt
 end_loop1:
 
 end_main:
	 li $v0, 10
 	 syscall
 #-------------------------------------------------------------
# Xu ly khi xay ra interupt
 # Hien thi so vua bam len den led 7 doan
 # Kiem tra tung hang xem co duoc bam hay khong
 #-------------------------------------------------------------
.ktext 0x80000180
 #-------------------------------------------------------------
# Processing
 # Neu hang co phim duoc nhap-> chuyen toi hang do
 #-------------------------------------------------------------
	jal  hang1  #Kiem tra hang 1 xem co phim nao duoc nhap hay khong
 	bnez  $t3, checkhang1  #t3 != 0-> co phim duoc nhap, kiem tra cac phim trong hang, lay phim do ra
 	nop
 	jal  hang2  #Kiem tra hang 2 xem co phim nao duoc nhap hay khong
 	bnez  $t3, checkhang2  #t3 != 0-> co phim duoc nhap, kiem tra cac phim trong hang, lay phim do ra
 	nop
 	jal  hang3  #Kiem tra hang 3 xem co phim nao duoc nhap hay khong
 	bnez  $t3, checkhang3  #t3 != 0-> co phim duoc nhap, kiem tra cac phim trong hang, lay phim do ra
 	nop
 	jal  hang4  #Kiem tra hang 4 xem co phim nao duoc nhap hay khong
 	bnez  $t3, checkhang4 #t4 != 0-> co phim duoc nhap, kiem tra cac phim trong hang, lay phim do ra	
 #------------------------------------------------------
#Kiem tra xem phim nao duoc nhan trong 4 hang
 #------------------------------------------------------
hang1:
 	addi $sp,$sp,4 # tang dia chi stack
 	sw $ra,0($sp) # luu dia chi ra
 	li $t3,0x81  #Kich hoat interrupt,  bam phim o hang 2
 	sb $t3,0($t1)
 	lb  $t3, 0($t2)  #load vi tri phim duoc nhap
 	lw $ra,0($sp)
 	addi $sp,$sp,-4
 	jr $ra
hang2:
 	addi $sp, $sp, 4 # tang dia chi stack
 	sw  $ra, 0($sp) #luu dia chi ra
 	li  $t3, 0x82  #Kich hoat interrupt,  bam phim o hang 2
 	sb  $t3, 0($t1) 
 	lb  $t3, 0($t2)  #load vi tri phim duoc nhap
 	lw  $ra, 0($sp)
 	addi  $sp, $sp,-4
 	jr  $ra
hang3:
 	addi $sp, $sp, 4  # tang dia chi stack
 	sw $ra, 0($sp)  #luu dia chi ra
 	li  $t3, 0x84  #Kich hoat interrupt,  bam phim o hang 3
 	sb  $t3, 0($t1)
 	lb  $t3, 0($t2)  #load vi tri phim duoc nhap
 	lw  $ra, 0($sp)
 	addi  $sp, $sp,-4
 	jr  $ra
hang4:
 	addi  $sp, $sp, 4 # tang dia chi stack
 	sw  $ra, 0($sp) #luu dia chi ra
 	li   $t3, 0x88 #Kich hoat interrupt, cho phep bam phim o hang 4
 	sb  $t3, 0($t1)
 	lb  $t3, 0($t2)  #load vi tri phim duoc nhap
 	lw  $ra, 0($sp)
 	addi  $sp, $sp,-4
 	jr  $ra
#-----------------------------------------
#Convert tu vi tri sang bit
#-----------------------------------------
#-----------------------------------------
# hang 1: co 4 gia tri: 0, 1, 2, 3
#Ma hoa tuong ung la: 
# 0: .byte 0x3f
# 1: .byte 0x6
# 2: .byte 0x5b
# 3: .byte 0x4f
#----------------------------------------
checkhang1:
 	beq $t3,0x11, so0 # 0x11->so 0
 	beq $t3,0x21, so1 # 0x21->so 1
 	beq $t3,0x41, so2 # 0x41->so 2
 	beq $t3,0xffffff81, so3 # 0xffffff81-> so 3
so0:	
 	lb $t4,khong #t4 = so 0(Ma hoa cua '0'tren DigitalLab Sim)
 	li $t7,0 #t7= 0
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so1:	
 	lb $t4,mot #t4 = so 1(Ma hoa cua '1'tren DigitalLab Sim)
 	li $t7,1 #t7 = 1
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so2:	
 	lb $t4,hai #t4 = so 2(Ma hoa cua '2'tren DigitalLab Sim)
 	li $t7,2 #t7 = 2
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so3:	
 	lb $t4,ba #t4 = so 3 (Ma hoa cua '3'tren DigitalLab Sim)
 	li $t7,3 #t7 = 3
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done
 #-----------------------------------------
# hang 2: co 4 gia tri: 4, 5, 6, 7
 #Ma hoa tuong ung la: 
 # 4: .byte 0x66
 # 5: .byte 0x6d
 # 6: .byte 0x7d
 # 7: .byte 0x7
 #----------------------------------------
checkhang2:
 	beq $t3,0x12, so4 # 0x12->so 4
 	beq $t3,0x22, so5 # 0x22->so 5
 	beq $t3,0x42, so6 # 0x42->so 6
 	beq $t3,0xffffff82, so7 # 0xffffff82-> so 7
so4:	
 	lb $t4, bon #t4 = so 4(Ma hoa cua '4'tren DigitalLab Sim)
 	li $t7, 4 #t7= 4
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so5:	
 	lb $t4, nam #t4 = so 5(Ma hoa cua '5'tren DigitalLab Sim)
 	li $t7, 5 #t7 = 5
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so6:	
 	lb $t4, sau #t4 = so 6(Ma hoa cua '6'tren DigitalLab Sim)
 	li $t7,6 #t7 = 6
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so7:	
 	lb $t4, bay #t4 = so 7 (Ma hoa cua '7'tren DigitalLab Sim)
 	li $t7, 7 #t7 = 7
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
 #-----------------------------------------
#hang3: co 4 gia tri:8, 9, a, b
 #Ma hoa tuong ung la: 
 # eight: .byte 0x7f
 # nine: .byte 0x6f
 #----------------------------------------
checkhang3:
 	beq $t3,0x14, so8 # 0x12->so 8
 	beq $t3,0x24, so9 # 0x22->so 9
 	beq $t3,0x44, so_a # 0x42->phim a
 	beq $t3,0xffffff84, so_b # 0xffffff82-> phim b
so8:	
 	lb $t4,tam #t4 = eight (Ma hoa cua '8'tren DigitalLab Sim)
 	li $t7,8 #t7= 8
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
so9:	
 	lb $t4,chin #t4 = nine (Ma hoa cua '9'tren DigitalLab Sim)
 	li $t7,9 #t7 = 9
 	mul  $t9, $t9, 10
 	add  $t9, $t9, $t7
 	j done	
#-----------------------------
#Truong hop phim a (phep cong)
#-----------------------------
so_a:
 	addi $s0,$s0, 1 #s0 = 1-> toan tu duoc nhap vao
 	bne $s3,0, set_next_operator
 	addi $s3,$zero, 1 #s3 = 1-> phep cong
 	j luugiatriSodautien #chuyen denham chuyen 2 byte dang hien tren 2 ledthanh so de tinhtoan
 #----------------------------
#Truong hop phim b (phep tru)
 #---------------------------
so_b:
 	addi $s0,$s0, 1 #s0 = 1-> toan tu duoc nhap vao
 	bne $s3,0, set_next_operator
 	addi $s3,$zero, 2 #s3 = 2-> phep tru
 	j luugiatriSodautien
 #-----------------------------------------
#hang4: co 4 gia tri:c, d, e, f
 #----------------------------------------
checkhang4:
 	beq $t3,0x18, so_c # 0x18->phim c
 	beq $t3,0x28,so_d # 0x28->phim d
 	beq $t3,0x48,so_e # 0x48-> phim e
 	beq $t3,0xffffff88, so_f # 0xffffff88-> phim f
#-----------------------------
#Truong hop phim c (phep nhan)
#-----------------------------
so_c:
 	addi $s0,$s0, 1 #s0 = 1-> toan tu duoc nhap vao
 	bne $s3,0, set_next_operator
 	addi $s3,$zero, 3 #s3 = 3-> phep nhan
	j luugiatriSodautien  #chuyen den ham chuyen 2 byte dang hien tren 2 led thanh so de tinh toan
#----------------------------
#Truong hop phim d (phep chia)
#---------------------------
so_d:
 	addi  $s0, $s0, 1  #s0 = 1-> toan tu duoc nhap vao
 	bne  $s3, 0, set_next_operator
 	addi  $s3, $zero, 4  #s3 = 4-> phep chia lay phan nguyen
 	j  luugiatriSodautien
#----------------------------
#Truong hop phim d (phep chia du)
#---------------------------
so_e:
 	addi  $s0, $s0, 1  #s0 = 1-> toan tu duoc nhap vao
 	bne  $s3, 0, set_next_operator
 	addi  $s3, $zero, 5  #s3 = 4-> phep chia lay phan nguyen
 	j  luugiatriSodautien
#----------------------------
#Truong hop phim f (=)
#---------------------------
so_f:
 	addi $s5, $t9, 0
 	j luugiatriSothuhaiVatinhtoan
#----------------------------------
#Tinh so dau hien thi tren den led
#----------------------------------
luugiatriSodautien:
 	addi  $s4, $t9, 0
 	li  $t9, 0
 	j  done
#------------------------------------------------
#Tinh so thu hai hien thi tren den led trong 2 so
#------------------------------------------------
luugiatriSothuhaiVatinhtoan:
 	beq  $s3, 1, cong  # s3 = 1-> cong
 	beq  $s3, 2, tru  # s3 = 2-> tru
 	beq  $s3, 3, nhan  # s3 = 3-> nhan
 	beq  $s3, 4, chia  # s3 = 4-> chia
 	beq  $s3, 5, chia_du  # s3 = 5-> chia du
cong:
 	add  $s6, $s5, $s4
 	li  $s3, 0
 	li  $t9, 0
	li   $s7, 100
 	div  $s6, $s7
 	mfhi  $s6  #Lay 2 gia tri cuoi cua ket qua
 	j hienketquatrenLed  #Hien thi ket qua tren led
 	nop	
tru:
	sub  $s6, $s4, $s5
 	li  $s3, 0
 	li  $t9, 0
	li $s7,100
	 div $s6,$s7
	 mfhi $s6 #Lay 2 giatri cuoi cua ket qua
	 j hienketquatrenLed #Hien thi ket qua tren led
	 nop
nhan:
	 mul $s6,$s4, $s5
	 li $s3,0
	 li $t9,0
	li $s7,100
 	div $s6,$s7
 	mfhi $s6 #Lay 2 chuso sau cung cuaket qua in ra
 	j hienketquatrenLed #Hien thiket qua tren led
 	nop
chia:
 	beq $s5,0, chia_0 # kiem traxem so chia co phai bang 0 hay khong
	li  $s3, 0 
	 div  $s4, $s5
	 mflo  $s6
	 li  $t9, 0
	 li   $s7, 100
	 div  $s6, $s7
	 mfhi  $s6  #Lay 2 gia tri cuoi cua ket qua
	 j  hienketquatrenLed  #Hien thi ket qua tren led
 	 nop
 chia_du:
 	beq $s5,0, chia_0 # kiem traxem so chia co phai bang 0 hay khong
	 li  $s3, 0 
	 div  $s4, $s5
	 mfhi  $s6
	 li  $t9, 0 
	 li   $s7, 100
	 div  $s6, $s7
	 mfhi  $s6  #Lay 2 gia tri cuoi cua ket qua
	 j  hienketquatrenLed  #Hien thi ket qua tren led
 	 nop
#--------------------------------
# Neu $s5 = 0 in ra: "Khong the chia cho so 0 \n"
#------------------------------
chia_0:
 	li  $v0, 5
 	la  $a0, mess1
 	li  $a1, 0
 	syscall
 	j  reset_led	 
#-------------------------------
#Hien thi ket qua tren den led
#So 'ab'
# Den trai = a = ab div 10
# Den phai = b = ab mod 10
#-------------------------------
hienketquatrenLed:
 	li $t8,10 # Gia tritrung gian = 10
 	div $s6,$t8 # $s6 =a
 	mflo $t7 # $t7 =result
 	jal check #chuyen denham chuyen t7 thanhbit hien thi len led
 	sb $t4,0($t0) # hien thilen led trai
 	addi $sp, $sp, 4
 	sb $t7,0($sp) #day gia tri bit nay vao stack
 	addi $sp,$sp, 4
 	sb $t4,0($sp) #day bit nay vao stack
 	add $s2,$t7, $zero #s1 = gia tri bit led phai
 	mfhi $t7 #t7 = remainder
 	jal check #convert t7thanh bit hien thilen led
 	sb $t4,0($t5) #hien thi len led phai
 	add $sp, $sp, 4
 	sb $t7,0($sp) # day giatri bit nay vaostack
	 add $sp,$sp, 4
	 sb $t4,0($sp) # day bitnay vao stack
	 add $s1,$t7, $zero # s1 = gia tri bit led phai
	 j reset_led # ham resetlai led
check:
	 addi $sp,$sp, 4
	 sw $ra,0($sp)
	 beq $t7,0, check_0 # t7 =0-> Hien thi so0 tren thanh led
	 beq $t7,1, check_1 # t7 = 1-> Hien thi so 1tren thanh led
	 beq $t7,2, check_2 # t7 =2-> Hien thi so2 tren thanh led
	 beq $t7,3, check_3 # t7 =3-> Hien thi so3 tren thanh led
	 beq $t7,4, check_4 # t7 =4-> Hien thi so4 tren thanh led
	 beq $t7,5, check_5 # t7 =5-> Hien thi so5 tren thanh led
	 beq $t7,6, check_6 # t7 =6-> Hien thi so6 tren thanh led
	 beq $t7,7, check_7 # t7 =7-> Hien thi so7 tren thanh led
	 beq $t7,8, check_8 # t7 =8-> Hien thi so8 tren thanh led
	 beq $t7,9, check_9 # t7 =9-> Hien thi so9 tren thanh led
#---------------------------------------------
#Chuyen giatri thanh bit hientren thanh led
#---------------------------------------------
check_0:
	 lb $t4, khong
	 j finish_check
 check_1:
	 lb $t4, mot
	 j finish_check
 check_2:
	 lb $t4, hai
	 j finish_check
 check_3:
	 lb $t4, ba
	 j finish_check
 check_4:
	 lb $t4, bon
	 j finish_check
check_5:
 	lb  $t4, nam
 	j  finish_check
 check_6: 
 	lb  $t4, sau
 	j  finish_check
 check_7:
 	lb  $t4, bay
 	j finish_check
 check_8:
 	lb  $t4, tam
 	j  finish_check
 check_9:
 	lb  $t4, chin
 	j finish_check
 finish_check:
 	lw  $ra, 0($sp)
 	addi  $sp, $sp,-4
 	jr  $ra

#------------------------------------
# Hoan thanh xong 1 so-> reset_led
#------------------------------------
done:
 	beq $s0,1,reset_led # s0 = 1-> toan tu-> chuyen den ham reset led
 	nop
#------------------------------------
#ham hien thi bit len led ben trai
#------------------------------------
Hienledtrai:
 	lb  $t6, 0($sp)  #load bit hien thi led tu stack
 	add  $sp, $sp,-4
 	lb  $t8, 0($sp)  #load gia tri cua bit nay
 	add  $sp, $sp,-4
 	add  $s2, $t8, $zero #s2 = gia tri bit led trai
 	sb  $t6, 0($t0)  # hien thi len led trai
#------------------------------------
#ham hien thi bit len led ben phai
#------------------------------------
Hienledphai:
 	sb  $t4, 0($t5)  # hien thi bit len led phai
 	add  $sp, $sp,4
 	sb  $t7, 0($sp)  #day gia tri bit nay vao stack
 	add  $sp, $sp,4
 	sb  $t4, 0($sp)  #day bit nay vao stack
 	add $s1, $t7, $zero  #s1 = gia tri bit led phai
 	j kethuc
reset_led: 
 	li  $s0, 0  #s0 = 0-> doi nhap so tiep theo trong 2 so
	li  $t8, 0
	 addi   $sp, $sp, 4
 	sb  $t8, 0($sp)
	 lb  $t6, khong
 	addi  $sp, $sp, 4
 	sb  $t6, 0($sp)
kethuc:
 	j  quayve
 	nop
# day bit zero vao stack
#----------------------------------------------------------------
#----------------------------------------------------------------
quayve: add $t9,$t9,$s6
	li $s6,0
 	la  $a3, Loop1
 	mtc0  $a3, $1
 	eret  
set_next_operator:
