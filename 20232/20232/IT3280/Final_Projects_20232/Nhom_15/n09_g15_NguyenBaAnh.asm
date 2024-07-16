.data	       
	String1: .asciiz  "                                             *************        \n"
	String2: .asciiz  "**************                              *3333333333333*       \n"
	String3: .asciiz  "*222222222222222*                           *33333********        \n"
	String4: .asciiz  "*22222******222222*                         *33333*               \n"
	String5: .asciiz  "*22222*      *22222*                        *33333********        \n"
	String6: .asciiz  "*22222*       *22222*        *************  *3333333333333*       \n"
	String7: .asciiz  "*22222*       *22222*      **11111*****111* *33333********        \n"
	String8: .asciiz  "*22222*       *22222*    **1111**       **  *33333*               \n"
	String9: .asciiz  "*22222*      *222222*    *1111*             *33333********        \n"
	String10: .asciiz "*22222*******222222*    *11111*             *3333333333333*       \n"
	String11: .asciiz "*2222222222222222*      *11111*              *************        \n"
	String12: .asciiz "***************         *11111*                                   \n"
	String13: .asciiz "      ---               *1111**                                   \n"
	String14: .asciiz "    / o o \\              *1111****   *****                        \n"
	String15: .asciiz "    \\   > /               **111111***111*                         \n"
	String16: .asciiz "     -----                  ***********     dce.hust.edu.vn       \n"
	Message0: .asciiz "------------PROGRAMMING-----------\n"
	Request1: .asciiz"1. Print character\n"
	Request2: .asciiz"2. Print non-color character\n"
	Request3: .asciiz"3. Switch character position\n"
	Request4: .asciiz"4. Change color\n"
	Stop:     .asciiz"5. Stop\n"
	Choose:   .asciiz"Choose your option: "
	CharD:    .asciiz"Insert color for D(0->9): "
	CharC:    .asciiz"Insert color for C(0->9): "
	CharE:    .asciiz"Insert color for E(0->9): "
	
.text
	li 	$t5, 50 	#t5 current color of D ( ASCII 50 ~ 2)
	li 	$t6, 49 	#t6 current color of C ( ASCII 49 ~ 1)
	li 	$t7, 51 	#t7 current color of E ( ASCII 51 ~ 3)

main:
	la 	$a0, Message0	
	li 	$v0, 4
	syscall
	
	la 	$a0, Request1	
	li 	$v0, 4
	syscall
	
	la 	$a0, Request2	
	li 	$v0, 4
	syscall
	
	la 	$a0, Request3	
	li 	$v0, 4
	syscall
	
	la 	$a0, Request4	
	li 	$v0, 4
	syscall
	
	la 	$a0, Stop	
	li 	$v0, 4
	syscall
	
	la 	$a0, Choose	
	li 	$v0, 4
	syscall
	
	li 	$v0, 5
	syscall
	
	Case1menu:
		addi 	$v1, $0, 1
		bne 	$v0, $v1, Case2menu
		j 	Menu1
		
	Case2menu:
		addi 	$v1, $0, 2
		bne 	$v0, $v1, Case3menu
		j 	Menu2
		
	Case3menu:
		addi 	$v1, $0, 3
		bne 	$v0, $v1, Case4menu
		j 	Menu3
		
	Case4menu:
		addi 	$v1, $0, 4
		bne 	$v0, $v1, Case5menu
		j 	Menu4
		
	Case5menu:
		addi 	$v1, $0, 5
		bne 	$v0, $v1, defaultmenu
		j 	Exit
		
	defaultmenu:
		j 	main

#Print character line by line	
Menu1:	
	addi 	$t0, $0, 0		
	addi 	$t1, $0, 16	
	la 	$a0, String1
	
Loop:	
	beq 	$t1, $t0, main 	
	li 	$v0, 4
	syscall
		
	addi 	$a0, $a0, 68 	
	addi 	$t0, $t0, 1  	
	j 	Loop

Menu2: 	
	addi 	$s0, $0, 0	  	
	addi 	$s1, $0, 16  	
	la   	$s2, String1  	
		
Loop1:	
	beq  	$s1, $s0, main 	
	addi 	$t0, $0, 0		
	addi 	$t1, $0, 68        

#Find number in line
PrintNonColor:
	beq 	$t1, $t0, End  	
	lb  	$t2, 0($s2)		
	bgt 	$t2, 47, Label  	
	j 	Tmp

#Print " " if the character is number	
Label: 	
	bgt  	$t2, 57, Tmp 	
	addi 	$t2, $0, 0x20  	
	j 	Tmp
	
