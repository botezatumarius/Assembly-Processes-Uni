; Define constants for system calls and standard input/output streams
SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1

section .data
menu db "Choose one of the following processes:",0xA,
db "Process 0",0xA,
db "Process 1",0xA,
db "Process 2",0xA,
db "Process 3",0xA,
db "Process 4",0xA,
db "Process 5",0xA,
db "Process 6",0xA,
db "Process 7",0xA,
db "Process 8",0xA,
db "Process 9",0xA,
db "Exit (e)",0xA,
db "Your choice: ",0xA,0xD
prompt_len equ $- menu

seed dd 0
output db 0
buf db 2, 0

format db "Value in eax: %d", 0xA, 0 ; define a format string for printf

invalid_input db "Invalid input. Please enter a number from 0 to 9 or e to exit.",0xA,0xD
invalid_len equ $- invalid_input

try db "Testing",0xA,0xD
try_len equ $- try

section .bss
    num1 resb 4

section .text
global _start

_start:
    ; display the menu
    mov eax, 4
    mov ebx, 1
    mov ecx, menu
    mov edx, prompt_len
    int 0x80

    mov eax, SYS_READ
    mov ebx, STDIN
    mov ecx, num1
    mov edx, 4
    int 0x80

    mov byte [num1 + eax - 1], 0

    mov ebx, [num1]
    sub ebx, '0'
    
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
    cmp ebx, 53
    je process_exit

    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, invalid_input
    mov edx, invalid_len
    int 0x80
    jmp _start

process_0:
     ; Set up seed for random number generator
    mov eax, 60
    mov [seed], eax

    ; Generate random number between 0 and 32767
    mov eax, [seed]
    mov ecx, 1103515245
    mul ecx
    add eax, 12345
    mov [seed], eax

    ; Divide random number by 582 to get a number between 0 and 56
    mov ebx, 582
    xor edx, edx
    mov eax, [seed]
    div ebx

    ; Add 1 to the result to get a number between 1 and 56
    add eax, 1

    ; Show quotient
        

    jmp end


process_1:
    mov eax, SYS_WRITE
    mov ebx, STDOUT
    mov ecx, try
    mov edx, try_len
    int 0x80
    jmp end

process_2:
    
process_3:
    
process_4:

process_5:
    
process_6:
    
process_7:
    
process_8:
    
process_9:

process_exit:
    jmp end

end:
    ; exit program
    mov rax, 60
    xor rbx, rbx
    syscall

    