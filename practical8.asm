%macro rw 3
mov rdi,01
mov rax,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
newline db "",10,13
newlen equ $ - newline
msg1 db "The Source Block is :",10,13
len1 equ $ - msg1
msg2 db "The destination block content :",10,13
len2 equ $ - msg2
arr dq 7F276ABC76594C2Bh, 12DEACBF721E1211h, 0FFFF1233061A8888h, 1F89111122224444h, 1141122223333444h,569747h
darr dq 0h,0h,0h,0h,0h
count1 db 05h
res dq 0h

section .bss 
count resb 1
resarr resb 16


section .text
global _start
_start:
rw 1,msg1,len1
mov rsi,arr
call disp_block

mov rsi,arr
mov rdi,darr
mov rcx,05
cld
rep movsq

rw 1,newline,newlen
rw 1,msg2,len2
mov rsi,darr
call disp_block

mov rax,60
mov rdi,0
syscall

disp_block:
mov byte[count1],5
label1:
mov rax,[rsi]
mov qword[res],rax
push rsi
call htoa
rw 1,newline,newlen
pop rsi
add rsi,8
dec byte[count1]
jnz label1

htoa:
mov byte[count],16
xor rsi,rsi
mov rsi,resarr
mov rax,qword[res]
up:
rol rax,04
mov bl,al
and bl,0Fh
cmp bl,09h
jbe next1
add bl,7h
next1:
add bl,30h
mov [rsi],bl
inc rsi
dec byte[count]
jnz up
rw 1,resarr,16
ret