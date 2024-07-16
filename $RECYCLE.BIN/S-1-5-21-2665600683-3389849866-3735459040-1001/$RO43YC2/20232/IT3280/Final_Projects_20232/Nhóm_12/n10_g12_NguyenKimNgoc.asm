.eqv	SEVENSEG_LEFT	0xFFFF0011	# Địa chỉ của LED trái				
.eqv	SEVENSEG_RIGHT	0xFFFF0010	# Địa chỉ của LED phải
.eqv 	IN_ADDRESS_HEXA_KEYBOARD 	0xFFFF0012
.eqv 	OUT_ADDRESS_HEXA_KEYBOARD 	0xFFFF0014

.data
# Giá trị tương ứng với LED 7
zero:  		.byte 0x3F
one:   		.byte 0x06
two:   		.byte 0x5B
three: 		.byte 0x4F
four:  		.byte 0x66
five:  		.byte 0x6D
six:   		.byte 0x7D
seven: 		.byte 0x07
eight: 		.byte 0x7F
nine:  		.byte 0x6F

mess1: 	.asciiz 	"Can not divide by 0\n"

.text
main:

Init:
    	li  $t0, SEVENSEG_LEFT          # Biến chứa giá trị của LED bên trái
    	li  $t5, SEVENSEG_RIGHT         # Biến chứa giá trị của LED bên phải
   	li  $s0, 0                      # Biến chứa loại đầu vào: (0: chữ số), (1: toán tử)
    	li  $s1, 0                      # Biến chứa giá trị trên LED trái
    	li  $s2, 0                      # Biến chứa giá trị trên LED phải
    	li  $s3, 0                      # Biến chứa loại toán tử (1: +, 2: -, 3: *, 4: /, 5: %)
    	li  $s4, 0                      # Số thứ nhất
    	li  $s5, 0                      # Số thứ hai
   	li  $s6, 0                      # Kết quả
    	li  $t9, 0                      # Giá trị tạm thời
    
    	li  $t1, IN_ADDRESS_HEXA_KEYBOARD   # Biến điều khiển hàng bàn phím và kích hoạt ngắt bàn phím
    	li  $t2, OUT_ADDRESS_HEXA_KEYBOARD  # Biến chứa vị trí các phím
    	li  $t3, 0x80                 # Bit dùng để kích hoạt ngắt bàn phím và kiểm tra từng hàng bàn phím
    	sb  $t3, 0($t1)
    	li  $t7, 0                      # Biến chứa giá trị của số trên LED
    	li  $t4, 0                      # Byte hiển thị trên LED (0->9)

First_value:
    	li  $t7, 0                  # Giá trị cần được hiển thị bit ban đầu
    	addi $sp, $sp, 4            # Đẩy lên stack
    	sb  $t7, 0($sp)             # Lưu giá trị $t7 vào stack
    	lb  $t4, zero               # Đọc bit đầu tiên cần được hiển thị
    	addi $sp, $sp, 4            # Đẩy lên stack
    	sb  $t4, 0($sp)             # Lưu giá trị $t4 vào stack

Loop1:
	nop
	nop
	nop
	nop
	b 	Loop1		# Wait for interrupt
	nop
	nop
	nop
	nop
	b 	Loop1		
	nop
	nop
	nop
	nop
	b 	Loop1		
end_loop1:

end_main:
	li 	$v0, 10
	syscall
	
#--------------------------------------------------------------
# Xử lý khi xảy ra interrupt
# Hiển thị số vừa bấm lên LED 7 thanh
# Kiểm tra mỗi hàng xem hàng nào được nbấm hay không
#--------------------------------------------------------------
	
.ktext 0x80000180

#--------------------------------------------------------------
# Processing
# Check từng hàng nếu hàng nào được nhập thì chuyển với convert hàng đó
#--------------------------------------------------------------

# Kiểm tra hàng 1
        li 	$t3, 0x81 
        sb 	$t3, 0($t1)
        li 	$t2, OUT_ADDRESS_HEXA_KEYBOARD
        lb 	$t3, 0($t2)
	bnez 	$t3, convert_row1	# $t3 != 0 -> phím đã được nhấn, tìm phím đã nhấn trên hàng -> chuyển đổi phím đó
	nop
# Kiểm tra hàng 2
        li 	$t3, 0x82 
        sb 	$t3, 0($t1)
        li 	$t2, OUT_ADDRESS_HEXA_KEYBOARD
        lb 	$t3, 0($t2)
	bnez 	$t3, convert_row2	# $t3 != 0 -> phím đã được nhấn, tìm phím đã nhấn trên hàng -> chuyển đổi phím đó
	nop	
