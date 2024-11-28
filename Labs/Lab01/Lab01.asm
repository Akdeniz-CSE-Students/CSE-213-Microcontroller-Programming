name "Lab-01 -- Yahya Efe Kurucay - 22.10.2024"

org 100h

mov ax, 2000h  ; Data segment baþlangýç adresi
mov ds, ax     ; DS kaydýný ayarla

mov cx, 5      ; Döngü sayýsý N = 5
mov si, 0      ; Baþlangýç ofseti
mov al, 1      ; Ýlk deðer 1

start:
mov [2000h + si], al ; Belleðe AL'deki sayýyý yaz
inc si               ; Bellek adresini artýr
inc al               ; AL'deki sayýyý artýr
loop start           ; Döngüyü tekrar et

hlt

  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
