%macro rw 3
    mov rdi, 01   
    mov rax, %1  
    mov rsi, %2  
    mov rdx, %3 
    syscall     
%endmacro

section .data
msg1 db "Enter a no:", 10, 13
msglen equ $-msg1
msg2 db "No is :",10,13
msglen2 equ $-msg2
count db 5

section .bss
numarr resb 85

section .text
global _start

_start:
    mov byte[count],05h
    mov rbp,numarr
    up:
    rw 1, msg1,msglen
    rw 0,rbp,17
    add rbp,17
    dec byte[count]
    jnz up
    mov byte[count],05h
    mov rbp,numarr
    again:
    rw 1,msg2,msglen2
    rw 1,rbp,17
    add rbp,17
    dec byte[count]
    jnz again
    


mov rax, 60  
mov rdi,0 
syscall      
