; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


;(sayýyý kontrol ediyorum bir sýkýntý yok burada)
mov cl, n
cmp cl, 15
jb error
cmp cl,25 
ja error

;(array 1 e 1 koyuyorum)
mov si, 2
mov array[1], 1
inc dl
mov bl,2;böleni koy
         
         
         
array_fill:
	mov ax,si  ;(countumuz si onu bölmemiz lazim)
	div bl  
	cmp ah,0 ;(kalan sýfýr mý bir mi)
	jne odd
	mov ah, array[si-1]
	add ah, array[si-2] 
    mov array[si],ah ;(iþlem sonuçlarýný koyduk)
    inc si 
    cmp cl,0
    jz end 
loop array_fill
       
         
         
odd:
    mov ah, array[si-1]
    sub ah, array[si-2]
    mov array[si],ah ;(iþlem sonuçlarýný koyduk)
    inc si
    cmp cl,0
    jz end  
loop array_fill

;(error burayla da iþim yok)

error:

  lea dx,MESSAGE

  mov ah,9

  int 21h

end:

ret 

n db 16 
array DB N dup(0) 
MESSAGE DW "Please enter a value between 14 and 26$"

