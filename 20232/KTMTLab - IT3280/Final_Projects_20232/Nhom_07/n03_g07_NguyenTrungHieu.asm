.eqv SEVENSEG_LEFT    			0xFFFF0011 	# Dia chi cua den led 7 doan trai				 
.eqv SEVENSEG_RIGHT   			0xFFFF0010 	# Dia chi cua den led 7 doan phai 
.eqv IN_ADRESS_HEXA_KEYBOARD       	0xFFFF0012  
.eqv OUT_ADRESS_HEXA_KEYBOARD      	0xFFFF0014	
.eqv KEY_CODE   			0xFFFF0004      # ASCII code from keyboard, 1 byte 
.eqv KEY_READY  			0xFFFF0000      # =1 if has a new keycode ?                                  
.eqv MASK_CAUSE_KEYBOARD   		0x0000034     	# Keyboard Cause    
  
.data 
num_for_led: 	.byte 63,6,91,79,102,109,125,7,127,111
String_space : 	.space 1000			#khoang trong de luu cac ky tu nhap tu ban phim.
stringsource : 	.asciiz "bo mon ky thuat may tinh" 
Mess1: 		.asciiz "\n So ky tu nhap trong 1s la :  "
Mess2: 		.asciiz  "\n So ky tu dung la: "  
Mess3: 		.asciiz "\n Ban co muon chay lai chuong trinh? "
Mess4: 		.asciiz "\n Thoi gian nhap la:  "
Mess5: 		.asciiz "\n Toc do go trung binh la(ky tu/1s): "
Mess6: 		.asciiz "\n Vui long nhap ky tu!!!!!!"
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
# MAIN
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ 
.text
	li   $k0,  KEY_CODE              
	li   $k1,  KEY_READY                    
Main:         
	li $s2,0 			# s2 = so ky tu nhap vao
  	li $s3,0			# s3 = so vong lap da thuc hien (max = 200 ~ 1s) 
 	li $s4,10				
  	li $s5,200			# s5 = max vong lap 
	li $s6,0			# s6 = so ky tu nhap duoc trong 1s
	li $s7,0 			#Bien danh dau het chuong trinh
	li $a1,0			# a1 = thoi gian go
Loop:          
WAIT_FOR_KEY:  
 	lw   $t1, 0($k1)               # $t1 = [$k1] = KEY_READY              
	beq  $t1, $zero,Check          # if $t1 == 0 then Polling             
MAKE_INTER:
	addi $s6,$s6,1    		#Tang bien dem ky tu nhap duoc trong 1s len 1
	teqi $t1, 1                       # if $t1= 1 then raise an Interrupt 
#---------------------------------------------------------         
# Dem so ky tu go duoc trong 1s
#---------------------------------------------------------	
Check:          
	#Neu chua du 200 vong lap(1s) thi sleep.
	addi    $s3, $s3, 1      	# Tang so vong lap len 1
	div $s3,$s5			#Lay so vong lap chia cho 200 de xac dinh da duoc 1s hay chua
	mfhi $t2			#Luu phan du cua phep chia tren
	bnez $t2,Sleep			#Neu chua duoc 1s nhay den Sleep
	
	#Neu da duoc 1s thi nhay den nhan SetCount de thuc hien in ra man hinh
	#beqz $s2,SetCount
	addi $a1,$a1,1			#Tang thoi gian go len 1s
#=======================================================================================
# DA DU 1s (in ra so ky tu da nhap trong 1s o run I/O va LED 7 thanh)
#=======================================================================================
SetCount:
	li $s3,0			#Tao lai so vong lap cho 1s tiep
	li $v0,4			#In Mess1 : so ky tu trong 1s:
	la $a0,Mess1
	syscall	
	li    $v0,1            		#In ra so ky tu trong 1s
	add   $a0,$zero,$s6    		
	syscall
DISPLAY_DIGITAL: 
	div $s6,$s4			#Lay so ky tu nhap duoc trong 1s chia cho 10
	mflo $t2			#Lay phan nguyen de hien thi o Led trai
	la $t3,num_for_led		#Lay dia chi num_for_led
	add $t3,$t3,$t2			# Chi toi dia chi gia tri can hien thi
	lb $a0,0($t3)                 	#Lay gia tri cho vao $a0           
	jal   SHOW_7SEG_LEFT       	#Hien thi Led trai
#---------------------------------------------------------------------------------------
	mfhi $t2			#Lay phan du de hien thi o Led phai
	la $t3,num_for_led		#Lay dia chi num_for_led
	add $t3,$t3,$t2			# Chi toi dia chi gia tri can hien thi
	lb $a0,0($t3)                 	#Lay gia tri cho vao $a0           
	jal   SHOW_7SEG_RIGHT       	#Hien thi Led phai
	
	li $s6,0			#Khoi tao lai so ky tu trong 1s cho 1s tiep
	beq $s7,1,Loop_for_another_input
#=======================================================================================
# CHUA DU 1s
#=======================================================================================
Sleep:
	li $v0,32
	li $a0,5			#Sleep 5ms
	syscall
	nop
	j Loop				#Quay lai Loop
#=======================================================================================
# END_MAIN
#=======================================================================================
End_Main:
	li $v0,10
	syscall
	nop
#=========================================================================================
#In ra led 7 thanh
#=========================================================================================	
SHOW_7SEG_LEFT:  
	li   $t0,  SEVENSEG_LEFT 	# assign port's address                   
	sb   $a0,  0($t0)        	# assign new value                    
	jr   $ra
SHOW_7SEG_RIGHT: 
	li   $t0,  SEVENSEG_RIGHT 	# assign port's address                  
	sb   $a0,  0($t0)         	# assign new value                   
	jr   $ra 
