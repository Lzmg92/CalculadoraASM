limpiar macro                                                                                   
;sirve para limpiar la pantalla que limpia la pantalla
MOV AH,06
MOV BH,1Ah 
MOV CX,0000 ;inicio del reglon y columna
MOV DX,6080 ;final del reglon y columna
INT 10H
endm    
;----------------------------------------------------------------
colocar macro re, co ;macro que coloca el cursor según las coordenadas dadas
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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; this maro is copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





org 100h

jmp encabezado


; define variables:
        MsjU        DB 'Universidad de San Carlos de Guatemala$'
        MsjFac      DB 'Facultad de Ingenieria$'
        MsjSub      DB 'Arquitectura de Computadores y Ensambladores 1$'
        MsjSem      DB 'Primer Semestre 2016$'
        MsjSec      DB 'Seccion A$'
        MsjNom      DB 'Leslie Fabiola Morales Gonzalez$'
        MsjCar      DB '201314808$'
        MsjPra      DB 'Segunda Practica$' 
        
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
        msg5        db  0dh,0ah ,'thank you for using the calculator! press any key... ', 0Dh,0Ah, '$'
        err1        db  "Operador incorrecto!", 0Dh,0Ah , '$'
        smth        db  " and something.... $"  
        dosdi       db  2

        ; operator can be: '+','-','*','/' or 'q' to exit in the middle.
        opr         db '?'
        
        ; first and second number:
        num1 dw ?
        num2 dw ? 
        tope dw ?


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
    MOV AH,4CH           
    INT 21H  

archivo:    
    limpiar       
    colocar 1,0  
    despliega MsjArc        
    jmp salir 
    
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
    lea dx, msg5
    mov ah, 09h
    int 21h  


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
    
    ;----- GESTION DE OPERACIONES ARITMETICAS
    
    do_plus:
    
    colocar 2,0
    mov ax, num1
    add ax, num2  
    cmp ax,11111111b  
    ja  menuerr
    call print_num    ; print ax value.
    mov num1,ax
    
    jmp menures
    
    
    
    do_minus:
    
    colocar 2,0
    mov ax, num1
    sub ax, num2   
    cmp ax,11111111b  
    ja  menuerr
    call print_num    ; print ax value.
    mov num1,ax
    
    jmp menures
    
    
    
    
    do_mult:
    
    colocar 2,0
    mov ax, num1
    imul num2 ; (dx ax) = ax * num2.
    ;------------------------------------------------------------------ 
    cmp ax,11111111b  
    ja  menuerr
    call print_num    ; print ax value.
    ; dx is ignored (calc works with tiny numbers only).
    mov num1,ax
    
    jmp menures
     
    
    do_div:
    ; dx is ignored (calc works with tiny integer numbers only). 
    colocar 2,0
    mov dx, 0
    mov ax, num1
    idiv num2  ; ax = (dx ax) / num2.
    cmp dx, 0
    jnz approx
    cmp ax,11111111b  
    ja  menuerr
    call print_num    ; print ax value.
    jmp exit
   
    approx:       
    cmp ax,11111111b  
    ja  menuerr
    call print_num    ; print ax value.
    lea dx, smth
    mov ah, 09h    ; output string at ds:dx
    int 21h  
    mov num1,ax
    
    jmp menures
    








;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


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



