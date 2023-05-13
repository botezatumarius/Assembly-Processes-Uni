; Define constants for system calls and standard input/output streams
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1

section .data
    menu db "Choose one of the following processes:",0xA,
    db "Process 0 : Random number generator",0xA,
    db "Process 1 : Concatenate two strings",0xA,
    db "Process 2 : Convert a string to lower case",0xA,
    db "Process 3 : Calculate the length of a string",0xA,
    db "Process 4 : Invert a string",0xA,
    db "Process 5 : Calculate square root of a number",0xA,
    db "Process 6 : Calculate factorial of a number",0xA,
    db "Process 7",0xA,
    db "Process 8",0xA,
    db "Process 9",0xA,
    db "Process 10",0xA,
    db "Exit (11)",0xA,
    db "Your choice: ",0xA,0xD
    prompt_len equ $- menu

    format db "%lf",0
    format2 db "%d",0
    msg2 db "Square root is : %lf",10,0

    invalid_input db "Invalid input. Please enter a number from 0 to 9 or e to exit.",0xA,0xD
    invalid_len equ $- invalid_input

    inputFirstString db "Input the first string",10,0
    inputSecondString db "Input the second string",10,0
    inputUpcaseString db "Input the string to convert to lower case",10,0
    concatenatedStrings db "Concatenated strings:",10,0
    finishedLowcaseString db "String converted to lower case",10,0
    calculateString db "Input the string",10,0
    lengthOfString db "The length of the string is ",10,0
    invertedString db "Inverted string is",10,0
    inputSquareRoot db "Input number to find square root of",10,0
    inputFactorial db "Input number to find factorial of",10,0

    rand_numb db "Random numbers: ",0xA,0xD
    rand_len equ $- rand_numb

section .bss
    number resb 32
    num1 resb 4
    digitSpace resb 100
    digitSpacePos resb 8
    seed resb 32
    raxCopy resb 64
    rdiCopy resb 64
    firstString resb 100
    newLine resb 1
    null resb 1
    secondString resb 100
    guess resb 64
    res resq 1      
    val resq 1
    input resb 64   
    sqrnumber resq 1

section .text
extern printf, scanf
global main, _start

main:
_start:
    ; display the menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, prompt_len
    int 0x80

    mov rax,0
    lea rdi, [format2]
    lea rsi, [number]
    call scanf
    mov ebx, [number]
    
    ; execute the chosen process
    cmp ebx, 0 
    je process_0
    cmp ebx, 1
    je process_1
    cmp ebx, 2
    je process_2
    cmp ebx, 3
    je process_3
    cmp ebx, 4
    je process_4
    cmp ebx, 5
    je process_5
    cmp ebx, 6
    je process_6
    cmp ebx, 7
    je process_7
    cmp ebx, 8
    je process_8
    cmp ebx, 9
    je process_9
    cmp ebx, 10
    je process_10
    cmp ebx, 11
    je process_exit

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, invalid_input
    mov edx, invalid_len
    int 0x80
    jmp _start

process_0:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, rand_numb
    mov edx, rand_len
    int 0x80
    mov rdi, 0
    mov [rdiCopy], rdi
    mov eax, 69
    mov [seed],eax
    rngLoop:
        mov rdi, [rdiCopy]
        inc rdi
        mov [rdiCopy], rdi
        ; Load seed into rax
        mov rax, [seed]
        ; Calculate next = next * 1103515245 + 12345
        mov rbx, 1103515245
        mul rbx
        add rax, 12345
        ; Store next in next copy
        mov [raxCopy], rax
        ; Calculate result = (unsigned int) (next / 65536) % 2048
        mov rcx, 65536
        xor rdx, rdx
        div rcx
        mov rcx, 2048
        xor rdx,rdx
        div rcx
        mov rax, [raxCopy]
        mov [seed], rdx
        ; Calculate next = next * 1103515245 + 12345
        mov rbx, 1103515245
        mul rbx
        add rax, 12345
        ; Calculate result <<= 10
        mov [raxCopy], rax
        mov rax, [seed]
        shl rax, 10
        mov [seed], rax
        ; Store next copy in next
        mov rax, [raxCopy]
        ; Calculate result ^= (unsigned int) (next / 65536) % 2048
        mov rcx, 65536
        xor rdx, rdx
        div rcx
        mov rcx, 2048
        xor rdx,rdx
        div rcx
        mov rax, [seed]
        xor rax, rdx
        mov [seed], rdx
        mov rax, [raxCopy]
        ; Calculate next = next * 1103515245 + 12345
        mov rbx, 1103515245
        mul rbx
        add rax, 12345
        ; Calculate result <<= 10
        mov [raxCopy], rax
        mov rax, [seed]
        shl rax, 10
        mov [seed], rax
        ; Store next copy in next
        mov rax, [raxCopy]
        ; Calculate result ^= (unsigned int) (next / 65536) % 2048
        mov rcx, 65536
        xor rdx, rdx
        div rcx
        mov rcx, 2048
        xor rdx,rdx
        div rcx
        mov rax, [seed]
        xor rax, rdx
        mov [seed], rdx
        mov rax, [seed]

        ; modify range 0-2047 to 0-55
        xor rdx,rdx
        mov rcx, 37
        div rcx

        ;modify range from 0-55 to 1-56
        add rax, 1

        mov rcx, [raxCopy]
        mov [seed], rcx

        cmp rdi, 10
        je change
        
        back:    
            call _printRAX
            mov rdi, [rdiCopy]
            cmp rdi, 10
            jl rngLoop

        jmp end


