%macro rw 3
mov rax, %1
mov rdi, 01
mov rsi, %2
mov rdx, %3
syscall
%endmacro

section .data
rmsg db 10,13,"Processor is in Real Mode"
lenrmsg equ $-rmsg 

prmsg db 10,13 ,"Processor is in Protected Mode"
lenprmsg equ $- prmsg

ldtmsg db 10,13,"LDT Contents are : "
lenldt equ $-ldtmsg 

cr0msg db 10,13,"CR0 contents are:"
lencr0 equ $-cr0msg

gdtmsg db 10,13,"GDT Contents are : "
lengdt equ $-gdtmsg 

idtmsg db 10,13,"IDT Contents are : "
lenidt equ $-idtmsg 

trmsg db 10,13,"The Task register contents are:"
lentr equ $- trmsg 

cpumsg db 10,13,"The CPU ID is:"
lencpu equ $- cpumsg

nl db 0xA,0xD
nl_len equ $-nl

colon db " : "
colonLen equ $-colon
count db 4


section .bss
ldt_contents resb 02 
cr0_contents resb 4
gdt_contents resb 6
idt_contents resb 6
numarr resb 4
tr_contents resb 2
cpuid_contents resb 12



section .text
global _start
_start:

;Printing CRO contents 

smsw eax
mov dword[cr0_contents], eax
bt eax,0
jnc real
rw 1,prmsg,lenprmsg
rw 1,cr0msg,lencr0
mov ax,word[cr0_contents+2]
call htoa 
mov ax,word[cr0_contents]
call htoa

;Printing LDT contents  //16 bits
sldt ax
mov word[ldt_contents],ax
rw 1,ldtmsg,lenldt
mov ax,word[ldt_contents]
call htoa

;Printing GDT contents 
rw 1,gdtmsg,lengdt
sgdt [gdt_contents]
mov ax,[gdt_contents+4]
call htoa
mov ax,[gdt_contents+2]
call htoa
rw 1,colon,colonLen
mov ax,[gdt_contents]
call htoa 

;Printing IDT contents
rw 1,idtmsg,lenidt
sidt [idt_contents]
mov ax,[idt_contents+4]
call htoa
mov ax,[idt_contents+2]
call htoa
rw 1,colon,colonLen
mov ax,[idt_contents]
call htoa 

;Printing TR contents 
rw 1,trmsg,lentr
str [tr_contents]
mov ax,word[tr_contents]
call htoa

;Printing CPU-ID 
rw 1,cpumsg,lencpu
xor eax,eax
CPUID
mov dword[cpuid_contents], ebx
mov dword[cpuid_contents+4], edx
mov dword[cpuid_contents+8], ecx
rw 1,cpuid_contents,12

jmp end
real:
rw  1,rmsg,lenrmsg

end:
mov rax,60
mov rdi,0
syscall

htoa:
mov byte[count],4
mov rbp,numarr
next:
rol ax,04
mov bl,al
and bl,0Fh
cmp bl,09h
jle skip
add bl,7h
skip:
add bl,30h
mov [rbp],bl
inc rbp
dec byte[count]
jnz next
rw 1,numarr,4
ret

