%macro rw 3
mov rdi,01
mov rax,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
msg1 db "The largest no is :"
len1 equ $ - msg1
large dq 0h
arr dq 7F276ABC76594C2Bh, 12DEACBF721E1211h, 0FFFF1233061A8888h, 1F89111122224444h, 1141122223333444h
resarr dq 0000000000000000h
count db 05h

section .bss 


section .text
global _start
_start:
mov rbp,arr
top:
mov rax,[rbp]
cmp rax,qword[large]
jl next
mov qword[large],rax
next:
add rbp,8
dec byte[count]
jnz top

rw 1,msg1,len1
mov rax,qword[large]
call htoa

mov rax,60
mov rdi,0
syscall

htoa:
mov byte[count],16
mov rbp,resarr
mov rax,qword[large]
up:
rol rax,04
mov bl,al
and bl,0Fh
cmp bl,09h
jle next1
add bl,7h
next1:
add bl,30h
mov [rbp],bl
inc rbp
dec byte[count]
jnz up
rw 1,resarr,16
ret
