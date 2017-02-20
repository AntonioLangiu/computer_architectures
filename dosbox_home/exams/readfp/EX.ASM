CR      EQU     13
        .MODEL small
        .STACK
        .DATA
;INPUT   DD          984375    ; 0F0537H
INPUT   DD           500000    ; 020H
ERR_MESS DB "Errore, numero non valido!", 0DH, 0AH, "$"
        .CODE
        .STARTUP
        XOR AX, AX ; non serve a un cazzo
        CALL READ32
        MOV CX, 6
        XOR BX, BX
        
; inizio conversione
        MOV AX, DI ; parte bassa
        MOV DX, SI ; parte alta
        
loop1:  SHL AX, 1 ; moltiplicazione per 2
        RCL DX, 1
        JC overflow  ;SECONDO ME NON PUò ESSERCI
        SHL BX, 1

        CMP DX, 0FH ; compara parte alta
        JA maggiore
        
        CMP DX, 0FH ;compara parte alta
        JB next
        ; sei qui' solo se la parte alta è uguale al limite di un m
        CMP AX, 04240H ; compara parte bassa
        JB next
        
maggiore:
        ; se sei quà allora è maggiore di 10^6
        OR BL, 01H
        SUB AX, 04240H
        SBB DX, 0FH ; può andare in borrow?
        JMP next
next:   LOOP loop1

overflow: NOP

done:   
; here you should do the output

JMP okok

; inizio definizione procedure        
READ32  PROC near
        PUSH AX
        PUSH BX
        PUSH CX
        PUSH DX
lab00:  XOR AX, AX
        XOR DX, DX
        XOR DI, DI
        XOR SI, SI
        MOV CX, 6
lab01:  MOV BX, 10
        MOV AH, 1
        INT 21H
        CMP AL, CR
        JE finalizza
        CMP CX, 0
        JE error1
        CMP AL, '0'
        JB error1
        CMP AL, '9'
        JA error1
        SUB AL, '0'
        ; abbiamo il valore letto tra 0 e 9 in AL
        DEC CX
        XOR AH, AH
        PUSH AX
            MOV AX, 10
            MUL DI
            MOV DI, AX
            PUSH DX; salvo la parte alta della prima moltiplicazione
                MOV AX, 10
                MUL SI
                CMP DX, 0
                JG error1
            POP DX; la parte alta sarà sempre a zero in teoria
            MOV SI, AX
            ADD SI, DX
        POP AX; recupera il numero letto
        ADD DI, AX
        ADC SI, 0
        JMP lab01
error1:  LEA DX, ERR_MESS
        MOV AH, 9
        INT 21H
        JMP lab00
finalizza:
        CMP CX, 0
        JE fine1
loop3:  MOV AX, 10
        MUL DI
        MOV DI, AX
        PUSH DX; salvo la parte alta della prima moltiplicazione
            MOV AX, 10
            MUL SI
            CMP DX, 0
            JG error1
        POP DX; la parte alta sarà sempre a zero in teoria
        MOV SI, AX
        ADD SI, DX
        LOOP loop3
fine1:  POP DX 
        POP CX
        POP BX
        POP AX
        RET
        READ32 ENDP
okok: NOP
        NOP
        NOP
        .EXIT
        END