# Kiểm tra hàng 3
        li 	$t3, 0x84 
        sb 	$t3, 0($t1)
        li 	$t2, OUT_ADDRESS_HEXA_KEYBOARD
        lb 	$t3, 0($t2)
	bnez 	$t3, convert_row3	# $t3 != 0 -> phím đã được nhấn, tìm phím đã nhấn trên hàng -> chuyển đổi phím đó
	nop
# Kiểm tra hàng 4
        li 	$t3, 0x88 
        sb 	$t3, 0($t1)
        li 	$t2, OUT_ADDRESS_HEXA_KEYBOARD
        lb 	$t3, 0($t2)
	bnez 	$t3, convert_row4	# $t3 != 0 -> phím đã được nhấn, tìm phím đã nhấn trên hàng -> chuyển đổi phím đó
	nop

#------------------------------------------
#Convert từ địa chỉ sang số
#------------------------------------------


convert_row1:	
	beq 	$t3, 0x11, case_0		# Số 0
	beq 	$t3, 0x21, case_1		# Số 1
	beq 	$t3, 0x41, case_2		# Số 2
	j case_3		# Số 3
case_0:
	lb 	$t4,zero	# t4 = 0x66   với $t4 là byte và $t7 là giá trị
	li 	$t7,0		# t7 = 0
	j 	updateDigit
case_1:
	lb 	$t4,one		
	li 	$t7,1		
	j 	updateDigit
case_2:
	lb	$t4,two		
	li 	$t7,2		
	j	updateDigit
case_3:
	lb 	$t4, three	
	li 	$t7, 3		
	j 	updateDigit


convert_row2:	
	beq 	$t3, 0x12, case_4		
	beq 	$t3, 0x22, case_5		
	beq 	$t3, 0x42, case_6		
	j case_7		
case_4:
	lb 	$t4, four	
	li 	$t7, 4		
	j 	updateDigit
case_5:
	lb 	$t4, five	
	li 	$t7, 5		
	j 	updateDigit
case_6:
	lb	$t4, six	
	li 	$t7,6		
	j	updateDigit
case_7:
	lb 	$t4, seven	
	li 	$t7, 7		
	j 	updateDigit


convert_row3:	
	beq 	$t3, 0x14, case_8		
	beq 	$t3, 0x24, case_9		
	beq 	$t3, 0x44, case_a		
	j case_b		
case_8:
	lb 	$t4, eight	
	li 	$t7, 8		
	j 	updateDigit
case_9:
	lb 	$t4, nine	
	li 	$t7, 9		
	j 	updateDigit

# Case a: Cộng
case_a:	
	addi 	$s0, $s0, 1          	# s0 = 1, Để chỉ ra đây là 1 toán tử
	addi 	$s3, $zero, 1		# s3 = 1 -> Cộng
	
	j 	set_first_number        # Di chuyển đếm hàm set số đầu tiên
	
case_b:
	addi 	$s0, $s0, 1		
	addi 	$s3, $zero, 2		# s3 = 2 -> Trừ
	j 	set_first_number


convert_row4:	
	beq 	$t3, 0x18, case_c		
	beq 	$t3, 0x28, case_d		
	beq 	$t3, 0x48, case_e		
	j case_f		
	
case_c:	
	addi 	$s0, $s0, 1          	
	addi 	$s3, $zero, 3		# $s3 = 3 -> Nhân
	
	j set_first_number        	
	
case_d:
	addi 	$s0, $s0, 1		
	addi 	$s3, $zero, 4		# $s3 = 4 -> Chia
	j 	set_first_number

case_e:	
	addi 	$s0, $s0, 1          
	addi 	$s3, $zero, 5		# $s3 = 5 -> Mod
	j 	set_first_number        
	
# Convert the number on LED -> value of the first number
set_first_number:      
	addi 	$s4, $t9, 0 # số thứ nhất được đưa vào $s4
	li 	$t9, 0
	j 	done

# Case f:
case_f: 
	addi $s5, $t9, 0 # Số thứ hai được đưa vào $s5
	
# Thực hiện phép toán và đưa ra kết quả
process:  
	beq 	$s3, 1, addition	
	beq 	$s3, 2, substraction	
	beq 	$s3, 3, multiplication	
	beq 	$s3, 4, division	
	beq	$s3, 5, find_remainder	

addition: 			# Thực hiện phép trừ
	add 	$s6, $s5, $s4
	li 	$s3, 0
	li 	$t9, 0 
	j 	print_addition
	nop     		

