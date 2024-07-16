.data 
Message: .asciiz "Nhap chuoi ki tu : "	
Nhaplai: .asciiz "Do dai chuoi ki tu phai chia het cho 8 : "	
Header: .asciiz "     Disk 1                Disk 2                Disk 3 \n --------------        --------------        -------------- \n"
Footer: .asciiz " --------------        --------------        -------------- "
lNormal: .asciiz "|     "
rNormal: .asciiz "     |"
kc: .asciiz "      "	
lSpec: .asciiz "[[ "
rSpec: .asciiz "]]"
input: .space 100 # Bộ đệm lưu chuỗi đầu vào
disk1: .space 100 # Không gian lưu trữ cho Disk 1
disk2: .space 100 # Không gian lưu trữ cho Disk 2
disk3: .space 100 # Không gian lưu trữ cho Disk 3
buffer: .space 100 
.text
# in ra chuoi ki tu Message 
	li $v0, 4
	la $a0, Message 
	syscall
	j type
# doc vao chuoi ki tu dau vao
retype:
	li $v0, 4
	la $a0, Nhaplai
	syscall
	
type:
	li  $v0, 8 
	la  $a0, input
	li  $a1, 100 
	syscall 
#Kiem tra do dai xau ki tu, neu khong chia het cho 8 yeu cau nhap lai
	li $t0, '\n'
	li $t2, 0
loop:
	addi $t2, $t2, 1
	lb $t1, 0($a0)
	addi $a0, $a0, 1
	bne $t0, $t1, loop
	addi $t2, $t2, -1

	srl $t0, $t2, 3
	sll $t0, $t0, 3
	bne $t0 , $t2,retype
	
#in ra header
header:
	li $v0, 4
	la $a0, Header
	add $a1,$t2,$zero
	syscall
	la $s0 , input
Main:	
	beq $a1, $zero, End
	#load du lieu
	la $s1, disk1
	la $s2, disk2
	la $s3, disk3
	jal save
	#in ra hang 1
	la $t0, disk1
	jal normal
	la $t0, disk2
	jal normal
	la $t0, disk3
	jal spec
	li $t1, '\n'
	li $v0,11
	add $a0, $zero, $t1
	syscall
	addi $s0, $s0, 8
	addi $a1, $a1, -8
	beq $a1, $zero, End
	#load du lieu
	la $s1, disk1
	la $s2, disk3
	la $s3, disk2
	jal save
	#in ra hang 2
	la $t0, disk1
	jal normal
	la $t0, disk2
	jal spec
	la $t0, disk3
	jal normal
	li $t1, '\n'
	li $v0,11
	add $a0, $zero, $t1
	syscall
	
	addi $s0, $s0, 8
	addi $a1, $a1, -8
	beq $a1, $zero, End
	#load du lieu
	la $s1, disk2
	la $s2, disk3
	la $s3, disk1
	jal save
	# in ra hang 3
	la $t0, disk1
	jal spec
	la $t0, disk2
	jal normal
	la $t0, disk3
	jal normal
	li $t1, '\n'
	li $v0,11
	add $a0, $zero, $t1
	syscall
	
	addi $s0, $s0, 8
	addi $a1, $a1, -8
	j Main
# in ra footer
End:
	li $v0, 4
	la $a0, Footer
	syscall
	
	li $v0, 10
	syscall
	
	
save:	
	li $t0, 4
	add $t6, $s0, $zero
	addi $t7, $t6, 4
	
loopS:
	lb $t1, 0($t6)
	lb $t2, 0($t7)
	xor $t3, $t1, $t2
	
	sb $t1, 0($s1)
	sb $t2, 0($s2)
	sb $t3, 0($s3)
	
	addi $t0, $t0, -1
	addi $t6, $t6, 1
	addi $t7, $t7, 1
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	addi $s3, $s3, 1
	bne $t0, $zero, loopS
	jr $ra
	
normal:
	li $v0, 4
	la $a0, lNormal
	syscall
	
	add $a0, $zero, $t0
	syscall
	
	la $a0, rNormal
	syscall
	
	la $a0, kc
	syscall
	
	jr $ra
spec:	
	li $v0, 4
	la $a0, lSpec
	syscall
	
	li $t1, 3
	li $t2, ','
	add $s4, $zero, $ra
loopSpec:
	lb $t3, 0($t0)
	
	jal printHexa
	
	li $v0,11
	add $a0, $zero, $t2
	syscall
	
	addi $t0, $t0, 1
	addi $t1, $t1, -1
	bne $t1,$zero,loopSpec
	
	lb $t3, 0($t0)
	
	jal printHexa
	
	li $v0, 4
	la $a0, rSpec
	syscall
	
	la $a0, kc
	syscall
	
	add $ra, $zero, $s4
	jr $ra
	
	
printHexa:
	srl $t6, $t3, 4
	
	add $s6, $zero, $ra
	jal beauti
	
	
	sll $t6,$t3, 28
	srl $t6, $t6,28
	
	jal beauti
	
	add $ra, $zero, $s6
	jr $ra
beauti:
	slti $s5, $t6, 10
	beq $s5, $zero,skip
	li $v0, 1
	add $a0, $zero, $t6
	syscall
	jr $ra
skip:
	slti $s5,$t6,10
	addi $t6, $t6, 87
	li $v0, 11 
	add $a0, $zero, $t6
	syscall
	jr $ra
