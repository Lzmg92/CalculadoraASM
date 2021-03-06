limpiar macro                                                                                   
;sirve para limpiar la pantalla que limpia la pantalla
MOV AH,06
MOV BH,1Ah 
MOV CX,0000 ;inicio del reglon y columna
MOV DX,6080 ;final del reglon y columna
INT 10H
endm    
;----------------------------------------------------------------
colocar macro re, co ;macro que coloca el cursor seg�n las coordenadas dadas
MOV AH,2
MOV BH,00
MOV DH,re ;RENGLON
MOV DL,co ;COLUMNA
INT 10H
endm
;----------------------------------------------------------------
despliega macro mens ;macro para colocar un mensaje en pantalla
LEA DX,mens
MOv AH,9
INT 21H
endm
;----------------------------------------------------------------
newLine macro
    mov ah, 40h
    mov bx, handle
    mov dx, offset endl 
    mov cx, endls
    int 21h 
endm
;----------------------------------------------------------------
    
;----------------------------------------------------------------
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM





org 100h

jmp encabezado

        MsjU        DB 'Universidad de San Carlos de Guatemala$'
        MsjUs       = $ - offset MsjU
        
        MsjFac      DB 'Facultad de Ingenieria$'  
        MsjFacs     = $ - offset MsjFac
        
        MsjSub      DB 'Arquitectura de Computadores y Ensambladores 1$'
        MsjSubs     = $ - offset MsjSub
        
        MsjSem      DB 'Primer Semestre 2016$' 
        MsjSems     = $ - offset MsjSem
        
        MsjSec      DB 'Seccion A$'  
        MsjSecs     = $ - offset MsjSec
        
        MsjNom      DB 'Leslie Fabiola Morales Gonzalez$'  
        MsjNoms     = $ - offset MsjNom
        
        MsjCar      DB '201314808$'      
        MsjCars     = $ - offset MsjCar
        
        MsjPra      DB 'Segunda Practica$'  
        MsjPras     = $ - offset MsjPra
        
        MsjMP       DB 'Menu principal$'
        MsjMP1      DB '    1. Archivo de entrada$'
        MsjMP2      DB '    2. Modo Calculadora$'
        MsjMP3      DB '    3. Calculo de factorial$'
        MsjSal      DB '    4. Salir$'  
        NUMERO      DB '10$'
        CADRES      DB '0000$'  
        
        MsjArc      DB 'Ingrese la direccion del archivo:$' 
        
        MsjC1D      DB 'Ingrese el primer digito$'
        MsjCSi      DB 'Ingrese el signo de la operacion y realizar (+|-|*|/)$'
        MsjC2D      DB 'Ingrese el segundo digito$'   
        MsjCNew     DB '    1. Realizar otro calculo$'
        MsjCVol     DB '    2. Volver$'
        MsjCSal     DB '    3. Salir$'    
        
        MsjErr      DB  'ERROR$'
        MsjEVol     DB  '   1.Volver$'
        MsjESal     DB  '   2.Salir$'  
                
        MsjIFa      DB 'Ingrese el valor para calcular factorial$'
                                          
        MsjFin      DB 'Salir: Programa finalizado$'
        msg1        db 'enter first number: $'
        msg2        db "enter the operator:    +  -  *  /     : $"
        msg3        db "enter second number: $"
        msg4        db 'El resultado es: $' 
        err1        db  "Operador incorrecto!", 0Dh,0Ah , '$'
        smth        db  " and something.... $" 
        divr        db  "=>$" 
        dosdi       db  2
        clec        db  2 

        dir1        db "c:\test1", 0
        dir2        db "test2", 0
        dir3        db "newname", 0
        file1       db "c:\test1\file1.txt", 0
        file2       db "c:\test1\newfile.txt", 0
        file3       db "t1.txt", 0
        handle      dw ?
        
        text        db "lazy dog jumps over red fox."
        text_size   = $ - offset text
        text2       db "hi!"
        text2_size  = $ - offset text2
        
        endl        DB  0Dh,0Ah
        endls       = $ - offset endl
        
        file        db "c:\input.txt", 0
        BUF         db ?
        opr         db '?'

        num1        dw ?
        num2        dw ? 
        tope        dw ? 
        fpila       dw ? 
       


encabezado:
    limpiar
    colocar 0,0
    despliega MsjU      
    colocar 1,0
    despliega MsjFac      
    colocar 2,0
    despliega MsjSub      
    colocar 3,0
    despliega MsjSem
    colocar 4,0
    despliega MsjSec
    colocar 5,0
    despliega MsjNom
    colocar 6,0
    despliega MsjCar
    colocar 7,0
    despliega MsjPra
    
    colocar 9,0
    despliega MsjMP
    colocar 10,0   
    despliega MsjMP1
    colocar 11,0
    despliega MsjMP2
    colocar 12,0
    despliega MsjMP3
    colocar 13,0
    despliega MsjSal
    colocar 14,0
    
    mov ah,01                   
    int 21h  
                   
    mov bl,al
    limpiar 
    
    cmp bl,'1'
    je  archivo
    cmp bl,'2'
    je  calcu
    cmp bl,'3'
    je fact 
                
