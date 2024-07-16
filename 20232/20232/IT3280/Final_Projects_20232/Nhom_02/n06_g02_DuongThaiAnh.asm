#================================ Computer Architecture============================
# @Author : Duong Thai Anh
# @StudentID: 20226099
# @Language : Assembly, MIPS
#===================================================================================
.data 
 CharPtr: .word 0 # Bien con tro, tro toi kieu asciiz 
 BytePtr: .word 0 # Bien con tro, tro toi kieu Byte 
 WordPtr: .word 0 # Bien con tro, tro toi mang kieu Word 
 ArrayPtr: .word 0 # Bien con tro, tro toi mang 2 chieu 
 CharPtr1: .space 100 #Bien con tro, su dung trong option 6
 CharPtr2: .space 100 #Bien con tro, su dung trong option 6
 Enter: .asciiz "\n" 
 row: .word 1 
 col: .word 1 
 menu: .asciiz "Menu\nChon tu 1 den 11.\n1.Malloc char\n2.Malloc Byte\n3.Malloc Word\n4.Gia tri cac bien con tro\n5.Dia chi cac bien con tro\n6.Copy con tro xau\n7.Free Storage\n8.Bo nho da cap phat\n9.Malloc 2D word Array\n10.Set Array\n11.Get Array\nChon 1-11:" 
 mal: .asciiz "\nso hang va so cot phai be hon 1000" 
 char: .asciiz "\n Nhap so phan tu cua mang char:" 
 word: .asciiz "\n Nhap so phan tu cua mang word:" 
 byte: .asciiz "\n Nhap so phan tu cua mang byte:" 
 arr1: .asciiz "\n Nhap so cot cua mang array:" 
 arr2: .asciiz "\n Nhap so hang cua mang array:" 
 input_row: .asciiz "\n Nhap i:" 
 input_col: .asciiz "\n Nhap j:" 
 input_value: .asciiz "\n Nhap gia tri dau vao:" 
 output_value:.asciiz "\n Gia tri tra ve:" 
 value_output: .asciiz "\n Gia tri tai cac bien con tro CharPtr BytePtr WordPtr ArrayPtr la:"
 address_output: .asciiz "\n Dia chi cua cac bien con tro CharPtr BytePtr WordPtr ArrayPtr la:" 
 success: .asciiz "\n Malloc success. Dia chi vung nho duoc cap phat : " 
 notification: .asciiz "\n Kich thuoc cua vung nho vua duoc cap phat la " 
 bound: .asciiz "\n index out of bound" 
 null: .asciiz "\nNull Pointer Exception. Chua khoi tao mang!!!!" 
 free_storage_notification: .asciiz "\nDa giai phong bo nho cap phat! " 
 storage_notification: .asciiz "\nBo nho da cap phat: " 
 bytes: .asciiz " bytes." 
 too_big: .asciiz "\n Gia tri nhap vao qua lon!!" 
 too_small: .asciiz "\n Gia tri nhap vao nho hon hoac bang 0" 
 copied_string : .asciiz "DuongThaiAnh-20226099"
 
.kdata 
 Sys_TheTopOfFree: .word 1 # Bien chua dia chi dau tien cua vung nho con trong 
 Sys_MyFreeSpace: # Vung khong gian tu do, dung de cap bo nho cho cac bien con tro 
.text 
 jal SysInitMem #Khoi tao vung nho cap phat dong
  

main: 
show_menu: 
 la $a0,menu #Load dia chi cua menu
 jal IntDialog 
 move $t0, $a0 #Thuc hien chuyen dia chi menu qua $t0, sau do so sanh t0 voi cac gia tri
 beq $t0, 1, option1 
 beq $t0, 2, option2 
 beq $t0, 3, option3 
 beq $t0, 4, option4 
 beq $t0, 5, option5 
 beq $t0, 6, option6
 beq $t0, 7, option7 
 beq $t0, 8, option8 
 beq $t0, 9, option9 
 beq $t0, 10, option10 
 beq $t0, 11, option11 
 j end 
 
option1:#Malloc char 
 la $a0,char #Load dia chi cua char vao $a0
 jal IntDialog 
 jal Check_value #Kiem tra xem gia tri co nam trong khoang xac dinh khong
 move $a1,$a0 #Chuyen dia chi cua char vao a1
 la $a0,CharPtr #Load dia chi cua char vao a0
 li $a2,1 #Cho gia tri tai a2 = 1, tuc la so byte cua bien Char
 jal malloc #output $v0 = dia chi bat dau cap phat boi malloc 
 move $t0,$v0 #Chuyen dia chi tu v0 vao t0
 la $a0,success 
 li $v0,4 
 syscall # Thuc hien in thong bao malloc success 
 move $a0,$t0 #Chuyen dia chi tu t0 vao a0
 li $v0,34 
 syscall # mang bat dau tai dia chi : t0 
 la $a0,notification 
 li $v0,4 
 syscall # in thong bao kich thuoc con tro 
 move $a0,$t7 #a0 = t7 = kich thuoc cua mang cap phat 
 li $v0,34 
 syscall 
 j main 
 