print_addition: 		# Hàm dùng để in ra phép tính trừ
	li 	$v0, 1
	move 	$a0, $s4
	syscall
	li 	$s4, 0		# Reset số đầu về 0
	
	li 	$v0, 11
	li 	$a0, '+'
	syscall
	
	li 	$v0, 1
	move 	$a0, $s5
	syscall
	li 	$s5, 0		# Reset số sau về 0
	
	li 	$v0, 11
	li 	$a0, '='
	syscall
	
	li 	$v0, 1
	move 	$a0, $s6
	syscall
	nop
	
	li 	$v0, 11
	li 	$a0, '\n'
	syscall
	
	li 	$s7, 100
	div 	$s6, $s7
	move    $s7, $s6	# Lưu giá trị kết quả vào $s7
	mfhi 	$s6	    	# Xuất ra 2 số cuối vào $s6
	j show_result_in_led	# Di chuyển đến hàm chiếu kết quả
	nop
# Tương tự với các phép toán còn lại
substraction:
	sub 	$s6, $s4, $s5   
	li 	$s3, 0
	li 	$t9, 0 
	j 	print_substraction
	nop
	
print_substraction:
	li 	$v0, 1
	move 	$a0, $s4
	syscall
	li 	$s4, 0		
	
	li 	$v0, 11
	li 	$a0, '-'
	syscall
	
	li 	$v0, 1
	move 	$a0, $s5
	syscall
	li 	$s5, 0		
	
	
	li 	$v0, 11
	li 	$a0, '='
	syscall
	
	li 	$v0, 1
	move 	$a0, $s6
	syscall
	
	li 	$v0, 11
	li 	$a0, '\n'
	syscall
	
	li 	$s7, 100
	div 	$s6, $s7 
	move    $s7, $s6	# Lưu giá trị kết quả vào $s7
	mfhi 	$s6		# Lưu 2 số cuối vào $s6	    	
	j 	show_result_in_led	
	nop

multiplication:
	mul 	$s6, $s4, $s5    
	li 	$s3, 0
	li 	$t9, 0 
	j 	print_multiplication
	nop
	
print_multiplication:
	li 	$v0, 1
	move 	$a0, $s4
	syscall
	li 	$s4, 0		
	
	li 	$v0, 11
	li 	$a0, '*'
	syscall
	
	li 	$v0, 1
	move 	$a0, $s5
	syscall
	li 	$s5, 0		
	
	
	li 	$v0, 11
	li 	$a0, '='
	syscall
	
	li 	$v0, 1
	move 	$a0, $s6
	syscall
	
	li 	$v0, 11
	li 	$a0, '\n'
	syscall
	
	li 	$s7, 100
	div 	$s6, $s7
	move    $s7, $s6	# Lưu giá trị kết quả vào $s7
	mfhi 	$s6	    	
	j show_result_in_led    
	nop

division:
	beq 	$s5, 0, divide_by_0	
	li 	$s3, 0
	div 	$s4, $s5   	    
	mflo 	$s6
	mfhi 	$s7
	li 	$t9, 0 
	j 	print_division
	nop

# Xử lý trường hợp chia cho 0
divide_by_0: 
	li 	$v0, 55
	la 	$a0, mess1		# In ra dòng "Không thể chia cho 0"
	li 	$a1, 0
	syscall
	j 	reset_led

print_division:
	li 	$v0, 1
	move 	$a0, $s4
	syscall
	li 	$s4, 0		
	
	li 	$v0, 11
	li 	$a0, '/'
	syscall
	
	li 	$v0, 1
	move 	$a0, $s5
	syscall
	li 	$s5, 0		
	
	
	li 	$v0, 11
	li 	$a0, '='
	syscall
	
	li 	$v0, 1
	move 	$a0, $s6
	syscall
	
		
	li 	$v0, 11
	li 	$a0, '\n'
	syscall
	
	li 	$s7, 100
	div 	$s6, $s7
	move    $s7, $s6	# Lưu giá trị kết quả vào $s7
	mfhi 	$s6		# Xuất 2 số cuối ra $s6    	
	j 	show_result_in_led	
	nop


find_remainder:
	beq 	$s5, 0, find_remainder_0	
	li 	$s3, 0
	div 	$s4, $s5   	    
	mflo 	$s7
	mfhi 	$s6
	li 	$t9, 0 
	j 	print_find_remainder
	nop

# Xử lý khi % cho 0
find_remainder_0: 
	li 	$v0, 55
	la 	$a0, mess1
	li 	$a1, 0
	syscall
	j 	reset_led

