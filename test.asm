; useful resources: https://www.youtube.com/watch?v=5eWiz3soaEM&t=180s
; https://soliduscode.com/nasm-x64-c-calling-convention/

SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1


section .data
    msg db "Hello World!",10,0
    format db "%d",0
    msg2 db "test %d",10,0

section .bss
    number resb 4

section .text
extern printf, scanf, atof
global main,_start
main:
_start:
    lea rdi, [msg]
    mov rax,0
    call printf

    mov rax,0
    lea rdi, [format]
    lea rsi, [number]
    call scanf

    mov edx, [number]
    lea rdi, [msg2]
    mov rax,0
    call printf


  end:
    ; exit program
    mov rax, 60
    xor rbx, rbx
    syscall
    
    
    