option2:#Malloc byte 
 la $a0,byte #Load dia chi cua byte vao $a0
 jal IntDialog 
 jal Check_value #Kiem tra xem gia tri co nam trong khoang xac dinh khong
 move $a1,$a0 #Chuyen dia chi cua byte vao a1
 la $a0,BytePtr #Load dia chi cua byte vao a0
 li $a2,1 #Cho gia tri tai a2 = 1, tuc la so byte cua bien Byte
 jal malloc #output $v0 = dia chi bat dau cap phat boi malloc 
 move $t0,$v0 #Chuyen dia chi tu v0 vao t0
 la $a0,success 
 li $v0,4 
 syscall 
 move $a0,$t0 #Chuyen dia chi tu t0 vao a0
 li $v0,34 
 syscall 
 la $a0,notification
 li $v0,4 
 syscall # in thong bao kich thuoc con tro
 move $a0,$t7 #a0 = t7 = kich thuoc cua mang cap phat 
 li $v0,34 
 syscall 
 j main 
 
option3:#Malloc word 
 la $a0,word 
 jal IntDialog 
 jal Check_value #Kiem tra xem gia tri co nam trong khoang xac dinh khong
 move $a1,$a0 #Chuyen dia chi cua word vao a1
 la $a0,WordPtr #Load dia chi cua word vao a0
 li $a2,4 #Cho gia tri tai a2 = 4, tuc la so byte cua bien Word
 jal malloc #output $v0 = dia chi bat dau cap phat boi malloc
 move $t0,$v0 #Chuyen dia chi tu v0 vao t0
 la $a0,success 
 li $v0,4 
 syscall 
 move $a0,$t0 #Chuyen dia chi tu t0 vao a0
 li $v0,34 
 syscall 
 la $a0,notification 
 li $v0,4 
 syscall # in thong bao kich thuoc con tro
 move $a0,$t7 #a0 = t7 = kich thuoc cua mang cap phat
 li $v0,34 
 syscall 
 j main 
 
option4:#In ra gia tri cua con tro
 la $a0,value_output #Chuyen dia chi value_output vao a0
 li $v0,4 
 syscall #In ra value_output
 li $a0,0 #Truong hop a0 = 0
 jal ptr_value #Thuc hien ham ptr_value (dong 385)
 jal print_value_or_address #Thuc hien ham print_value_or_address(dong 406)
 li $a0,1 #Truong hop a0 = 1
 jal ptr_value 
 jal print_value_or_address 
 li $a0,2 #Truong hop a0 = 2
 jal ptr_value 
 jal print_value_or_address 
 li $a0,3 #Truong hop a0 = 3
 jal ptr_value 
 jal print_value_or_address 
 j main 
 
option5:#In ra dia chi cua con tro
 la $a0,address_output 
 li $v0,4 
 syscall 
 li $a0,0 #Truong hop a0 = 0
 jal ptr_address #thuc hiem ham ptr_address(dong 397)
 jal print_value_or_address #Thuc hien ham print_value_or_address
 li $a0,1 #Truong hop a0 = 1
 jal ptr_address 
 jal print_value_or_address 
 li $a0,2 #Truong hop a0 = 2
 jal ptr_address 
 jal print_value_or_address 
 li $a0,3 #Truong hop a0 = 3
 jal ptr_address 
 jal print_value_or_address 
 j main 
 
# ---------------------------------- 
# copy CharPtr1 -> CharPtr2 
# print CharPtr2 
# a1 = Ptr1 
# a2 = Ptr2 -> Sys_TheTopOfFree 
# ---------------------------------- 

option6:#copy string pointer
copy:
	la $t0,CharPtr1 #Load dia chi CharPtr1 vao t0
	la $t1, copied_string #Load dia chi copied_string vao t1
	sw $t1,($t0) #Dia chi cua copied_string la gtri cua Ptr1(CharPtr1 -> copied)
	la $a2,CharPtr2 #Load dia chi CharPtr2 vao a2
	la $a0,Sys_TheTopOfFree #Load dia chi Sys_TheTop vao a0
	lw $t5,($a0) #t5 = Gia tri cua Sys_TheTop(Dia chi bat dau cua vung nho tu do) 
	sw $t5,($a2) #CharPtr2 tro den vung nho tu do(CharPtr2 -> Top)
	lw $t2,($a2) #t2 = Dia chi vung nho tu do moi sau khi cap nhat CharPtr2
	lw $t4, ($a0) #t4 = Dia chi vung nho tu do truoc khi CharPtr2 duoc cap nhat
