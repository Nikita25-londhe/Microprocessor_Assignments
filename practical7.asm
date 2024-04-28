%macro rw 3
mov rdi,01
mov rax,%1
mov rsi,%2
mov rdx,%3
syscall
%endmacro

section .data
msg1 db "The processor in protected mode",10,13
len1 equ $ - msg1
msg2 db "The processor in real mode",10,13
len2 equ $ - msg2
colmsg db":"
colen equ $ - colmsg
msg3 db "The GDTR content is:"
len3 equ $ - msg3
msg4 db "The LDTR content is:"
len4 equ $ - msg4
msg5 db "The IDTR content is:"
len5 equ $ - msg5
msg6 db "The CR0 content is:"
len6 equ $ - msg6
msg7 db "The Task register content are:"
len7 equ $ - msg7
count db 04h
newline db "",10,13
newlen equ $ - newline

section .bss 
resarr resb 4
cro_word resw 1
gdt resd 1
    resw 1
ldt resw 1
idt resd 1
    resw 1
tr resw 1

section .text
global _start
_start:
smsw eax
mov [cro_word],eax
bt eax,0
jc pr
rw 1,msg2,len2
jmp exit
pr:
rw 1,msg1,len1

;Printing GDTR Content (48bit //32bit base//16 bit limit)

sgdt [gdt]
rw 1,msg3,len3
mov bx,[gdt+4]   ;Accssing last two digit out of 6 digits
call htoa
mov bx,[gdt+2]
call htoa
rw 1,colmsg,colen  ;Printing colon after reading base of 32 bit
mov bx,[gdt]
call htoa
rw 1,newline,newlen

;Printing LDTR Content(16bit)

sldt [ldt]
rw 1,msg4,len4
mov bx,[ldt]
call htoa
rw 1,newline,newlen

;printing IDTR content(48bit //32bit base//16 bit limit)
sidt [idt]
rw 1,msg5,len5
mov bx,[idt+4]
call htoa
mov bx,[idt+2]
call htoa
rw 1,colmsg,colen
mov bx,[idt]
call htoa
rw 1,newline,newlen

;Print TR content(16bit)
str [tr]
rw 1,msg7,len7
mov bx,[tr]
call htoa
rw 1,newline,newlen

;Printing CR0 

rw 1,msg6,len6
mov bx,[cro_word+2]
call htoa
mov bx,[cro_word]
call htoa



exit:
mov rax,60
mov rdi,0
syscall

htoa:
mov byte[count],4
mov rbp,resarr
up:
rol bx,04
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
rw 1,resarr,4
ret
