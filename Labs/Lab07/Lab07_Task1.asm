; #start=Emulation Kit.exe#
; Bu direktif Emulation Kit'in kod çalýþtýðýnda otomatik olarak baþlatýlmasýný saðlar.

org 100h     ; COM dosyasý formatý için tipik baþlangýç noktasý

; Veri segmentimizi tanýmlayalým
; Burada rakamlarýn yedi segment kodlarýný tutacak tabloyu ve
; geçici deðiþkenleri tanýmlayacaðýz.

data segment
digit_table db 0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0x40
; index: 0->0, 1->1, 2->2, 3->3, 4->4, 5->5, 6->6, 7->7, 8->8, 9->9, 10->'-'

hour_tens  db ?
hour_ones  db ?
min_tens   db ?
min_ones   db ?
sec_tens   db ?
sec_ones   db ?
data ends

code segment
assume cs:code, ds:data

start:
    ; DS register'ýný veri segmentimize ayarla
    mov ax, data
    mov ds, ax

main_loop:
    ; 1) Sistem saatini al:
    mov ah, 2Ch       ; AH=2Ch fonksiyonu: Saat/Dakika/Saniye alma
    int 21h
    ; Dönen deðerler:
    ; CH = Saat (0-23)
    ; CL = Dakika (0-59)
    ; DH = Saniye (0-59)
    ; DL = Salise (0-99) - kullanýlmayacak

    ; 2) Saat basamaklarýna ayýrma
    ; Saat (CH) -> Onlar ve Birler
    xor ah, ah        ; AH'ý temizle (bölme için)
    mov al, CH         ; AL = CH, saat deðerini AL'a aldýk
    mov bl, 10
    div bl             ; AX / BL -> AL= bölüm, AH= kalan
    ; Þimdi AL = saat_onlar, AH = saat_birler
    mov [hour_tens], al
    mov [hour_ones], ah

    ; Dakikalar (CL) -> Onlar ve Birler
    xor ah, ah
    mov al, CL
    div bl
    mov [min_tens], al
    mov [min_ones], ah

    ; Saniyeler (DH) -> Onlar ve Birler
    xor ah, ah
    mov al, DH
    div bl
    mov [sec_tens], al
    mov [sec_ones], ah

    ; 3) Þimdi 7 segment kodlarýný I/O portlarýna yazalým
    ; Emulation Kit'te 7 segment display adresleri 2030h'dan itibaren olsun
    ; Adres: 2030h -> saat onlar, 2031h -> saat birler, 2032h -> '-',
    ;         2033h -> dakika onlar, 2034h -> dakika birler, 2035h -> '-',
    ;         2036h -> saniye onlar, 2037h -> saniye birler

    mov dx, 2030h
    ; Saat onlar
    mov al, [hour_tens]
    ; digit_table[hour_tens]
    mov bl, [digit_table+al]   ; al=rakam, onu tabloya index olarak kullan
    mov al, bl
    out dx, al

    inc dx
    ; Saat birler
    mov al, [hour_ones]
    mov bl, [digit_table+al]
    mov al, bl
    out dx, al

    inc dx
    ; Tire karakteri ('-')
    ; '-' karakteri tablonun 10. indexinde
    mov al, [digit_table+10]
    out dx, al

    inc dx
    ; Dakika onlar
    mov al, [min_tens]
    mov bl, [digit_table+al]
    mov al, bl
    out dx, al

    inc dx
    ; Dakika birler
    mov al, [min_ones]
    mov bl, [digit_table+al]
    mov al, bl
    out dx, al

    inc dx
    ; Yine '-'
    mov al, [digit_table+10]
    out dx, al

    inc dx
    ; Saniye onlar
    mov al, [sec_tens]
    mov bl, [digit_table+al]
    mov al, bl
    out dx, al

    inc dx
    ; Saniye birler
    mov al, [sec_ones]
    mov bl, [digit_table+al]
    mov al, bl
    out dx, al

    ; 4) Sonsuz döngüye geri dön (her zaman güncel saati al ve yaz)
    jmp main_loop

code ends
end start