copy_loop:
	lb $t3,($t1) #Load 1byte tu t1 vao t3
	sb $t3,($t2) # copy vlueCharPtr1 vao vung bo nho tu do
	addi $t4, $t4,1 # tang len de tinh SystopFree moi 
	addi $t1,$t1,1 # charPtr1[i++]
	addi $t2,$t2,1 # charPtr2[i++]
	beq $t3,'\0',exit_copy
	j copy_loop
exit_copy:
	sw $t4,($a0) # SystopFree moi
	la $a2, CharPtr2 #Load dia chi CharPtr2 vao a2
	lw $a0, ($a2) #Load dia chi vung nho tu do 
	li $v0,4
	syscall # in ra noi dung CharPtr2 tro toi
	la $a0, Enter
	syscall
	j main
 
 
option7:#freeStorage 
 jal freeStorage #Thuc hien ham freeStorage (dong 319)
 la $a0,free_storage_notification 
 li $v0,4 
 syscall #In ra freeStorageNotification
 j main 
 
 
option8:#show storage 
 la $a0,storage_notification 
 li $v0,4 
 syscall 
 jal storage #Thuc hien ham storage (dong 339)
 move $a0,$v0 #Chuyen v0 vao a0
 li $v0,1 
 syscall #In gia tri bo nho da cap phat
 la $a0,bytes 
 li $v0,4 #In chuoi ki tu bytes ra man hinh
 syscall 
 j main 
 
option9:#Malloc 2D Array 
 la $a0,arr1 #Load dia chi arr1 vao $a0
 jal IntDialog #doc len in_row 
 move $s0,$a0 #Load dia chi arr1 vao $s0
 la $a0,arr2 #Load dia chi arr2 vao $a0
 jal IntDialog #doc len col 
 move $a1,$s0 # malloc2 2nd param: row
 move $a2,$a0 # malloc2 3rd param: col 
 la $a0,ArrayPtr #Load dia chi con tro ArrayPtr vao $a0
 jal Malloc2 # goi malloc2 
 move $t0,$v0 # luu gia tri tra ve cua Malloc2 
 la $a0,success #In cau lenh success
 li $v0,4 
 syscall #In chuoi success
 move $a0,$t0 
 li $v0,34 
 syscall 
 li $v0, 4 
 la $a0, Enter 
 syscall 
 move $a0, $s5 
 li $v0, 34 
 syscall 
 
 li $v0, 11 
 li $a0,',' 
 syscall 
 
 move $a0, $s6 
 li $v0, 34 
 syscall 
 j main 
 
option10:#setter 
 la $a0,ArrayPtr 
 lw $s7,0($a0) # Luu **ArrayPtr vao $s7
 beqz $s7,nullptr # if *ArrayPtr==0 error null pointer 
 la $a0,input_row 
 jal IntDialog # get row 
 move $s0,$a0 
 la $a0,input_col 
 jal IntDialog #get col 
 move $s1,$a0 
 la $a0,input_value 
 jal IntDialog #get val 
 move $a3,$a0 #value
 move $a1,$s0 #row
 move $a2,$s1 #col
 move $a0,$s7 #*ArrayPtr
 jal SetArray # SetArray($a0:**ArrayPtr,$a1:hang,$a2:cot,$a3:Gia tri) 
 j main 


 
option11:#getter 
 la $a0,ArrayPtr 
 lw $s1,0($a0) 
 beqz $s1,nullptr # if *ArrayPtr==0 error null pointer 
 la $a0,input_row 
 jal IntDialog # get row 
 move $s0,$a0 
 la $a0,input_col 
 jal IntDialog #get col 
 move $a2,$a0 #col
 move $a1,$s0 #row
 move $a0,$s1 #value
 jal GetArray #GetArray(*ArrayPointer,row,col)
 move $s0,$v0 # save return value of GetArray 
 la $a0,output_value 
 li $v0,4 
 syscall 
 move $a0,$s0 
 li $v0,34 
 syscall 
 j main 
 
