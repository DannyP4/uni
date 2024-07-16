# Mars Bot
.eqv HEADING 0xffff8010 # Integer: An angle between 0 and 359
.eqv MOVING 0xffff8050 # Boolean: whether or not to move
.eqv LEAVETRACK 0xffff8020 # Boolean (0 or non-0): whether or not to leave a track
.eqv WHEREX 0xffff8030 # Integer: Current x-location of MarsBot
.eqv WHEREY 0xffff8040 # Integer: Current y-location of MarsBot
#Key Matrix
.eqv IN_ADDRESS_HEXA_KEYBOARD 0xFFFF0012
.eqv OUT_ADDRESS_HEXA_KEYBOARD 0xFFFF0014

.data
# postscript DCE
postscript0: .word 90,0,3000,180,0,6000,180,1,13750,80,1,1200,70,1,1200,60,1,1200,50,1,1200,40,1,1200,30,1,1200,20,1,1200,10,1,1200,0,1,1200,350,1,1200,340,1,1200,330,1,1200,320,1,1200,310,1,1200,300,1,1200,290,1,1200,280,1,1150,90,0,14000,260,1,1200,250,1,1200,240,1,1200,230,1,1200,220,1,1200,210,1,1200,200,1,1200,190,1,1200,180,1,1200,170,1,1200,160,1,1200,150,1,1200,140,1,1200,130,1,1200,120,1,1200,110,1,1200,100,1,1200,90,0,4000,90,1,5000,270,0,5000,0,1,7000,90,1,5000,270,0,5000,0,1,7000,90,1,5000,0,0,3000
end0: .word
# postscript PTT
postscript4: .word 90,0,3000,180,0,6000,180,1,13750,0,0,13750,90,1,750,100,1,750,110,1,750,120,1,750,130,1,750,140,1,750,150,1,750,160,1,750,170,1,750,180,1,750,190,1,750,200,1,750,210,1,750,220,1,750,230,1,750,240,1,750,250,1,750,260,1,750,270,1,750,180,0,500,0,0,9000,90,0,6000,90,1,10000,270,0,5000,180,1,13000,0,0,13000,90,0,7000,90,1,10000,270,0,5000,180,1,13000,90,0,2000
end4: .word
# postscript hcn hcn hv
postscript8: .word 90,0,6000,180,0,3000,260,1,500,250,1,500,240,1,500,230,1,500,220,1,500,210,1,500,200,1,500,190,1,500,180,1,500,170,1,500,160,1,500,150,1,500,140,1,500,130,1,500,120,1,500,110,1,500,100,1,500,90,1,500,80,1,500,70,1,500,60,1,500,50,1,500,40,1,500,30,1,500,20,1,500,10,1,500,0,1,500,350,1,500,340,1,500,330,1,500,320,1,500,310,1,500,300,1,500,290,1,500,280,1,500,270,1,500,90,0,9000,270,1,1500,240,1,1500,210,1,1500,180,1,1500,150,1,1500,120,1,1500,90,1,1500,60,1,1500,30,1,1500,0,1,1500,330,1,1500,300,1,1500,90,0,6000,90,1,5000,180,1,5000,270,1,5000,0,1,5000,0,0,2000
end8: .word
message1 : .asciiz "Vui long nhap 0 de marsbot cat DCE \n"
message2 : .asciiz "Vui long nhap 4 de marsbot cat PTT \n"
message3 : .asciiz "Vui long nhap 8 de marsbot cat hcn,hcn,hv \n"
track1 : .asciiz "Dang Track DCE \n"
track2 : .asciiz "Dang Track PTT \n"
track3 : .asciiz "Dang Track hcn,hcn,hv \n"

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# MAIN Procedure
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.text
main:
#---------------------------------------------------------
# Cho phép ngat
#------------------------------------------------------ 
# 		col 0x1 col 0x2 col 0x4 col 0x8 
# 
# row 0x1	 0	 1	 2	 3 
# 		0x11	 0x21	 0x41	 0x81 
# 
# row 0x2 	4 	5 	6 	7 
# 		0x12 	0x22 	0x42 	0x82 
# 
# row 0x4 	8 	9	 a	 b 
# 	       0x14   0x24	0x44	0x84 
# 
# row 0x8	 c	 d	 e	 f 
# 		0x18	 0x28	 0x48	 0x88 
# 
#------------------------------------------------------ 
#---------------------------------------------------------
#Cho phép ngat cua Bàn phím ma tran 4x4 cua Digital Lab Sim
	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t3, 0x80 # bit 7 = 1 (01000000) thi kich hoat ngat
	sb $t3, 0($t1)
#---------------------------------------------------------
# vong lap vo han
#---------------------------------------------------------
Loop: 
	nop
	nop
	addi $v0, $zero, 32
	li $a0, 200
	syscall
	nop
	nop
	b  Loop