#Print the fixed line    	
Tmp: 	
	li 	$v0, 11  		
	addi 	$a0, $t2, 0  	
	syscall
	
	addi 	$s2, $s2, 1        	
	addi 	$t0, $t0, 1      	
	j 	PrintNonColor
	
End:	
	addi 	$s0, $s0, 1
	j 	Loop1
	
Menu3:
	addi 	$s0, $0, 0       	
	addi 	$s1, $0, 16
	la 	$s2, String1        	
	
Loop3:	
	beq 	$s1, $s0, main  
		
	#Split each line into 3 section "D, E, C"
	sb 	$0, 21($s2)		#Set "\0" value to split the string
	sb 	$0, 43($s2)
	sb 	$0, 65($s2)
	
	#Change string position
	li 	$v0, 4 			#Print each line of E and it will stop when meet "\0" value
	la 	$a0, 44($s2)	      	
	syscall
	
	li 	$v0, 4 			#Print each line of C
	la 	$a0, 22($s2)       	
	syscall
	
	li 	$v0, 4 			#Print each line of D
	la 	$a0, 0($s2) 		
	syscall
	
	li 	$v0, 4 			#Print newline character
	la 	$a0, 66($s2)  	
	syscall
	
	#Remove "\0" from string
	addi 	$t1, $0, 0x20 
	sb 	$t1, 21($s2)
	sb 	$t1, 43($s2)
	sb 	$t1, 65($s2)
	addi 	$s0, $s0, 1
	addi 	$s2, $s2, 68
	
	j 	Loop3

Menu4: 

#Change color for D
InsertColorD:		
	li 	$v0, 4		
	la 	$a0, CharD
	syscall
	
	li 	$v0, 5		
	syscall

	blt 	$v0, 0, InsertColorD    	
	bgt 	$v0, 9, InsertColorD    
	addi 	$s3, $v0, 48  		
	
#Change color for C
InsertColorC:	
	li 	$v0, 4		
	la 	$a0, CharC
	syscall
	
	li 	$v0, 5			
	syscall

	blt 	$v0, 0, InsertColorC
	bgt 	$v0, 9, InsertColorC	
	addi 	$s4, $v0, 48	 	
	
#Change color for E
InsertColorE:	          
	li 	$v0, 4		
	la 	$a0, CharE
	syscall
	
	li 	$v0, 5			
	syscall

	blt 	$v0, 0, InsertColorE   
	bgt 	$v0, 9, InsertColorE
	addi 	$s5, $v0, 48		
	
	addi 	$s0, $0, 0	  	        
	addi 	$s1, $0, 16        
	la 	$s2,String1	  	
	li 	$a1, 48             
	li 	$a2, 57

#Begin to change string color
ChangeColorLoop:	
	beq 	$s1, $s0, updateColor		#When $s1 = $s0 aka finish loop through 16 strings change the value of "$t5,6,7" - color storing address
	addi 	$t0, $0, 0      	
	addi 	$t1, $0, 68     	
	
PrintChangeColor:
	beq 	$t1, $t0, EndChangeColor	#When $t1 = $t0 aka finish loop through 68 chars of a string print it
	lb 	$t2, 0($s2)	 		
	
	CheckD: 
		bgt 	$t0, 21, CheckC 	#If $t0 >= 21 aka $t0 store the index of the beginning of C switch to CheckC
	        beq 	$t2, $t5, fixD  	#If $t2 = $t5 aka the color was not changed jump to fixD to change color
	        j 	TmpChangeColor
	        
	CheckC: 
		bgt 	$t0, 43, CheckE 
	        beq 	$t2, $t6, fixC
	        j 	TmpChangeColor
	        
	CheckE: 
		beq 	$t2, $t7, fixE
	        j 	TmpChangeColor
		
fixD: 	
	sb 	$s3, 0($s2)
	j 	TmpChangeColor
	
fixC: 	
	sb 	$s4, 0($s2)
	j 	TmpChangeColor
	
fixE: 	
	sb 	$s5, 0($s2)
	j 	TmpChangeColor
	
#Increase the value of $t0 and $s2 to check the next character 
TmpChangeColor: 	
	addi 	$s2, $s2, 1 		
	addi 	$t0, $t0, 1 	
	j 	PrintChangeColor

#Print string after change color	
EndChangeColor:	
	li 	$v0, 4  
	addi 	$a0, $s2, -68 	
	syscall
	
	addi 	$s0, $s0, 1 		
	j 	ChangeColorLoop
	
updateColor: 
	move 	$t5, $s3 		
	move 	$t6, $s4 		
	move 	$t7, $s5 		
	j 	main	
	
Exit:
