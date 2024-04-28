%macro rw 3
mov rdi,01
mov rax,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
msg db "",10,13
len equ $ -msg
msg1 db "The count of positive no is :"
len1 equ $ - msg1
msg2 db "The count of negative no is :"
len2 equ $ - msg2
pcnt db 0h
ncnt db 0h
count db 05h
res db 00h
arr dq 10,12,-23,24,-35
resarr db 00h,00h

section .bss 


section .text
global _start
_start:
mov rbp,arr
top:
mov rax,[rbp]
bt rax,63
jc negative
inc byte[pcnt]
jmp next2
negative:
inc byte[ncnt]
next2:
add rbp,8
dec byte[count]
jnz top

rw 1,msg1,len1
mov al,byte[pcnt]
mov byte[res],al
call htoa

rw 1,msg2,len2
mov al,byte[ncnt]
mov byte[res],al
call htoa


mov rax,60
mov rdi,0
syscall

htoa:
mov byte[count],2
mov rbp,resarr
mov byte[res],al
up:
rol al,04
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
rw 1,resarr,2
rw 1,msg,len
ret