salir:            
    colocar 2,0  
    despliega MsjFin   
    
    mov ax, cs
    mov dx, ax
    mov es, ax
    
    ; create and open file: c:\emu8086\vdrive\C\test1\file1.txt
    mov ah, 3ch
    mov cx, 0
    mov dx, offset file1
    int 21h
    jc err
    mov handle, ax 
    
    ; write to file:
    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjU 
    mov cx, MsjUs
    dec cx
    int 21h  
      
    newLine  
    
    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjFac 
    mov cx, MsjFacs
    dec cx
    int 21h         

    newLine                  
   
    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjSub 
    mov cx, MsjSubs
    dec cx
    int 21h
         
    newLine   
    
    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjSem 
    mov cx, MsjSems
    dec cx
    int 21h 

    newLine   
   
    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjSec 
    mov cx, MsjSecs
    dec cx
    int 21h 
    
    newLine

    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjNom 
    mov cx, MsjNoms
    dec cx
    int 21h 

    newLine

    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjCar 
    mov cx, MsjCars
    dec cx
    int 21h 

    newLine

    mov ah, 40h
    mov bx, handle
    mov dx, offset MsjPra 
    mov cx, MsjPras
    dec cx
    int 21h          
    
    newLine
    ; close c:\emu8086\vdrive\C\test1\file1.txt
    mov ah, 3eh
    mov bx, handle
    int 21h
    err:
    nop
           
    MOV AH,4CH           
    INT 21H 
    ret 

archivo:    
    limpiar       
    colocar 1,0  
    despliega MsjArc
    
    mov dx, offset file ; address of file to dx
    mov al,0 ; open file (read-only)
    mov ah,3dh
    int 21h ; call the interupt
    jc  menuerr ; if error occurs, terminate program
    mov bx,ax ; put handler to file in bx
    
    mov cx,1 ; read one character at a time
    
read:
    lea dx, BUF
    mov ah,3fh ; read from the opened file (its handler in bx)
    int 21h
    CMP AX, 0 ; how many bytes transfered?
    JZ afin ; end program if end of file is reached (no bytes left).
    mov al, BUF ; char is in BUF, send to ax for printing (char isin al) 
    mov ah,0eh ; print character (teletype).
    int 10h
    cmp al, ','
    je  coma
    cmp al, '*'
    je  amulti
    cmp al, "+" 
    je  asuma
    cmp al, "-"
    je  aresta
    cmp al, "/"
    je  adiv
    jmp cknum 
coma:     
    mov clec,2
    jmp read

cknum:
    dec clec
    cmp al,00110000b
    jb  read 
    cmp al,00111001b
    ja  read  
        
    mov ah,0
    sub al,30h
    
    cmp clec,0
    je  fulln
    mov dx,10d
    
    mul dx 
    mov num1,ax
    jmp read
    
 fulln:
    add ax, num1    
    push ax  
    jmp read

afin:  
    mov ah, 1      
    int 21h
    jmp encabezado

amulti: 
    despliega  divr
    pop ax
    pop dx 
    mul dx      
    push ax 
    call print_num
    jmp read
    
asuma:     
    despliega  divr   
    pop ax
    pop dx 
    add ax,dx      
    push ax 
    call print_num
    jmp read

aresta: 
    despliega  divr
    pop ax
    pop dx 
    sub dx,ax      
    push dx 
    mov ax,dx
    call print_num 
    jmp read 
    
adiv: 
    despliega  divr 
    pop ax
    pop dx 
    div dx      
    push ax 
    call print_num 
    jmp read

    
fact: 
    limpiar       
    colocar 1,0  
    despliega MsjIFa 
    colocar 2,0 
   
    MOV  dosdi, 1 
    call scan_num
    
    cmp cx,0
    jb menuerr
    cmp cx,7
    ja menuerr
    mov tope,cx
    limpiar
    mov cx, tope              
    mov num1,01b 
    mov num2,10b
    mov ax,num1
ini:           
    cmp num2,cx
    jbe  inst   
    jmp fin 
inst:  
    imul num2             
    mov  num1,ax        
    inc  num2           
    jmp  ini

fin:
    call print_num     
    jmp menures 
     

calcu:     
    limpiar
    colocar 0,0
    despliega MsjC1D
    
    colocar 1,0    
    MOV  dosdi, 2
    call scan_num           ;guardar el numero en cx
    mov num1, cx            ;guardar el numero en la variable 1
     
