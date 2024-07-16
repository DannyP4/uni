.data
    infix: .space 256
    postfix: .space 256
    operator: .space 256
    stack: .space 256
    endMsg: .asciiz "Tiep tuc??"
    errorMsg: .asciiz "Input khong chinh xac"
    startMsg: .asciiz "Nhap vao bieu thuc trung to\nNote: co chua +- * / % ()\nso tu 00-99"
    prompt_postfix: .asciiz "Bieu thuc hau to: "
    prompt_result: .asciiz "Ket qua: "
    prompt_infix: .asciiz "Bieu thuc trung to:"
 
.text
start:
    # nhap vao bieu thuc trung to
    li $v0, 54 # Load mã hệ thống gọi để đọc chuỗi vào $v0
    la $a0, startMsg # Load địa chỉ của chuỗi startMsg vào $a0
    la $a1, infix # Load địa chỉ buffer nơi chuỗi đầu vào sẽ được lưu vào $a1
    la $a2, 256 # Load độ dài max của chuỗi đầu vào vào $a2
    syscall

    beq $a1,-2,end # if 'cancel' syscall = -2 -> end
    beq $a1,-3,start # if 'enter' then start

    # in bieu thuc trung to
    li $v0, 4
    la $a0, prompt_infix
    syscall

    li $v0, 4
    la $a0, infix #Tải địa chỉ của chuỗi infix vào $a0. Chuỗi infix là biểu thức infix mà người dùng đã nhập vào trước đó.
    syscall

    li $v0, 11  #in 1 ky tu
    li $a0, '\n'
    syscall

    # khoi tao cac trang thai
    li $s7,0    # bien trang thai $s7
                # trang thai "1" khi nhan vao so (0 -> 99)
                # trang thai "2" khi nhan vao toan tu * / + - %
                # trang thai "3" khi nhan vao dau "("
                # trang thai "4" khi nhan vao dau ")"
    li $t9, 0         # Khởi tạo bộ đếm số chữ số nhận được (để theo dõi số chữ số của một số nguyên)
    li $t5, -1        # Khởi tạo offset cho postfix, ban đầu là -1 (vị trí bắt đầu của mảng postfix)
    li $t6, -1        # Khởi tạo offset cho toan tu, ban đầu là -1 (vị trí bắt đầu của mảng toán tử)
    la $t1, infix     # Tải địa chỉ của mảng infix vào thanh ghi $t1
    la $t2, postfix   # Tải địa chỉ của mảng postfix vào thanh ghi $t2
    la $t3, operator  # Tải địa chỉ của mảng toan tu vào thanh ghi $t3
    addi $t1, $t1, -1 # Giảm địa chỉ infix ban đầu đi 1 để chuẩn bị cho việc duyệt từng ký tự của chuỗi infix

    # chuyen sang postfix

scanInfix: # For moi ki tu trong postfix
    # kiem tra dau vao
    addi $t1, $t1, 1 # tang vi tri con tro infix len 1 don vi i = i + 1
    lb $t4, 0($t1) # lay gia tri cua con tro infix hien tai, giá trị của biến $t4 sẽ là giá trị của byte đầu tiên trong vùng nhớ
    # mà con trỏ $t1 đang trỏ tới.
    beq $t4, ' ', scanInfix # neu la space tiep tuc scan
    beq $t4, '\n', EOF # Scan ket thuc pop tat ca cac toan tu sang postfix
    beq $t9, 0, digit1 # Neu trang thai la 0 => co 1 chu so
    beq $t9, 1, digit2 # Neu trang thai la 1 => co 2 chu so
    beq $t9, 2, digit3 # neu trang thai la 2 => co 3 chu so

continueScan:
    beq $t4, '+', plusMinus       # Kiểm tra nếu $t4 là '+', chuyển đến nhãn plusMinus
    beq $t4, '-', plusMinus       # Kiểm tra nếu $t4 là '-', chuyển đến nhãn plusMinus
    beq $t4, '*', multiplyDivideModulo  # Kiểm tra nếu $t4 là '*', chuyển đến nhãn multiplyDivideModulo
    beq $t4, '/', multiplyDivideModulo  # Kiểm tra nếu $t4 là '/', chuyển đến nhãn multiplyDivideModulo
    beq $t4, '%', multiplyDivideModulo  # Kiểm tra nếu $t4 là '%', chuyển đến nhãn multiplyDivideModulo
    beq $t4, '(', openBracket     # Kiểm tra nếu $t4 là '(', chuyển đến nhãn openBracket
    beq $t4, ')', closeBracket    # Kiểm tra nếu $t4 là ')', chuyển đến nhãn closeBracket

