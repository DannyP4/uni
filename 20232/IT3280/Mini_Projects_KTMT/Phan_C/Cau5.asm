.data
    	String:     	.space 256         
    	Message:    	.asciiz "Nhap vao xau ky tu: "  
    	Message1:   	.asciiz "Ky tu chu hoa xuat hien nhieu nhat trong xau la: "   
    	Message2:   	.asciiz "Vi tri cac ky tu la: "  
    	Space:      	.asciiz " "        
    	NewLine:    	.asciiz "\n"       

.text
main:
    # Nhap sau:
    	li  	$v0, 4		
    	la  	$a0, Message	
    	syscall

    	li  	$v0, 8		
    	la  	$a0, String	
    	li  	$a1, 256	
    	syscall

    	la  	$a1, String	# Load địa chỉ của String để truyền vào hàm tìm ký tự chữ hoa
    	li  	$a2, 1		# Khởi tạo tham số thứ 2 là 1 (đếm ký tự chữ hoa)
    	addi    $fp, $sp, 0	# Khởi tạo frame pointer

    	# Gọi hàm PushStack để đếm số lượng ký tự chữ hoa và lưu vào ngăn xếp
    	j   PushStack

exit:
    	li  	$v0, 10		# Load syscall cho việc kết thúc chương trình
    	syscall

# Hàm đệ quy để đếm số lượng ký tự chữ hoa và lưu vào ngăn xếp
PushStack:
    	lb  	$t0, 0($a1)		# Load ký tự từ mảng String
    	beqz    $t0, FindMaxFreq	# Nếu gặp ký tự null (kết thúc chuỗi), chuyển sang tìm ký tự chữ hoa xuất hiện nhiều nhất
    	blt 	$t0, 65, continue       # Nếu ký tự không thuộc bảng mã ASCII của chữ cái hoa, tiếp tục vòng lặp
    	bgt 	$t0, 97, continue
    	jal 	Check                 	# Gọi hàm Check để kiểm tra và cập nhật số lần xuất hiện của ký tự chữ hoa
    	sb  	$t0, 0($sp)           	# Lưu ký tự chữ hoa vào ngăn xếp
    	sw  	$a2, 4($sp)           	# Lưu số lần xuất hiện của ký tự chữ hoa vào ngăn xếp
    	addi    $a3, $a3, 1        	# Tăng biến đếm số lượng ký tự chữ hoa
    	addi    $sp, $sp, 8         	# Di chuyển con trỏ ngăn xếp
    	j   	continue                # Tiếp tục vòng lặp

continue:
    	addi    $a1, $a1, 1         	# Tiếp tục duyệt qua ký tự tiếp theo trong xâu
    	j   	PushStack               # Gọi đệ quy để xử lý ký tự tiếp theo

# Hàm kiểm tra và cập nhật số lần xuất hiện của ký tự chữ hoa
Check:
    	li  	$t1, 0             	# Khởi tạo biến đếm
    	mul 	$t2, $a3, 8        	# Tính offset của phần tử trong ngăn xếp
    	sub 	$t3, $sp, $t2      	# Tính địa chỉ của phần tử trong ngăn xếp
	
loop:
    	beq 	$t1, $a3, Return  	# Nếu đã duyệt qua hết các phần tử trong ngăn xếp, thoát khỏi hàm
    	lb  	$s2, 0($t3)        	# Load ký tự từ ngăn xếp
    	beq 	$s2, $t0, Update   	# Nếu ký tự từ ngăn xếp trùng với ký tự hiện tại, cập nhật số lần xuất hiện
    	addi    $t1, $t1, 1    		# Tăng biến đếm
    	addi    $t3, $t3, 8    		# Di chuyển con trỏ đến phần tử tiếp theo trong ngăn xếp
    	j   	loop

Update:
    	lw  	$s3, 4($t3)	# Load số lần xuất hiện của ký tự từ ngăn xếp
    	addi    $s3, $s3, 1     # Tăng số lần xuất hiện của ký tự
    	sw  	$s3, 4($t3)     # Cập nhật số lần xuất hiện vào ngăn xếp
    	j   	continue        # Tiếp tục vòng lặp

Return:
    	jr  	$ra	# Trở về địa chỉ gọi hàm

# Hàm tìm ký tự chữ hoa xuất hiện nhiều nhất trong xâu và in kết quả
FindMaxFreq:
    	addi    $sp, $fp, 0	# Đặt con trỏ ngăn xếp về đầu ngăn xếp
    	li  	$t0, 0		# Khởi tạo số lần xuất hiện của ký tự chữ hoa
    	li  	$t1, 0		# Khởi tạo số lượng ký tự chữ hoa