print_find_remainder:
	li 	$v0, 1
	move 	$a0, $s4
	syscall
	li 	$s4, 0		
	
	li 	$v0, 11
	li 	$a0, '%'
	syscall
	
	li 	$v0, 1
	move 	$a0, $s5
	syscall
	li 	$s4, 0		
	
	li 	$v0, 11
	li 	$a0, '='
	syscall
	
	li 	$v0, 1
	move 	$a0, $s6
	syscall
	
		
	li 	$v0, 11
	li 	$a0, '\n'
	syscall
	
	li 	$s7, 100
	div 	$s6, $s7
	move	$s7, $s6
	mfhi 	$s6		    	
	j 	show_result_in_led	
	nop

#--------------------------------
# Hiển thị kết quả trên đèn LED
# Ví dụ số 'ab'
# Đèn trái = a = ab div 10
# Đèn phải = b = ab mod 10
#--------------------------------

show_result_in_led:
	li 	$t8, 10			# Giá trị tạm $t8 = 10
	div 	$s6, $t8    		
	mflo 	$t7        		# t7 = a
	jal 	check    		# Di chuyển tới hàm kiểm tra và chuyển đổi từ số sang địa chỉ trên LED 7 thanh
        sb 	$t4, 0($t0)  		# Chiếu lên LED trái
	mfhi 	$t7       		# t7 = b
	jal 	check    		# Di chuyển tới hàm kiểm tra và chuyển đổi từ số sang địa chỉ trên LED 7 thanh
        sb 	$t4, 0($t5)  		# Chiếu lên LED phải
        move	$t9, $s7		# Lưu kết quả tính được vào thanh $t9 để thực hiện tiếp tục phép toán sau đó
        j 	reset_led     		# Reset LED
check:
	addi 	$sp, $sp, 4
        sw 	$ra, 0($sp)		# Lưu địa chỉ trước khi check
        beq 	$t7, 0, check_0		# Nếu %t7 = 0 thì lưu dịa chỉ zero vào $t4
        beq 	$t7, 1, check_1	   	# Tương tự
        beq 	$t7, 2, check_2		
        beq 	$t7, 3, check_3		
        beq 	$t7, 4, check_4		
        beq 	$t7, 5, check_5		
        beq 	$t7, 6, check_6		
        beq 	$t7, 7, check_7		
        beq 	$t7, 8, check_8		
        beq 	$t7, 9, check_9		

#----------------------------------------------
# Chuyển giá trị trên $t7 thành địa chỉ và lưu vào $t4
#----------------------------------------------
        
check_0:	
	lb 	$t4, zero    
	j 	finish_check
check_1:
	lb 	$t4, one
	j 	finish_check
check_2:
	lb 	$t4, two
	j 	finish_check
check_3:
	lb 	$t4, three
	j	finish_check
check_4:
	lb 	$t4, four
	j 	finish_check
check_5:
	lb 	$t4, five
	j 	finish_check
check_6:
	lb 	$t4, six
	j 	finish_check
check_7:
	lb 	$t4, seven
	j 	finish_check
check_8:
	lb 	$t4, eight
	j 	finish_check
check_9:
	lb 	$t4, nine
	j 	finish_check	

finish_check:
	lw 	$ra, 0($sp)
	addi 	$sp, $sp, -4
	jr 	$ra

updateDigit:			
	 mul 	$t9, $t9, 10
	 add 	$t9, $t9, $t7

# Chiếu xong 1 số -> reset LED
done:
	beq $s0,1,reset_led   		# Kiểm tra xem có phải toán tử k, nếu là toán tử thì reset_led để gõ số tiếp theo
	nop

# Hàm chiếu LED trái
load_to_left_led: 
	lb 	$t6, 0($sp)       	# Lấy bit từ stack
	add 	$sp, $sp, -4
	lb 	$t8, 0($sp)       	# Lấy giá trị từ stack
	add 	$sp, $sp, -4      
	add 	$s2, $t8, $zero   	# s2 = value of LEFT LED
	sb 	$t6, 0($t0)       	# Show LEFT LED

# Hàm chiếu LED phải
load_to_right_led:	
	sb 	$t4, 0($t5)      	# in ra số vừa nhập
	add 	$sp, $sp,4		# Đưa số vừa nhập: địa chỉ và giá trị vào stack
	sb 	$t7, 0($sp)	  
	add 	$sp, $sp,4
	sb 	$t4, 0($sp)       
	add 	$s1, $t7, $zero   
	j 	finish            

reset_led: 				# Đưa led về ban đầu
	li 	$s0, 0           
        li 	$t8, 0
	addi 	$sp, $sp, 4		# khởi tạo lại giá trị 0 cho phép toán tiếp theo
        sb 	$t8, 0($sp)
        lb 	$t6, zero        
	addi 	$sp, $sp, 4
        sb 	$t6, 0($sp)

finish:
	j 	return
	nop

return:
	la 	$a3, Loop1
	mtc0 	$a3, $14
	eret

