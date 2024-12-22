


org 100h


INF:
; add your code here    
call GET_NUMBER

JMP INF

GET_NUMBER:
mov ah,01
INT 21H
mov ah,0



ret


