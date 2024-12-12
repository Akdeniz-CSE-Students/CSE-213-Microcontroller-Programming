org 100h

buffer db 32,0,32 dup(0)

LEA DX, MSG1
mov ah,09h
int 21h

mov ah,0Ah
lea dx, buffer
int 21h

mov si, offset buffer+2
mov di, offset STR1

copy_loop:
mov al,[si]
cmp al,0Dh
je copy_done
mov [di],al
inc si
inc di
jmp copy_loop

copy_done:
mov byte ptr [di],'$'

LEA DX, MSG4
mov ah,09h
int 21h

LEA DX, STR1
mov ah,09h
int 21h

LEA SI, STR1
LEA DI, STR1

find_end:
mov al,'$'
cmp [DI],al
je check_pal
inc DI
jmp find_end

check_pal:
dec di
pal_loop:
cmp si,di
jge is_pal
mov al,[si]
mov bl,[di]
cmp al,bl
jne not_pal
inc si
dec di
jmp pal_loop

not_pal:
LEA DX, MSG2
mov ah,09h
int 21h
jmp end_prog

is_pal:
LEA DX, MSG3
mov ah,09h
int 21h

end_prog:
mov ah,4Ch
xor al,al
int 21h

MSG1 db 10,'Please enter a word: $'
MSG2 db 10,13,'Not a palindrome$'
MSG3 db 10,13,'Is a palindrome$'
MSG4 db 10,13,'this is the word you enter: $'
STR1 db 33 dup('$')
