
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

mov cx, N

sub cx,2

mov bx,2

myFunction:

    xor dx,dx
    
    mov ax,N                   
    
    div bx
    
    cmp dx,0
    
    je end
    
    inc bx

loop myFunction

mov ah,2

mov dl, '1'

int 21h

ret

end:
    
    mov isPrime,0
    
    mov ah,2

    mov dl, '0'

    int 21h
    
    ret

N dw 5

isPrime dw 1



