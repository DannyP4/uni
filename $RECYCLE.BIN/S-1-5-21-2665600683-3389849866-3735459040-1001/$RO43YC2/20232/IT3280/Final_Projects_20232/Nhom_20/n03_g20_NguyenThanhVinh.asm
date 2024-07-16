.eqv SEVENSEG_LEFT 0xFFFF0011 		#dia chi led 7 doan trai
.eqv SEVENSEG_RIGHT 0xFFFF0010 		#dia chi led 7 doan phai
.eqv MASK_CAUSE_COUNTER 0x00000400 	#Bit 10: Counter interrupt
.eqv COUNTER 0xFFFF0013 		#Time Counter
.eqv KEY_CODE   0xFFFF0004         	# ASCII code from keyboard, 1 byte 
.eqv KEY_READY  0xFFFF0000        	# =1 if has a new keycode ? 
                                 	# Auto clear after lw  
.data
arr: .byte 	63, 6,  91, 79, 102, 109 ,125, 7, 127, 111	 #tu 0 den 9 de doi sang lam den led sang
str: .asciiz "bo mon ky thuat may tinh"
msg1: .asciiz "thoi gian hoan thanh : "
msg2: .asciiz " (s)\nso tu tren mot don vi thoi gian : "
msg3: .asciiz " tu/phut\n"
null: .asciiz "\n"
 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
# MAIN Procedure 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 

.text

main:
	li $k0,KEY_CODE
	li $k1,KEY_READY
	# Enable the interrupt of TimeCounter of Digital Lab Sim 
        li    $t1,   COUNTER    
        sb    $t1,   0($t1)
        addi $s0,$zero,0 # $s0 dem so ky tu nhap vao
        addi $s1,$zero,0 # $s1 dem tong so ky tu dung
        addi $s2,$zero,0 # dem so lan ngat 
        addi $s3,$zero,0 # dem thoi gian
        la $a1, str
        la $a2, null
        lb $t7,0($a2)
        #--------------------------------------------------------- 
        # nhap dau vao 
        #---------------------------------------------------------   

loop:
	lw $t1,0($k1)		# $t1 = [$k1] = KEY_READY 
	bne $t1,0,MakeIntR	# $t1 != 0 hay co phim duoc nhap thi chuyen den MakeIntR
	li $v0,32		# BUG: must sleep to wait for Time
	li $a0,5		# sleep 5ms
	syscall
	j loop 
	
MakeIntR: 
	teqi $t1,1		# neu $t1=1 co phim duoc nhap thi chuyen den chuong trinh ngat
	j loop			# quay lai vong lap de nhap ki tu moi


 
#--------------------------------------------------------------- 
# Interrupt subroutine 
#---------------------------------------------------------------

.ktext 0x80000180                 
IntSR:  #-------------------------------------------------------- 
        # Temporary disable interrupt 
        #--------------------------------------------------------   

dis_int:li    $t1,   COUNTER   # BUG: must disable with Time Counter 
        sb    $zero,   0($t1) 
        #-------------------------------------------------------- 
        # Processing 
        #-------------------------------------------------------- 

# kiem tra ly do ngat

get_caus: 
	mfc0 $t1,$13		# $t1 la ly do ngat

IsCount:
	li $t2, MASK_CAUSE_COUNTER
	and $at,$t2,$t1
	bne $at,$t2,Keyboard_IntR

# ly do ngat la bo dem

Counter_IntR:
	ble $s2,40,demtiep	# neu chua du 1s thi dem tiep
	addi $s2,$zero,0	# tao lai so lan ngat
	addi $s3,$s3,1		# tang len 1s
	j en_int		# nhay den xu ly chuoi
demtiep:
	addi $s2,$s2,1
	j en_int		# nhay den xu ly chuoi

# xu ly chuoi 

Keyboard_IntR:
	lb $t0,0($a1)		# lay ki tu thi i trong doan van ban
	beq $t0,$0,end_program
	lw $t1,0($k0)		# lay ki tu nhap vao tu ban phim
	beq $t1,$t7,end_program	
	bne $t0,$t1,end_process # neu 2 ki tu ko bang nhau thi nhay den end_process
	nop
	addi $s1,$s1,1		# tang so ki tu dung len 1
end_process:
	addi $s0,$s0,1		# tang so ki tu nhap vao len 1
	addi $a1,$a1,1		# tang i 1 don vi trong doan van ban

en_int:	
	 	# Must clear cause reg 
	#--------------------------------------------------------  
        # Re-enable interrupt 
        #--------------------------------------------------------  
        li    $t1,   COUNTER 
        sb    $t1,   0($t1) 
        mtc0  $zero, $13      
        #-------------------------------------------------------- 
        # Evaluate the return address of main routine 
        # epc  <= epc + 4 
        #-------------------------------------------------------- 
next_pc:mfc0    $at, $14        # $at <=  Coproc0.$14 = Coproc0.epc 
        addi    $at, $at, 4     # $at = $at + 4   (next instruction) 
        mtc0    $at, $14        # Coproc0.$14 = Coproc0.epc <= $at   
return: eret                     # Return from exception
#-----------------------------------------------------------------

end_program:
# in ra thoi gian hoan thanh
	 addi	$v0, $0, 4
	 la	$a0, msg1
	 syscall
	 addi	$v0, $0, 1
	 addi	$a0, $s3, 0
	 syscall
	 addi	$v0, $0, 4
	 la	$a0, msg2
	 syscall
# in ra so tu tren 1 don vi thoi gian
	 addi	$v0, $0, 1
	 addi	$a0, $0, 60
	 mult	$s0, $a0	# nhan so ky tu nhap vao voi 60
	 mflo	$s0
	 div	$s0, $s3	# so ky tu trong 1p
	 mflo	$a0
	 syscall
	 addi	$v0, $0, 4
	 la	$a0, msg3
	 syscall
	 addi	$s0, $s1, 0
	 jal	show
end_main:
	li $v0,10
	syscall
	
#-----------------------------------------------------------------
# hien thi ket qua so ky tu dung tren led
show:
	addi $sp,$sp,-4
	sw $ra,0($sp)
	addi $t0,$zero,10
	div $s1,$t0
	mflo $v0		# $v0 = so hang chuc cua so ky tu dung
	mfhi $v1		# $v1 = so hang don vi cua so ky tu dung
	la $a0, arr
	add $a0, $a0, $v0			# $a0 la so de hien thi ra $v0
	lb $a0, 0($a0) 			#Set value for segments
	jal SHOW_7SEG_LEFT 			
	la $a0, arr 
	add $a0, $a0, $v1			# $a0 la so de hien thi ra $v1
	lb $a0, 0($a0) 			#Set value for segments
	jal SHOW_7SEG_RIGHT 		
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
SHOW_7SEG_LEFT: 
	li 	$t0, SEVENSEG_LEFT 		#Assign port's address
	sb 	$a0, 0($t0) 			#Assign new value
	jr 	$ra
SHOW_7SEG_RIGHT: 
	li 	$t0, SEVENSEG_RIGHT 		#Assign port's address
	sb 	$a0, 0($t0) 			#Assign new value
	jr 	$ra
	nop

#------------------------------------------------------------------------  
        
        
