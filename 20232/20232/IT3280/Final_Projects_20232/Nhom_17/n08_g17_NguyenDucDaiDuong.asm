.data
	mes: .asciiz "Nhap xau: "
	disk1: .space 4
	disk2: .space 4
	disk3: .space 4
	array: .space 32
	str: .space 1000
	error: .asciiz "Do dai xau khong hop le!\n"
	comma: .asciiz ","
	enter: .asciiz "\n"
	hex: .byte '0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'
	#hex[0] = 0,..., hex[15] = f
	r1: .asciiz "     Disk 1                 Disk 2                 Disk 3\n"
	r2: .asciiz "----------------       ----------------       ----------------\n"
	r3: .asciiz "|     "
	r4: .asciiz "     |       "
	r5: .asciiz "[[ "
	r6: .asciiz "]]       "
	try: .asciiz "Ban muon tiep tuc?"


	
	
.text
	la $s1, disk1 #luu dia chi disk1
	la $s2, disk2
	la $s3, disk3
	la $a2, array	#luu dia chi mang parity
input:
	li $v0, 4
	la $a0, mes
	syscall		#in ra mes
	li $v0, 8
	la $a0, str	#nhap vao xau
	li $a1, 1000
	syscall
	move $s0, $a0	#luu dia chi xau vao $S0

#Kiem tra do dai xau co chia het cho 8
length: 
	addi $t0, $zero, 0	#$t0 = length
	addi $t1, $zero, 0 	#$t1 = index
	
count:
	add $t2, $s0, $t1	#luu dia chi cua str[i] vao t2
	lb $t3, 0($t2)		# t3 = str[i]
	nop
	beq $t3, '\n', test	#gap ki tu xuong dong thi nhay xuong nhan test
	
	add $t0, $t0, 1		#neu khong thi tang length len 1
	add $t1, $t1, 1		# tang index len 1
	j count
	
test:
	li $t5, 8
	move $t4, $t0
	beq $t4, 0, not_avai 	#xau rong khong hop le
	div $t4, $t5	#chia length cho 8
	mfhi $t2	#luu phan du vao $t2
	beqz $t2, avai	#du bang 0 thi hop le
not_avai:	
	li $v0, 4
	la $a0, error
	syscall	
	j input
	
avai:
	j main	

#---------------Chuong trinh con lay ma hexa (parity)--------
parity:
    li $t9, 1            # khoi tao $t9 = 1

loopParity:
    blt $t9, $0, endParity  # Neu $t9 < 0 thi nhay den endParity
    sll $s7, $t9, 2         # $s7 = $t9 << 2 ($s7 = $t9 * 4)
    srlv $a0, $t8, $s7      # $a0 = $t8 >> $s7 (dich phai $t8 theo $s7 bits)
    andi $a0, $a0, 0x0000000f  # $a0 = $a0 & 0x0000000f ( lay byte cuoi cua $s0 lam so hexa)
    la $t7, hex            # $t7 = dia chi cua mang hex ( mang cac chu so hexa)
    add $t7, $t7, $a0       # $t7 = $t7 + $a0 (dia chi cua chu so hexa can lay)
    lb $a0, 0($t7)          # $a0 = *(char*)($t7 + 0) (lay chu so hexa tu bo nho va dat vao $a0)
    li $v0, 11              # in ra ky tu
    syscall
    add $t9, $t9, -1        # $t9 = $t9 - 1 
    j loopParity            # lap lai loopParity

endParity:
    jr $ra                  # Trả về từ hàm

#------------Ket thuc chuong trinh con-------------------------

#Chuong trinh chinh
main:
	li $v0, 4
	la $a0, r1
	syscall
	li $v0, 4
	la $a0, r2
	syscall
#Xet 6 lan

#----Lan 1 luu block 4 byte vao Disk1, 4 byte tiep vào Disk2, parity vao Disk3
#xu li ki tu
part1:
	addi $t1, $zero, 0       # bo dem vong lap cho 4 ki tu dau
	addi $t5, $zero, 0       # bo dem de in ra Disk1 lan 1
	addi $t8, $zero, 0       # bo dem de in ra Disk2 lan 1
	la $s1, disk1            # luu dia chi cua Disk1 vao $s1
	la $s2, disk2            # luu dia chi cua Disk2 vao $s2
	la $a2, array            # luu dia chi cua array vao $a2
part1_1:
	lb $t2, ($s0)      # luu byte tai dia chi $s0 vào $t2
	addi $t0, $t0, -1  # giam $t0 đi 1
	sb $t2, ($s1)      # luu gia tri cua $t2 vao dia chi $s1 (Disk1)