process_1:
    mov rax, inputFirstString
    call _print

    mov rax, SYS_READ
    mov rbx, STDIN
    mov rcx, firstString
    mov rdx, 100
    int 0x80

    mov rax, inputSecondString
    call _print

    mov rax, SYS_READ
    mov rbx, STDIN
    mov rcx, secondString
    mov rdx, 100
    int 0x80

    mov byte [firstString + 100 - 4], 0

    mov rax, concatenatedStrings
    call _print
    mov rax, firstString
    call _printWithoutNewline
    mov rax, secondString
    call _print

    jmp end

process_2:
    mov rax, inputUpcaseString
    call _print

    mov rax, firstString
    call _clearString

    mov rax, SYS_READ
    mov rbx, STDIN
    mov rcx, firstString
    mov rdx, 100
    int 0x80

    mov rax, finishedLowcaseString
    call _print
    
    mov rax, firstString
    checkValue:
        cmp byte [rax], 65
        jge checkValue2
        cmp byte [rax], 0
        je end

        check:
            push rax
            mov rax, SYS_WRITE
            mov rbx, STDOUT
            pop rcx
            mov rdx, 1
            int 0x80
            
            mov rax,rcx
            inc rax
            jmp checkValue


    checkValue2:
        cmp byte [rax], 90
        jle printLowcase
        jmp check
    
    printLowcase:
        push rax
        mov rax, SYS_WRITE
        mov rbx, STDOUT
        pop rcx
        add byte [rcx], 32
        mov rdx, 1
        int 0x80
        
        sub byte [rcx], 32
        mov rax,rcx
        inc rax
        jmp checkValue


    jmp end

    
process_3:
    mov rax, calculateString
    call _print
    mov rax, firstString
    call _clearString

    mov rax, SYS_READ
    mov rbx, STDIN
    mov rcx, firstString
    mov rdx, 100
    int 0x80

    mov rax, lengthOfString
    call _print

    mov rax, firstString
    mov rbx, 0 
    calcLength:
        cmp byte [rax],0
        jne addToLength
        mov rax, rbx
        sub rax,1
        call _printRAX
        jmp end

    addToLength:
        inc rbx
        inc rax
        jmp calcLength

    jmp end
process_4:
    mov rax, calculateString
    call _print
    mov rax, firstString
    call _clearString

    mov rax, SYS_READ
    mov rbx, STDIN
    mov rcx, firstString
    mov rdx, 100
    int 0x80

    mov rax, invertedString
    call _print

    mov byte [null], 0
    mov byte [newLine], 10
    push null
    push newLine
    mov rax, firstString
    notNewline:
        cmp byte [rax], 10
        jne addStack
        jmp printStack

    addStack:
        push rax
        inc rax
        jmp notNewline
    
    printStack:
        mov rax, SYS_WRITE
        mov rbx, STDOUT
        pop rcx
        mov rdx, 1
        int 0x80
        cmp rcx, 0
        je end
        jmp printStack



process_5:
    mov rax, inputSquareRoot
    call _print

    mov rax,1
    lea rdi, [format]
    lea rsi, [sqrnumber]
    call scanf

    movsd xmm0, [sqrnumber]
    sqrtsd xmm0, xmm0
    lea rdi, [msg2]
    mov rax,1
    call printf

    jmp end
    
process_6:
    mov rax, inputFactorial
    call _print
    mov rax, firstString
    call _clearString

    mov rax, SYS_READ
    mov rbx, STDIN
    mov rcx, firstString
    mov rdx, 100
    int 0x80


    
process_7:
 
    jmp end
    
process_8:
    
process_9:

process_10:

process_exit:
    jmp end

_printRAX:
    mov rcx, digitSpace
    mov rbx, 10
    mov [rcx], rbx
    inc rcx
    mov [digitSpacePos], rcx
 
_printRAXLoop:
    mov rdx, 0
    mov rbx, 10
    div rbx
    push rax
    add rdx, 48
 
    mov rcx, [digitSpacePos]
    mov [rcx], dl
    inc rcx
    mov [digitSpacePos], rcx
    
    pop rax
    cmp rax, 0
    jne _printRAXLoop
 
_printRAXLoop2:
    mov rcx, [digitSpacePos]
 
    mov rax, 1
    mov rdi, 1
    mov rsi, rcx
    mov rdx, 1
    syscall
 
    mov rcx, [digitSpacePos]
    dec rcx
    mov [digitSpacePos], rcx
 
    cmp rcx, digitSpace
    jge _printRAXLoop2
 
    ret

_print:
    push rax
    mov rbx, 0
_printLoop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _printLoop
 
    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
 
    ret

_printWithoutNewline:
    push rax
    mov rbx, 0
_printWithoutNewlineLoop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _printWithoutNewlineLoop

    sub rbx, 1
    mov rax, 1
    mov rdi, 1
    pop rsi
    mov rdx, rbx
    syscall
 
    ret

_clearString:
    mov byte [rax], 0
    inc rax
    cmp byte [rax], 0
    jne _clearString

    ret

end:
    ; exit program
    mov rax, 60
    xor rbx, rbx
    syscall

change:
    add rax, 4
    jmp back
    