wrongInput: # dau vao loi
    li $v0, 55
    la $a0, errorMsg
    li $a1, 2
    syscall
    j ask

finishScan:
    # in bieu thuc infix
    # Print prompt:
    li $v0, 4
    la $a0, prompt_postfix
    syscall
    li $t6,-1 # set gia tri infix hien tai la $s6= -1

printPostfix:
    addi $t6, $t6, 1 # Tăng offset của postfix hiện tại
    add $t8, $t2, $t6 # Load địa chỉ của postfix hiện tại
    lbu $t7, ($t8) # Load giá trị của postfix hiện tại
    bgt $t6, $t5, finishPrint # Nếu đã in hết postfix, chuyển sang tính kết quả
    bgt $t7, 99, printOperator # Nếu postfix hiện tại > 99, là một toán tử
    # Neu khong thi la mot toan hang
    li $v0, 1
    add $a0,$t7,$zero
    syscall
    
    li $v0, 11
    li $a0, ' '
    syscall
    j printPostfix # Loop

printOperator:
    li $v0, 11
    addi $t7,$t7,-100 # Decode toan tu
    add $a0,$t7,$zero
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    j printPostfix # Loop

finishPrint:
    li $v0, 11
    li $a0, '\n'
    syscall

    # tïnh toan ket qua
    li $t9,-4 # set offset cua dinh stack la -4
    la $t3,stack # Load dia chi dinh stack
    li $t6,-1 # Dat offset cua Postfix hien tai la -1

CalculatorPost:
    addi $t6,$t6,1 # tang offset hien tai cua Postfix
    add $t8,$t2,$t6 # Load dia chi cua postfix hien tai
    lbu $t7,($t8) # Load gia tri cua postfix hien tai
    bgt $t6,$t5,printResult # tïnh toan ket qua va in ra
    bgt $t7,99,calculate # neu gia tri postfix hien tai > 99 --> toan tu --> lay ra 2 toan hang va tïnh toan
    # neu khong thi la toan hang
    addi $t9,$t9,4 # tang offset dinh stack len
    add $t4,$t3,$t9 # tang dia chi cua dinh stack
    sw $t7, ($t4) # day so vao stack
    j CalculatorPost # Loop

calculate:
    # Pop 1 so
    add $t4,$t3,$t9
    lw $t0,($t4)

    # pop so tiep theo
    addi $t9,$t9,-4
    add $t4,$t3,$t9
    lw $t1,($t4)

    # Decode toan tu
    beq $t7,143,plus
    beq $t7,145,minus
    beq $t7,142,multiply
    beq $t7,147,divide
    beq $t7, 137, modulo

plus:
    add $t0,$t0,$t1 # tinh tong gia tri cua 2 con tro dang luu gia tri toan hang
    sw $t0,($t4) # luu gia tri cua con tro ra $t4
    # li $t0, 0 # Reset t0, t1
    # li $t1, 0
    j CalculatorPost

minus:
    sub $t0, $t1,$t0
    sw $t0,($t4)
    # li $t0, 0 # Reset t0, t1
    # li $t1, 0
    j CalculatorPost

multiply:
    mul $t0, $t1,$t0
    sw $t0,($t4)
    # li $t0, 0 # Reset t0, t1
    # li $t1, 0
    j CalculatorPost

divide:
    div $t1, $t0
    mflo $t0
    sw $t0,($t4)
    # li $t0, 0 # Reset t0, t1
    # li $t1, 0
    j CalculatorPost

modulo:
    div $t1, $t0
    mfhi $t0
    sw $t0,($t4)
    # li $t0, 0 # Reset t0, t1
    # li $t1, 0
    j CalculatorPost

printResult:
    li $v0, 4
    la $a0, prompt_result
    syscall

    li $v0, 1
    lw $a0,($t4) # load gia tri cua $t4 ra con tro $t0

    syscall
    li $v0, 11
    li $a0, '\n'
    syscall

ask: # tiep tuc khong??
    li $v0, 50
    la $a0, endMsg
    syscall
    beq $a0,0,start
    beq $a0,2,ask
    # End program

end:
    li $v0, 10
    syscall

# Sub program
EOF:
    beq $s7,2,wrongInput          # Nếu trạng thái là 2 (toán tử), báo lỗi input không hợp lệ
    beq $s7,3,wrongInput          # Nếu trạng thái là 3 (dấu ngoặc mở), báo lỗi input không hợp lệ
    beq $t5,-1,wrongInput         # Nếu postfix không có giá trị (offset là -1), báo lỗi input không hợp lệ
    j popAllOperatorInStack       # Nếu tất cả điều kiện đều không đúng, chuyển tất cả toán tử trong ngăn xếp sang postfix