part1_2:
	addi $s4, $s0, 4   # tang dia chi $s0 len 4 va luu vao $s4
	lb $t3, ($s4)      # luu byte tai dia chi $s4 vào $t3
	addi $t0, $t0, -1  # giam $t0 đi 1
	sb $t3, ($s2)      # luu gia tri cua $t3 vao dia chi $s2 (Disk2)
part1_3:
	xor $a3, $t2, $t3  # OR hai ky tu trong $t2 va $t3 luu vao $a3
	sb $a3, ($a2)      # Luu gia tri cua $a3 vao dia chi $a2 (array)
	addi $a2, $a2, 4   
	addi $t1, $t1, 1   
	addi $s0, $s0, 1   
	addi $s1, $s1, 1   
	addi $s2, $s2, 1   
	bgt $t1, 3, clear1 
	j part1_1           
clear1: 
	la $s1, disk1     
	la $s2, disk2      
	
#in ki tu tu Disk1
	li $v0, 4          #in dinh dang
	la $a0, r3         
	syscall            

printPart1Disk1:
	lb $a0, ($s1)      
	li $v0, 11         
	syscall            
	addi $t5, $t5, 1   
	addi $s1, $s1, 1   
	bgt $t5, 3, print1_1 
	j printPart1Disk1  

print1_1:
	li $v0, 4          #in dinh dang
	la $a0, r4         
	syscall            

#in ki tu tu Disk2
	li $v0, 4          
	la $a0, r3         
	syscall           

printPart1Disk2:
	lb $a0, ($s2)      
	li $v0, 11         
	syscall            
	addi $t8, $t8, 1   
	addi $s2, $s2, 1   
	bgt $t8, 3, print1_2 
	j printPart1Disk2  

print1_2: 
	li $v0, 4          
	la $a0, r4        
	syscall            

	
#in parity tu Disk 3
	li $v0, 4
	la $a0, r5
	syscall
	la $a2, array
	addi $t5, $zero, 0

printPart1Disk3:
	lb $t8, ($a2)      #Tai word tai dia chi $a2 vao $t8
	jal parity         # Goi ham con parity de in ra ma parity 
	li $v0, 4          
	la $a0, comma      
	syscall            
	addi $t5, $t5, 1   #in 3 parity co dau phay
	addi $a2, $a2, 4   
	bgt $t5, 2, end1   
	j printPart1Disk3  
	
end1:				#in parity cuoi
	lb $t8, ($a2)      
	jal parity         
	li $v0, 4          
	la $a0, r6         
	syscall            
	li $v0, 4          
	la $a0, enter      
	syscall            
	beq $t0, 0, exit1  

#----Lan 2 luu block 4 byte vao Disk1, 4 byte tiep vào Disk3, parity vao Disk2
#xu li ki tu
part2:
	la $s1, disk1            
	la $s3, disk3           
	la $a2, array            
	addi $s0, $s0, 4
	addi $t1, $zero, 0

part2_1:
	lb $t2, ($s0)      # luu byte tai dia chi $s0 vào $t2
	addi $t0, $t0, -1  # giam $t0 đi 1
	sb $t2, ($s1)      # luu gia tri cua $t2 vao dia chi $s1 (Disk1)
part2_2:
	addi $s4, $s0, 4   # tang dia chi $s0 len 4 va luu vao $s4
	lb $t3, ($s4)      # luu byte tai dia chi $s4 vào $t3
	addi $t0, $t0, -1  # giam $t0 đi 1
	sb $t3, ($s3)      # luu gia tri cua $t3 vao dia chi $s2 (Disk3)
part2_3:
	xor $a3, $t2, $t3  
	sb $a3, ($a2)      
	addi $a2, $a2, 4   
	addi $t1, $t1, 1  
	addi $s0, $s0, 1  
	addi $s1, $s1, 1  
	addi $s3, $s3, 1   
	bgt $t1, 3, clear2 
	j part2_1           
clear2: 
	la $s1, disk1      
	la $s3, disk3      
	addi $t5, $zero, 0
	
#in ki tu Disk1
	li $v0, 4          
	la $a0, r3         
	syscall          

printPart2Disk1:
	lb $a0, ($s1)      
	li $v0, 11        
	syscall            
	addi $t5, $t5, 1  
	addi $s1, $s1, 1   
	bgt $t5, 3, print2_1 
	j printPart2Disk1 

print2_1:
	li $v0, 4         
	la $a0, r4         
	syscall            


#in parity tu Disk2
	la $a2, array
	addi $t5, $zero, 0
	li $v0, 4           
	la $a0, r5         
	syscall            
	
