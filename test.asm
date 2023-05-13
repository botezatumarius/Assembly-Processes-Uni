; useful resources: https://www.youtube.com/watch?v=5eWiz3soaEM&t=180s
; https://soliduscode.com/nasm-x64-c-calling-convention/
; https://stackoverflow.com/questions/39324596/why-am-i-getting-a-float-not-a-double-from-scanf#comment65982892_39324596

SYS_EXIT equ 1
SYS_READ equ 3
SYS_WRITE equ 4
STDIN equ 0
STDOUT equ 1


section .data
    msg db "Hello World!",10,0
    format db "%lf",0
    msg2 db "%lf",10,0

section .bss
    number resq 1

section .text
extern printf, scanf, atof
global main,_start
main:
_start:
    lea rdi, [msg]
    mov rax,0
    call printf

    mov rax,1
    lea rdi, [format]
    lea rsi, [number]
    call scanf

    movsd xmm0, [number]
    lea rdi, [msg2]
    mov rax,1
    call printf


  end:
    ; exit program
    mov rax, 60
    xor rbx, rbx
    syscall
    
    
    