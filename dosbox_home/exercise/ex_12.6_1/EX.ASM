; There is an easy way to do this program but this implementation
; is done to test the LODSB operation
LUNG    EQU         100
        .MODEL small
        .STACK
        .DATA
STRING  DB          LUNG DUP(?)
NUMBER  DW          ?
        .CODE
        .STARTUP
        MOV CX, LUNG
        LEA SI, STRING
        XOR DX, DX
        CLD
ciclo:  LODSB
        CMP AL, " "
        JNE next
        INC DX
next:   LOOP ciclo
        MOV NUMBER, DX
        .EXIT
        END