printPart2Disk2:
	lb $t8, ($a2)      
	jal parity         
	li $v0, 4          
	la $a0, comma      
	syscall            
	addi $t5, $t5, 1   
	addi $a2, $a2, 4   
	bgt $t5, 2, continue2   
	j printPart2Disk2  
	
continue2: 
	lb $t8, ($a2)      
	jal parity         
	li $v0, 4         
	la $a0, r6         
	syscall            
	addi $t8, $zero, 0
	
#in ki tu tu Disk3
	li $v0, 4
	la $a0, r3
	syscall
	
printPart2Disk3:
	lb $a0, ($s3)      
	li $v0, 11        
	syscall         
	addi $t8, $t8, 1   
	addi $s3, $s3, 1   
	bgt $t8, 3, end2   
	j printPart2Disk3  
	
end2:
	li $v0, 4
	la $a0, r4
	syscall
	li $v0, 4
	la $a0, enter
	syscall
	beq $t0, 0, exit1

#----Lan 3 luu block 4 byte vao Disk2, 4 byte tiep vào Disk3, parity vao Disk1
#xu li ki tu
part3:
	la $s2, disk2           
	la $s3, disk3            
	la $a2, array          
	addi $s0, $s0, 4
	addi $t1, $zero, 0

part3_1:
	lb $t2, ($s0)      # luu byte tai dia chi $s0 vào $t2
	addi $t0, $t0, -1  # giam $t0 đi 1
	sb $t2, ($s2)      # luu gia tri cua $t2 vao dia chi $s1 (Disk2)
part3_2:
	addi $s4, $s0, 4   # tang dia chi $s0 len 4 va luu vao $s4
	lb $t3, ($s4)      # luu byte tai dia chi $s4 vào $t3
	addi $t0, $t0, -1  # giam $t0 đi 1
	sb $t3, ($s3)      # luu gia tri cua $t3 vao dia chi $s2 (Disk3)
part3_3:
	xor $a3, $t2, $t3  
	sb $a3, ($a2)      
	addi $a2, $a2, 4   
	addi $t1, $t1, 1   
	addi $s0, $s0, 1   
	addi $s2, $s2, 1  
	addi $s3, $s3, 1   
	bgt $t1, 3, clear3 
	j part3_1         
clear3: 
	la $s2, disk2    
	la $s3, disk3   
	addi $t5, $zero, 0
#in parity Disk1
	li $v0, 4          
	la $a0, r5       
	syscall           

printPart3Disk1:
	lb $t8, ($a2)
	jal parity		# In ma parity
	li $v0, 4
	la $a0, comma
	syscall
	addi $t5, $t5, 1
	addi $a2, $a2, 4
	bgt $t5, 2, continue3	# In 3 ma dau tien
	j printPart3Disk1
	
continue3: 
	lb $t8, ($a2)      
	jal parity         
	li $v0, 4          
	la $a0, r6        
	syscall           
	
#in ki tu tu Disk 2
	li $v0, 4          
	la $a0, r3     
	syscall            
	
	addi $t5, $zero, 0
	
printPart3Disk2:
	lb $a0, ($s2)		
	li $v0, 11
	syscall			
	addi $t5, $t5, 1
	addi $s2, $s2, 1
	bgt $t5, 3, print3_1
	j printPart3Disk2
	
#In ki tu tu Disk3
print3_1:	
	li $v0, 4
	la $a0, r4
	syscall			
	li $v0, 4
	la $a0, r3
	syscall	

	addi $t5, $zero, 0
printPart3Disk3:
	lb $a0, ($s3)      
	li $v0, 11        
	syscall            
	addi $t5, $t5, 1   
	addi $s3, $s3, 1   
	bgt $t5, 3, end3   
	j printPart3Disk3  
	
end3:
	li $v0, 4
	la $a0, r4
	syscall
	li $v0, 4
	la $a0, enter
	syscall
	beq $t0, 0, exit1
#-----Het mot luot-----
#-----Cac luot tiep theo-----
nextPart:
	addi $s0, $s0, 4
	j part1

exit1:	
	li $v0, 4
	la $a0, r2
	syscall
	j ask
#----hoi co tiep tuc nhap xau moi khong-----
ask:	
	li $v0, 50
	la $a0, try
	syscall
	beq $a0, 0, clear
	j exit

# dua string ve trang thai ban dau de thuc hien lai qua trinh
clear:	la $s0, str
	li $t2, 0
goAgain: 
	sb $t2, ($s0)		# set byte o dia chi str ve 0
	addi $s0, $s0, 1
	bge $s0, $t4, input
	
	j goAgain
	
#-----------------------------------------end-------------------------------------#

exit:	li $v0, 10
	syscall

