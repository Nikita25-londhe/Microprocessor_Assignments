%macro rw 3
mov rdi,01
mov rax,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
menu db "1:Addition",10,13,"2:Subtraction",10,13,"3:Multiplication",10,13,"4:Division",10,13,"5:Exit",10,13
lenm equ $ - menu
msg db "",10,13
len equ $ - msg
msg1 db "Addition is:",10,13
len1 equ $ - msg1
msg2 db "Subtraction is :",10,13
len2 equ $ - msg2
msg3 db "Multiplication is:",10,13
len3 equ $ - msg3
msg4 db "Quotient is:",10,13
len4 equ $ - msg4
msg5 db "Remainder is:",10,13
len5 equ $ - msg5
res dq 00h
count db 16
num1 dq 0Ah
num2 dq 03h
remainder dq 00h

section .bss 
resarr resb 16
option resb 02h

section .text
global _start
_start:
top:
rw 1,menu,lenm
rw 0,option,2
cmp byte[option],31h
jnz label2
rw 1,msg1,len1
call add
call htoa
jmp top

label2:
cmp byte[option],32h
jnz label3
rw 1,msg2,len2
call subp
call htoa
jmp top

label3:
cmp byte[option],33h
jnz label4
rw 1,msg3,len3
call mulp
call htoa
jmp top

label4:
cmp byte[option],34h
jnz label5
call divp
jmp top

label5:
mov rax,60
mov rdi,0
syscall

htoa:
mov byte[count],16
mov rbp,resarr
mov rax,qword[res]
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

add:
mov rax,qword[num1]
add rax,qword[num2]
mov qword[res],rax
ret

subp:
mov rax,qword[num1]
sub rax,qword[num2]
mov qword[res],rax
ret

mulp:
mov rax,qword[num1]
mov ecx,dword[num2]
mul ecx
mov qword[res],rax
ret

divp:
mov rax,qword[num1]
mov ecx,dword[num2]
div ecx
mov qword[res],rax
mov qword[remainder],rdx
rw 1,msg4,len4
call htoa
mov rax,qword[remainder]
mov qword[res],rax
rw 1,msg,len
rw 1,msg5,len5
call htoa 
ret





