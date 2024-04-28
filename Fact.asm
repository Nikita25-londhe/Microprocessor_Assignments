%macro rw 3
    mov rdi, 1   
    mov rax, %1  
    mov rsi, %2  
    mov rdx, %3 
    syscall     
%endmacro

section .data
newline db "",10,13
newlen equ $ - newline
msg1 db "The number is :",10,13
msglen equ $-msg1
msg2 db "Factorial of the number is:",10,13
msglen2 equ $-msg2
res dq 0h
no db 05h

section .bss
resarr resb 16
count resb 1

section .text
global _start
_start:
rw 1,msg1,msglen
mov rbx,[no]
mov qword[res],rbx
call htoa 
mov rax,1
mov ebx,[no]
label1:
cmp ebx,1
je exit
mul ebx
dec ebx
jmp label1
exit:
mov qword[res],rax
 rw 1,msg2,msglen2
call htoa

mov rax, 60  
xor rdi, rdi 
syscall  

htoa:
    mov byte[count], 16       ; Set count to 16
    mov rbp, resarr              ; Set rbp to point to resarr
    mov rax, qword[res]          ; Load the result into rax
    up:
        rol rax, 04                  ; Rotate rax left by 4 bits
        mov bl, al                   ; Move the lower byte of rax to bl
        and bl, 0Fh                  ; Mask the lower 4 bits
        cmp bl, 09h                  ; Compare with 9
        jle next1                    ; Jump if less than or equal to 9
        add bl, 7h                   ; Convert to ASCII if greater than 9
        next1:
            add bl, 30h                  ; Convert to ASCII
            mov [rbp], bl                ; Store the ASCII character
            inc rbp                      ; Move to the next byte in resarr
            dec byte[count]              ; Decrement count
            jnz up   ; Jump if count is not zero
            rw 1,resarr,16
            rw 1,newline,newlen
    ret