MaxFreq:
    	beq 	$t0, $a3, PrintResult	# Nếu đã duyệt qua hết các ký tự chữ hoa, chuyển sang in kết quả
    	lb  	$t2, 0($sp)             # Load ký tự từ ngăn xếp
    	lw  	$t3, 4($sp)             # Load số lần xuất hiện của ký tự từ ngăn xếp
    	bgt 	$t3, $t1, UpdateMaxFreq    	# Nếu số lần xuất hiện của ký tự lớn hơn số lượng ký tự đã xét trước đó, cập nhật kết quả

ContinueFind:
    	addi    $sp, $sp, 8	# Di chuyển con trỏ ngăn xếp
    	addi    $t0, $t0, 1	# Tăng biến đếm
    	j   	MaxFreq		# Tiếp tục vòng lặp

UpdateMaxFreq:
    	addi    $s1, $t2, 0	# Lưu ký tự chữ hoa xuất hiện nhiều nhất
    	addi    $t1, $t3, 0	# Cập nhật số lần xuất hiện của ký tự chữ hoa
    	j   	ContinueFind	# Tiếp tục tìm ký tự chữ hoa xuất hiện nhiều nhất
	
# Hàm in kết quả
PrintResult:
    	li  	$v0, 4		
    	la  	$a0, Message1	
    	syscall

    	li  	$v0, 11		
    	addi    $a0, $s1, 0 	
    	syscall

    	li  	$v0, 4   	
    	la  	$a0, NewLine  	
    	syscall

# In vị trí của các ký tự chữ hoa xuất hiện nhiều nhất trong xâu
    	j   	FindLocation

# Hàm tìm và in vị trí của các ký tự chữ hoa xuất hiện nhiều nhất trong xâu
FindLocation:
    	la  	$a1, String	
    	li  	$t0, 0      	# Khởi tạo biến đếm vị trí ký tự
    	li  	$v0, 4       	
    	la  	$a0, Message2           
    	syscall

PrintLocation:
    	lb  	$v1, 0($a1)		# Load ký tự từ mảng String
    	beqz    $v1, exit               # Nếu gặp ký tự null (kết thúc chuỗi), thoát khỏi hàm
    	addi    $a1, $a1, 1		# Di chuyển đến ký tự tiếp theo trong xâu
    	addi    $t0, $t0, 1		# Tăng biến đếm vị trí ký tự
    	bne 	$v1, $s1, PrintLocation # Nếu ký tự không trùng với ký tự chữ hoa xuất hiện nhiều nhất, tiếp tục vòng lặp
    	li  	$v0, 1                  
    	addi    $a0, $t0, 0          	# Truyền vị trí của ký tự vào thanh ghi $a0
    	syscall

    	li  	$v0, 4		
    	la  	$a0, Space	
    	syscall

    	j   PrintLocation	# Tiếp tục vòng lặp

#void Check(char ch, int *count, char *stack, int *stack_count) {
#    int i;
#    for (i = 0; i < *stack_count; i++) {
#        if (stack[i] == ch) {
#            count[i]++;
#            return;
#        }
#    }
#    stack[*stack_count] = ch;
#    count[*stack_count] = 1;
#    (*stack_count)++;
#}

#void FindMaxFreq(char *stack, int *count, int stack_count) {
#    int max_freq = count[0];
#    char max_char = stack[0];
#    int i;
#    for (i = 1; i < stack_count; i++) {
#        if (count[i] > max_freq) {
#            max_freq = count[i];
#            max_char = stack[i];
#        }
#    }
#    printf("Ky tu chu hoa xuat hien nhieu nhat trong xau la: %c\n", max_char);
#}

#void FindLocation(char *string, char max_char) {
#    printf("Vi tri cac ky tu la: ");
#    int position = 1;
#    int i;
#    for (i = 0; string[i] != '\0'; i++) {
#        if (string[i] == max_char) {
#            printf("%d ", position);
#        }
#        if (string[i] == ' ') {
#            position++;
#        }
#    }
#    printf("\n");
#}

#int main() {
#    char String[256];

#    printf("Nhap vao xau ky tu: ");
#    fgets(String, sizeof(String), stdin);

#    int count[256] = {0};
#    char stack[256];
#    int stack_count = 0;

#    int i;
#    for (i = 0; String[i] != '\0'; i++) {
#        char ch = String[i];
#        if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a' && ch <= 'z')) {
#            Check(ch, count, stack, &stack_count);
#        }
#    }

#    FindMaxFreq(stack, count, stack_count);
#    FindLocation(String, stack[0]);

#    return 0;
#}