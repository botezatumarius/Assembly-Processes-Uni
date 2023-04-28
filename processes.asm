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

invalid_input db "Invalid input. Please enter a number from 0 to 9 or e to exit.",0xA,0xD
invalid_len equ $- invalid_input

try db "Testing",0xA,0xD
try_len equ $- try

section .bss
    num1 resb 4
    digitSpace resb 100
    digitSpacePos resb 8
    seed resb 32
    raxCopy resb 64

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
    mov eax, 60
    mov [seed],eax
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

    call _printRAX
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
    