again:     
    limpiar
    colocar 0,0
    despliega MsjCSi
    
    colocar 1,0 

    mov ah, 1               ;obtener el caracter del simbolo y guardarlo en opr
    int 21h
    mov opr, al

    cmp opr, 'q'            ; q - exit in the middle.
    je exit
    
    cmp opr, '*'            ; verificar que el operador sea valido
    jb wrong_opr
    cmp opr, '/'
    ja wrong_opr

    limpiar
    colocar 0,0
    despliega MsjC2D
    
    colocar 1,0
    
    MOV  dosdi, 2 
    call scan_num           ;guardar el segundo digito en cx
    mov num2, cx            ;guardar cx en variable 2
    
    limpiar
    lea dx, msg4
    mov ah, 09h             ;mensaje del resultado
    int 21h  

    ;----DIRIGE A LAS ETIQUETAS PARA REALIZAR LOS CALCULOS-------------------
    cmp opr, '+'
    je do_plus
    
    cmp opr, '-'
    je do_minus
    
    cmp opr, '*'
    je do_mult
    
    cmp opr, '/'
    je do_div


    ; none of the above.... error
    wrong_opr:
    lea dx, err1
    mov ah, 09h     ; output string at ds:dx
    int 21h  


    exit:
    ; output of a string at ds:dx
    jmp menuerr

    ; wait for any key...
    mov ah, 0
    int 16h


    ret  ; return back to os.  
    
    
menures:
    colocar 4,0
    despliega MsjCNew
    colocar 5,0
    despliega MsjCVol
    colocar 6,0
    despliega MsjCSal
    colocar 7,0
    mov ah,01                   
    int 21h  
                   
    mov bl,al
    limpiar 
    
    cmp bl,'1'
    je  again
    cmp bl,'2'
    je  encabezado
    jmp salir   
    
    
menuerr:
    colocar 2,0
    despliega MsjErr
    colocar 4,0
    despliega MsjEVol
    colocar 5,0
    despliega MsjESal
    colocar 6,0
    mov ah,01                   
    int 21h  
                   
    mov bl,al
    limpiar 
    
    cmp bl,'1'
    je  encabezado
    jmp salir
    
    ;-------------- GESTION DE OPERACIONES ARITMETICAS
    
do_plus:    
    colocar 2,0
    mov ax, num1
    add ax, num2  
    cmp ax,11111111b  
    ja  menuerrd
    jmp pdres   
       
do_minus:    
    colocar 2,0
    mov ax, num1
    sub ax, num2   
    cmp ax,11111111b  
    ja  menuerrd
    jmp pdres   
    
do_mult:    
    colocar 2,0
    mov ax, num1
    imul num2 ; (dx ax) = ax * num2.
    ;------------------------------------------------------------------ 
    cmp ax,11111111b  
    ja  menuerrd
    jmp pdres
     
    
do_div: 
    colocar 2,0
    mov dx, 0
    mov ax, num1
    idiv num2  ; ax = (dx ax) / num2.
    cmp dx, 0
    jnz approx   
    cmp ax,11111111b  
    ja  menuerrd
    jmp pdres 
   
approx:       
    cmp ax,11111111b  
    ja  menuerr
    call print_num    ; print ax value.
    lea dx, smth
    mov ah, 09h    ; output string at ds:dx
    int 21h  
    mov num1,ax    
    jmp menures
    
menuerrd:
    cmp ax,1111111111111111b
    ja  menuerr
    cmp ax, 1111111100000001b
    ja  pdres
    jmp menuerr
    
pdres:
    call print_num    ; print ax value.
    mov num1,ax  
    jmp menures


; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit   
        
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       

ok_digit:

        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.
        dec     dosdi    
        nop
        nop
        nop 
        nop 
        nop
        CMP     dosdi, 0 
        JE      stop_input          
        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP





; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP



; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.







GET_STRING      PROC    NEAR
PUSH    AX
PUSH    CX
PUSH    DI
PUSH    DX

MOV     CX, 0                   ; char counter.

CMP     DX, 1                   ; buffer too small?
JBE     empty_buffer            ;

DEC     DX                      ; reserve space for last zero.


;============================
; Eternal loop to get
; and processes key presses:

wait_for_key:

MOV     AH, 0                   ; get pressed key.
INT     16h

CMP     AL, 0Dh                  ; 'RETURN' pressed?
JZ      exit_GET_STRING


CMP     AL, 8                   ; 'BACKSPACE' pressed?
JNE     add_to_buffer
JCXZ    wait_for_key            ; nothing to remove!
DEC     CX
DEC     DI
PUTC    8                       ; backspace.
PUTC    ' '                     ; clear position.
PUTC    8                       ; backspace again.
JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX          ; buffer is full?
        JAE     wait_for_key    ; if so wait for 'BACKSPACE' or 'RETURN'...

        MOV     [DI], AL
        INC     DI
        INC     CX
        
        ; print the key:
        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key
;============================

exit_GET_STRING:

; terminate by null:
MOV     [DI], 0

empty_buffer:

POP     DX
POP     DI
POP     CX
POP     AX
RET
GET_STRING      ENDP