#=======================================================================================        
#XU LY NGAT
#=======================================================================================
.ktext	0x80000180			
	mfc0 $t1,$13			#Phan_Nguyen nhan ngat
	li   $t2, MASK_CAUSE_KEYBOARD	#Ngyen nhan ngat do ban phim
	and  $at,$t1,$t2		#So sanh nguyen nhan ngat
	beq  $at,$t2,CountKey		#Neu do ban phim thi nhay den CountKey
	j    End_Inter_Process		#Khong thi nhay den End_Inter_Process
CountKey: 
	lb   $t0, 0($k0)            	# $t0 = [$k0] = KEY_CODE	 
	la $t5,String_space		#Dia chi luu xau duoc nhap
	add $t5,$t5,$s2			#Nhay den dia can ghi cua chi ki vua nhap
	sb $t0,0($t5) 			#Luu ki tu vua nhap
	addi $s2,$s2,1			#Tang so ki tu len 1
	bne $t0,10,End_Inter_Process	#Neu khong phai ky tu la enter nhay den End_Inter_Process
	beq $s2,1,Error			#Neu la xau rong nhay den Error
	bnez $a1,End			#Neu thoi gian hoan thanh >=1 thi nhay den End
	addi $a1,$a1,1			#Neu khong thi lam tron roi nhay
	j End
End_Inter_Process:
NEXT_PC:   
	mfc0 $at, $14	        	# $at <= Coproc0.$14 = Coproc0.epc              	
	addi $at, $at, 4		# $at = $at + 4 (next instruction)              
	mtc0 $at, $14			# Coproc0.$14 = Coproc0.epc <= $at
RETURN:
	eret				#Tro ve lenh tiep theo trong Main
#======================================================================================================	
End:
	li $v0,11         
	li $a0,'\n'         		#In xuong dong
	syscall
	li $t1,0			#Dem so ki tu da xet
	li $t2,0			#Dem so ky tu dung				 
	li $t3,24			#Do dai xau cua ma nguon
	slt $t4,$s2,$t3			#So sanh do dai 2 xau
	#Xau nao nho hon thi duyet theo xau do
	beqz $t4,Check_String		
	add $t3,$zero,$s2		#Gan $t3=so ky tu da nhap de xet
	add $t3,$t3,-1			#Bo qua ky tu enter
Check_String:
	la $t7 String_space		#Lay dia chi xau da nhap
	add $t7,$t7,$t1			#Nhay den dia chi ky tu dang xet
	li $v0,11			#In ra ky tu dang xet
	lb $t4,0($t7)			#Lay ky tu dang xet de in
	add $a0,$zero,$t4
	syscall
	la $t5,stringsource		#Lay dia chi xau nguon
	add $t5,$t5,$t1			#Nhay den dia chi ky tu dang xet
	lb $t6,0($t5)			#Lay ky tu can xet de so sanh
	bne $t4,$t6,Continue		#Neu khac thi nhay den Continue
	add $t2,$t2,1			#Neu giong thi tang bien dem len 1
Continue:
	addi $t1,$t1,1			#Tang bien dem de xet ky tu tiep theo
	beq $t1,$t3,Print		#Neu da duyet het ky tu thi nhay den Print
	j Check_String			#Neu chua thi quay lai check tiep
Print:
	li $v0,4			#In ra Mess2
	la $a0,Mess2
	syscall
	li $v0,1			#In ra so ky tu dung
	add $a0,$zero,$t2
	syscall
	li $v0,4			#In Mess4
	la $a0,Mess4
	syscall
	li $v0,1			#In thoi gian hoan thanh
	add $a0,$zero,$a1
	syscall
	jal So_Ky_Tu_Tren_1s		#Tinh toc do go trung binh
	li $s7,1			#Danh dau ket thuc chuong trinh
	add $s6,$zero,$t2		#Cho $s6=$t2 de hien thi tren led
	b DISPLAY_DIGITAL
Loop_for_another_input:
	li $v0,50			#In Mess3
	la $a0,Mess3
	syscall
	beqz $a0,Main
	b End_Main
Error:
	li $v0,4			#In Mess6 : Vui long nhap ki tu
	la $a0,Mess6
	syscall
	b Main
So_Ky_Tu_Tren_1s:
	li $v0,4			#In Mess5: toc do go trung binh
	la $a0,Mess5
	syscall
	div $s2,$a1			#Lay so ky tu chia cho thoi gian go
	li $t8,0			#Bien dem so chu so sau dau phay
	li $a2,0			#Phan nguyen cua phep chia
Phan_Nguyen:
	mfhi $a3			#Lay phan du de kiem tra
	beqz $a3,Show			#Neu chia het thi in ra man hinh
	mflo $a0			#Neu khac 0 thi xet phan nguyen
Show:
	mflo $a2
	li $v0,1			#In phan nguyen
	add $a0,$zero,$a2
	syscall
	li $v0,11         
	li $a0,'.'         		#In dau '.'
	syscall
Phan_Thap_Phan:
	beq $t8,2,End_Print			#Lay 2 so sau dau phay
	mulo $a3,$a3,$s4		#Nhan phan du truoc voi 10
	div $a3,$a1			#Chia tiep de lay phan thap phan
	mflo $a3			#Lay phan nguyen de in
	li $v0,1			#In ra phan nguyen	
	add $a0,$zero,$a3		
	syscall
	mfhi $a3			#Lay phan du de kiem tra va cho vong lap sau
	beqz $a3,End_Print			#Neu phan du =0 => Ket thuc 
	addi $t8,$t8,1			#Neu khong thi tang bien dem len 1 va lap tiep
	j Phan_Thap_Phan
End_Print:	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