digit1:                       # Kiểm tra và lưu chữ số đầu tiên.
    beq $t4,'0',storeDigit1
    beq $t4,'1',storeDigit1
    beq $t4,'2',storeDigit1
    beq $t4,'3',storeDigit1
    beq $t4,'4',storeDigit1
    beq $t4,'5',storeDigit1
    beq $t4,'6',storeDigit1
    beq $t4,'7',storeDigit1
    beq $t4,'8',storeDigit1
    beq $t4,'9',storeDigit1
    j continueScan

digit2:                       #Kiểm tra và lưu chữ số thứ hai hoặc lưu số hiện tại vào postfix nếu không phải là chữ số.
    beq $t4,'0',storeDigit2
    beq $t4,'1',storeDigit2
    beq $t4,'2',storeDigit2
    beq $t4,'3',storeDigit2
    beq $t4,'4',storeDigit2
    beq $t4,'5',storeDigit2
    beq $t4,'6',storeDigit2
    beq $t4,'7',storeDigit2
    beq $t4,'8',storeDigit2
    beq $t4,'9',storeDigit2
    # neu khong nhap vao chu so thu 2
    jal numberToPostfix
    j continueScan

digit3:
    # Kiểm tra và báo lỗi nếu gặp chữ số thứ ba hoặc lưu số hiện tại vào postfix nếu không phải là chữ số.
    beq $t4,'0',wrongInput
    beq $t4,'1',wrongInput
    beq $t4,'2',wrongInput
    beq $t4,'3',wrongInput
    beq $t4,'4',wrongInput
    beq $t4,'5',wrongInput
    beq $t4,'6',wrongInput
    beq $t4,'7',wrongInput
    beq $t4,'8',wrongInput
    beq $t4,'9',wrongInput
    # neu khong co chu so thu 3
    jal numberToPostfix
    j continueScan

plusMinus: # Input is + -
    beq $s7,2,wrongInput # Nhan toan tu sau toan tu hoac "("
    beq $s7,3,wrongInput
    beq $s7,0,wrongInput # nhan toan tu truoc bat ki so nao
    li $s7,2 # Thay doi trang thai dau vao thanh 2

continuePlusMinus:
    beq $t6,-1,inputOperatorToStack # Khong co gi trong stack -> day vao
    add $t8,$t6,$t3 # Load dia chi cua toan tu o dinh
    lb $t7,($t8) # Load byte gia tri cua toan tu o dinh
    beq $t7,'(',inputOperatorToStack # neu dinh la ( --> day vao
    beq $t7,'+',equalPrecedence # neu dinh la + - - -> day vao
    beq $t7,'-',equalPrecedence
    beq $t7,'*',lowerPrecedence # neu dinh la * / % thi lay * / % ra roi day vao
    beq $t7,'/',lowerPrecedence
    beq $t7,'%',lowerPrecedence

multiplyDivideModulo: # dau vao la * / %
    beq $s7,2,wrongInput # Nhan toan tu sau toan tu hoac "("
    beq $s7,3,wrongInput
    beq $s7,0,wrongInput # Nhan toan tu truoc bat ki so nao
    li $s7,2 # Thay doi trang thai dau vao thanh 2
    beq $t6,-1,inputOperatorToStack # Khong co gi trong stack -> day vao
    add $t8,$t6,$t3 # Load dia chi cua toan tu o dinh
    lb $t7,($t8) # Load byte gia tri cua toan tu o dinh
    beq $t7,'(',inputOperatorToStack # neu dinh la ( --> day vao
    beq $t7,'+',inputOperatorToStack # neu dinh la + - - -> day vao
    beq $t7,'-',inputOperatorToStack
    beq $t7,'*',equalPrecedence # neu dinh la * / % day vao
    beq $t7,'/',equalPrecedence
    beq $t7,'%',equalPrecedence

openBracket: # dau vap la (
    beq $s7,1,wrongInput # Nhan "(" sau mot so hoac dau ")"
    beq $s7,4,wrongInput
    li $s7,3 # Thay doi trang thai dau vao thanh 3
    j inputOperatorToStack

closeBracket: # dau vao la ")"
    beq $s7,2,wrongInput # Nhan ")" sau mot toan tu hoac toan tu
    beq $s7,3,wrongInput
    li $s7,4 # Thay doi trang thai dau vao thanh 4
    add $t8,$t6,$t3 # Load dia chi toan tu dinh
    lb $t7,($t8) # Load gia tri cua toan tu o dinh
    beq $t7,'(',wrongInput # Input bao gom () khong co gi o giua --> error

