%macro rw 3
mov rdi,01
mov rax,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
count db 16
msg1 db "Enter a string:",10,13
len1 equ $ - msg1
msg2 db "Length of string:",10,13
len2 equ $ - msg2

section .bss 
numarr resb 16
str:resb 25

section .text
global _start
_start:
rw 1,msg1,len1
rw 0,str,25
mov rbp,numarr
mov byte[count],16
up:
rol rax,04
mov bl,al
and bl,0Fh
cmp bl,09h
jle next
add bl,7h
next:
add bl,30h
mov [rbp],bl
inc rbp
dec byte[count]
jnz up
rw 1,msg2,len2
rw 1,numarr,16


mov rax,60
mov rdi,0
syscall