#------------------------------------------ 
#Giai phong bo nho cap phat cho cac bien con tro 
freeStorage: 
 la $t9,Sys_TheTopOfFree #gan dia chi Sys_TheTopOfFree
 la $t8,Sys_MyFreeSpace #Gan dia chi Sys_MyFreeSpace
 sw $t8, 0($t9) #Sys_TheTopOfFree tro den vung nho tu do
 la $t0,CharPtr # lay dia chi cua bien con tro dau tien 
 mul $t2,$t2,0 #set up t2 = 0
loop: 
 sll $t1, $t2, 2 #Dich trai 2 bit
 addi $t2, $t2, 1 #t2++
 addu $t0, $t0, $t1 # lay dia chi tai *CharPtr + 4*$a0 
 sw $t3, 0($t0) # lay gia tri cua *---Ptr , su dung t3 vi luc nay t3 = 0
 beq $t2,4,exit_free #Neu t2 = 4, nhay den exit_free
 j loop 
exit_free: 
 jr $ra 
#------------------------------------------ 
# Tinh tong luong bo nho da cap phat
# param: none 
# return: $v0 - dung luong bo nho da cap phat (byte) 
#------------------------------------------ 
storage: 
 la $t9,Sys_TheTopOfFree #Dia chi cua con tro Sys_TheTopOfFree
 lw $t9,0($t9) #Dia chi vung nho tu do gan nhat
 la $t8,Sys_MyFreeSpace #Dia chi vung nho tu do ban dau
 sub $v0, $t9, $t8 #v0 = t8 - t9
 jr $ra 
 
SysInitMem:  
 la $t9, Sys_TheTopOfFree # Lay con tro chua dau tien con trong, khoi tao 
 la $t7, Sys_MyFreeSpace # Lay dia chi dau tien con trong, khoi tao 
 sw $t7, 0($t9) # Luu lai 
 jr $ra
#------------------------------------------ 
# InputDialogInt 
# Lap den khi nao nhap vao thanh cong 
#------------------------------------------ 
IntDialog: 
 move $t0,$a0 # luu dia chi cua chuoi ki tu 
 li $v0,51 
 syscall 
 beq $a1,0,done # success 
 beq $a1,-2,end # thoat chuong trinh khi nguoi dung chon "cancel" 
 move $a0,$t0 # lay lai dia chi cua chuoi ki tu 
 j IntDialog 
done: 
 jr $ra 
 
#------------------------------------------ 
# check: 0<input<1000? 
#------------------------------------------
Check_value: 
 bge $a0,1000,over_value 
 blez $a0,negative 
 jr $ra 
over_value: 
 la $a0,too_big 
 j error 
negative: 
 la $a0,too_small 
 j error 
 
#------------------------------------------ 
# ptr_value: ham lay gia tri bien con tro 
# param: $a0 {0:char ; 1:byte ; 2:word ; 3: array} 
# return: $v0 - gia tri cua bien con tro
#------------------------------------------ 
ptr_value: 
 la $t0,CharPtr # lay dia chi cua bien con tro dau tien 
 sll $t1, $a0, 2 
 addu $t0, $t0, $t1 # lay dia chi tai *CharPtr + 4*$a0 
 lw $v0, 0($t0) # lay gia tri cua bien con tro, luu vao $v0 
 jr $ra 
 
#------------------------------------------ 
# ptr_address: ham lay dia chi bien con tro 
# param: $a0 {0:char ; 1:byte ; 2:word ; 3: array} 
# return: $v0 - dia chi cua bien con tro 
#------------------------------------------ 
ptr_address: #Tuong tu nhu ptr_value, ngoai tru viec luu dia chi cua bien con tro vao v0
 la $t0,CharPtr 
 sll $t1, $a0, 2 
 addu $v0, $t0, $t1 
 jr $ra 
 
#------------------------------------------ 
#print_value_or_address: in ra gia tri hoac dia chi cua con tro
#------------------------------------------ 
print_value_or_address: 
 move $t1,$a0 # kiem tra lan in cuoi 
 move $a0,$v0 
 li $v0,34 
 syscall 
 li $v0,11 
 beq $t1,3,end_print #ngan cach cac output boi cac dau phay, neu $t1 = 3, tuc gia tri ket thuc, nhay den end_print
 li $a0,',' 
 syscall 
 jr $ra 
end_print: li $a0,'.' 
 syscall 
 jr $ra
 
 