end_main:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Chuong trinh phuc vu ngat chung khi loi xay ra
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
.ktext 0x80000180
#-------------------------------------------------------
# luu cac gia tri vao stack , sau khi thuc hien xong tra lai sau
#-------------------------------------------------------
IntSR: 
	addi $sp,$sp,4 # luu $at vao stack vi sau nay co the du lieu bi thay doi
	sw $at,0($sp)
	addi $sp,$sp,4 # luu $v0 vao stack vi sau nay co the du lieu bi thay doi
	sw $v0,0($sp)
	addi $sp,$sp,4 # luu $a0 vao stack vi sau nay co the du lieu bi thay doi
	sw $a0,0($sp)
	addi $sp,$sp,4 # luu $t1 vao stack vi sau nay co the du lieu bi thay doi
	sw $t1,0($sp)
	addi $sp,$sp,4 # Save $t3 because we may change it later
	sw $t3,0($sp)
#--------------------------------------------------------
# Xu li khi chon phim
#--------------------------------------------------------
get_key:
	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t3, 0x81 # kiem tra hàng 1 và kích hoat lai bit 7
	sb $t3, 0($t1)
	li $t1, OUT_ADDRESS_HEXA_KEYBOARD
	lb $a0, 0($t1)
	bne $a0, 0x0, key_pressed #kiem tra da duoc nhan phim hay chua

	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t3, 0x82 # kiem tra hàng 2 và kích hoat lai bit 7
	sb $t3, 0($t1)
	li $t1, OUT_ADDRESS_HEXA_KEYBOARD
	lb $a0, 0($t1)
	bne $a0, 0x0, key_pressed

	li $t1, IN_ADDRESS_HEXA_KEYBOARD
	li $t3, 0x84 # kiem tra hàng 3 và kích hoat lai bit 7
	sb $t3, 0($t1)
	li $t1, OUT_ADDRESS_HEXA_KEYBOARD
	lb $a0, 0($t1)
	bne $a0, 0x0, key_pressed

key_pressed:
	beq $a0, 0x11, key_0 # 0 is pressed
	beq $a0, 0x12, key_4 # 4 is pressed
	beq $a0, 0x14, key_8 # 8 is pressed
	j end_script
key_0:
	la $a0 ,track1
	li $v0,4
	syscall
	la $a2, postscript0 # luu dia chi cua postscript0 vao a2
	la $a1, end0 # ket thuc luu vao a1
	j MarsBot_Draw
key_4:
	la $a0 ,track2
	li $v0,4
	syscall
	la $a2, postscript4 # luu dia chi cua postscript4 vao a2
	la $a1, end4 # ket thuc luu vao a1
	j MarsBot_Draw
key_8:
	la $a0 ,track3
	li $v0,4
	syscall
	la $a2, postscript8 # luu dia chi cua postscript8 vao a2
	la $a1, end8 # ket thuc luu vao a1
	j MarsBot_Draw

MarsBot_Draw: # Bat dau chay marsbot
read_script: # doc postscript
	beq $a2, $a1, end_script
read_angle:
	lw $a0, 0($a2) # load goc , luu vao heading
	jal ROTATE 
	addi $a2, $a2, 4 # a2 = a2+4 de doc cut or uncut
read_cut_uncut: # cut if 1, uncut if 0
	lw $s0, 0($a2)
	beq $s0, $0, read_duration #s0 = 0 => untrack
	jal TRACK # s0 = 1 =>> track = 1
read_duration:
	jal GO
	addi $a2, $a2, 4 # a2 = a2 + 4
	lw $a0, 0($a2) # load time go
	addi $v0,$zero,32 # go bang cach sleep
	syscall
	jal UNTRACK
	addi $a2, $a2, 4 # a2 = a2 + 4
	j read_script # lap lai cho toi luc het postscript

end_script:
	li $v0,4
	la $a0,message1
	syscall
	li $v0,4
	la $a0,message2
	syscall
	li $v0,4
	la $a0,message3
	syscall
	jal STOP

#--------------------------------------------------------
# sau khi xu ly ngat , tang lai thanh ghi epc len 4 ,  $14 chua dia chi tiep theo
# epc <= epc + 4
#--------------------------------------------------------
next_pc:
	mfc0 $at, $14 # $at <= Coproc0.$14 = Coproc0.epc
	addi $at, $at, 4 # $at = $at + 4 (next instruction)
	mtc0 $at, $14 # Coproc0.$14 = Coproc0.epc <= $at
#--------------------------------------------------------
# tra lai du lieu ban dau
#--------------------------------------------------------
restore:
	lw $t3, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
	lw $t1, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
	lw $a0, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
	lw $v0, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
	lw $at, 0($sp) # Restore the registers from stack
	addi $sp,$sp,-4
return: 
	eret # Quay tro ve chuong trinh chinh

GO: 
	li $at, MOVING # thay doi cong MOVING = 1;
	addi $k0, $zero,1 
	sb $k0, 0($at) # bat dau di chuyen
	jr $ra
STOP: 
	li $at, MOVING # thay doi cong MOVING = 0;
	sb $zero, 0($at) # dung lai
	jr $ra
TRACK: 
	li $at, LEAVETRACK # thay doi cong LEAVETRACK = 1
	addi $k0, $zero,1 # to logic 1,
	sb $k0, 0($at) # bat dau ve
	jr $ra
UNTRACK:
	li $at, LEAVETRACK # thay doi cong LEAVETRACK = 0
	sb $zero, 0($at) # dung ve
	jr $ra
ROTATE: 
	li $at, HEADING # thay doi goc xoay cua robot
	sw $a0, 0($at)
	jr $ra