continueCloseBracket:
    beq $t6,-1,wrongInput # khong tïm duoc dau "(" --> error
    add $t8,$t6,$t3 # Load dia chi cua toan tu o dinh
    lb $t7,($t8) # Load gia tri cua toan tu o dinh
    beq $t7,'(',matchBracket # Tïm ngoac phu hop
    jal PopOperatorToPostfix # day toan tu o dinh vao postfix
    j continueCloseBracket # tiep tuc vong lap cho den khi tim duoc ngoac phu hop

equalPrecedence: # nhan + - vao dinh stack la + - || nhan * / % vao dinh stack la * / %
    jal PopOperatorToPostfix # lay toan tu dinh stack ra Postfix
    j inputOperatorToStack # day toan tu moi vao stack

lowerPrecedence: # nhan + - vao dinh stack * / %
    jal PopOperatorToPostfix # lay toan tu dinh stack ra va day vao postfix
    j continuePlusMinus # tiep tuc vong lap

inputOperatorToStack: # day dau vao cho toan tu
    add $t6,$t6,1 # tang offset cua toan tu o dinh len 1
    add $t8,$t6,$t3 # load dia chi cua toan tu o dinh
    sb $t4,($t8) # luu toan tu nhap vao stack
    j scanInfix

PopOperatorToPostfix: # lay toan tu o dinh va luu vao postfix
    addi $t5,$t5,1 # tang offet cua toan tu o dinh stack len 1
    add $t8,$t5,$t2 # load dia chi cua toan tu o dinh stack
    addi $t7,$t7,100 # mï¿½ hï¿½a toan tu + 100
    sb $t7,($t8) # luu toan tu vao postfix
    addi $t6,$t6,-1 # giam offset cua toan tu o dinh stack di 1
    jr $ra

matchBracket: # xoa cap dau ngoac
    addi $t6,$t6,-1 # giam offset cua toan tu o dinh stack di 1
    j scanInfix

popAllOperatorInStack: # lay het toan tu vao postfix
    jal numberToPostfix          # Gọi hàm numberToPostfix để xử lý số hiện tại (nếu có)
    beq $t6,-1,finishScan        # Nếu stack rỗng (t6 == -1), nhảy đến finishScan
    add $t8,$t6,$t3              # Tính địa chỉ của toán tử ở đỉnh stack
    lb $t7,($t8)                 # Tải giá trị của toán tử ở đỉnh stack
    beq $t7,'(',wrongInput       # Nếu là dấu ngoặc mở '(', báo lỗi
    beq $t7,')',wrongInput       # Nếu là dấu ngoặc đóng ')', báo lỗi
    jal PopOperatorToPostfix     # Gọi hàm PopOperatorToPostfix để lấy toán tử ra và đưa vào postfix
    j popAllOperatorInStack      # Lặp lại cho đến khi stack rỗng

storeDigit1:
    beq $s7,4,wrongInput          # Nếu trạng thái là 4 (sau khi gặp ')'), thì báo lỗi
    addi $s4,$t4,-48              # Chuyển ký tự số thành số nguyên (ASCII '0' là 48)
    add $t9,$zero,1               # Đặt trạng thái đếm thành 1
    li $s7,1                      # Đặt trạng thái đầu vào thành 1 (nhập số)
    j scanInfix                   # Quay lại nhãn scanInfix để tiếp tục quét biểu thức

storeDigit2:
    beq $s7,4,wrongInput          # Nếu trạng thái là 4 (sau khi gặp ')'), thì báo lỗi
    addi $s5,$t4,-48              # Chuyển ký tự số thứ hai thành số nguyên
    mul $s4,$s4,10                # Nhân chữ số đầu tiên với 10
    add $s4,$s4,$s5               # Thêm chữ số thứ hai vào để tạo thành số nguyên
    add $t9,$zero,2               # Đặt trạng thái đếm thành 2
    li $s7,1                      # Đặt trạng thái đầu vào thành 1 (nhập số)
    j scanInfix                   # Quay lại nhãn scanInfix để tiếp tục quét biểu thức

numberToPostfix:
    beq $t9,0,endnumberToPostfix  # Nếu không có số để lưu (t9 == 0), chuyển đến endnumberToPostfix
    addi $t5,$t5,1                # Tăng offset của postfix lên 1
    add $t8,$t5,$t2               # Tải địa chỉ của phần tử postfix tiếp theo vào $t8
    sb $s4,($t8)                  # Lưu số (trong $s4) vào postfix
    li $t9, 0                     # Đặt trạng thái đếm về 0

endnumberToPostfix:
    jr $ra                        # Trở về địa chỉ trả về (return address)