#------------------------------------------ 
# Ham cap phat bo nho dong cho cac bien con tro 
# param: [in/out] $a0 Chua dia chi cua bien con tro can cap phat 
# Khi ham ket thuc, dia chi vung nho duoc cap phat se luu tru vao bien con tro 
# param: $a1 - So phan tu can cap phat 
# param: $a2 - Kich thuoc 1 phan tu, tinh theo byte
# return: $v0 - Dia chi vung nho duoc cap phat 
#------------------------------------------ 
malloc:
    la $t9, Sys_TheTopOfFree    # Luu dia chi vao t9
    lw $t8, 0($t9)              # Lay gia tri dau tien cua con tro
    bne $a2, 4, continue        # Neu kich thuoc khong chia het cho 4, bo qua
    addi $t8, $t8, 3            #Do khoi tao cua Sys_TheTop = 1 nen +3 lam tron thanh gia tri 4 gan nhat
    andi $t8, $t8, 0xfffffffc   #Thuc hien phep and tron 3 bit cuoi cung thanh 0, gia tri chia het cho 4 gan nhat
continue:
    sw $t8, 0($a0)              # Luu dia chi vao con tro
    addi $v0, $t8, 0            # Tra ve dia chi cap phat la ket qua cua ham
    mul $t7, $a1, $a2           # Tinh kich thuoc cua mang can cap phat
    add $t8, $t8, $t7           # Tinh dia chi dau tien cua con tro tiep theo
    sw $t8, 0($t9)              # L?u tr? l?i ??a ch? ??u tiên vào bi?n Sys_TheTopOfFree
    jr $ra


 

#------------------------------------------ 
# Ham cap phat bo nho dong cho mang 2 chieu
# Y tuong: Dua ve cap phat bo nho cho mang 1 chieu voi kich thuoc row * col phan tu, tai su dung ham malloc 
# param: [in/out] $a0 Chua dia chi cua bien con tro can cap phat 
# Khi ham ket thuc, dia chi vung nho duoc cap phat se luu tru vao bien con tro 
# param: $a1 - So hang 
# param: $a2 - so cot 
# return: $v0 - Dia chi vung nho duoc cap phat 
#------------------------------------------ 
Malloc2: 
 addi $sp,$sp,-4 # them 1 ngan trong vao stack 
 sw $ra, 4($sp) # push $ra 
 bgt $a1,1000,malloc_err # kiem tra loi so luong
 bgt $a2,1000,malloc_err # cua hang (cot) 
 la $s0,row # luu so hang va so cot : row[0]= row, row[1]=col 
 sw $a1,0($s0) #luu so hang vao row[0]
 sw $a2,4($s0) #luu so cot vao row[1]
 move $s5, $a1 #hang 
 move $s6, $a2 #cot 
 mul $a1,$a1,$a2 #tinh so phan tu va luu vao $a1
 li $a2,4 #kich thuoc moi phan tu (word)
 jal malloc 
 lw $ra, 4($sp) 
 addi $sp,$sp,4 
 jr $ra 
 

 
#------------------------------------------ 
# gan gia tri cua trong mang 
# param [in] $a0 - Chua dia chi bat dau mang 
# param [in] $a1 - hang (i) # @param [in] $a2 cot (j) 
# param [in] $a3 - gia tri gan 
#------------------------------------------ 
SetArray: 
 la $s0,row 
 lw $s1,0($s0) 
 lw $s2,4($s0) 
 bge $a1,$s1,bound_err 
 bge $a2,$s2,bound_err 
 mul $s0,$s2,$a1 
 addu $s0,$s0,$a2 
 sll $s0, $s0, 2 
 addu $s0,$s0,$a0 
 sw $a3,0($s0) 
 jr $ra 
 
 #------------------------------------------ 
# lay gia tri cua trong mang 
# param [in] $a0 - Chua dia chi bat dau mang 
# param [in] $a1 - hang (i) 
# param [in] $a2 - cot (j) 
# return $v0 - gia tri tai hang a1 cot a2 trong mang 
# ------------------------------------------ 
GetArray: 
 la $s0,row # s0 =ptr so ha`ng 
 lw $s1,0($s0) #s1 so hang 
 lw $s2,4($s0) #s2 so cot 
 bge $a1,$s1,bound_err 
 bge $a2,$s2,bound_err 
 mul $s0,$s2,$a1 
 addu $s0,$s0,$a2 #s0= i*col +j
 sll $s0, $s0, 2 
 addu $s0,$s0,$a0 #s0 = *array + (i*col +j)*4 
 lw $v0,0($s0) 
 jr $ra 
 
#------------------------------------------ 
# errors 
#------------------------------------------ 
malloc_err: # thong bao loi so luong malloc 
 la $a0, mal 
 j error 
bound_err: # thong bao loi chi so vuot ngoai pham vi 
 la $a0, bound 
 j error 
nullptr: # thong bao con tro rong 
 la $a0, null 
error: # in ra thong bao loi 
 li $v0,4 
 syscall 
end: # ket thuc chuong trinh 
 li $v0,10 
 syscall 
