N       EQU         13        
        .MODEL small
        .STACK
        .DATA
IMAGE   DB          01H,01H,01H,02H,03H,01H,03H,03H,03H,03H,03H,02H
COMPRESSED DB       100 DUP(?)
        .CODE
        .STARTUP
        LEA SI, IMAGE

        XOR BX, BX ; use dx as index for compressed vector
        MOV BP, SI
        ADD BP, 13    ; this is the final memory address. You should never go over this element

ciclo:  CMP BP, SI
        JLE exit
        MOV DI, SI
        ADD DI, 1
        MOV AL, [DI]
        CMP AL, [SI]
        JNE neq
        ; they are equal, start counting
equal:  CMP BP, DI
        JL w1
        ADD DI, 1
        MOV AL, [DI]
        CMP AL, [SI]
        JE equal
w1:     DEC DI
        MOV AL, [SI]
        MOV CX, DI
        SUB CX, SI
        ADD CX, 1
        MOV COMPRESSED[BX], CL
        INC BX
        MOV COMPRESSED[BX], AL
        INC BX
        INC DI
        MOV SI, DI
        ; end of the equal algorithm
        JMP ciclo

neq:    CMP BP, DI
        JL w2
        MOV AL, [DI]
        INC DI
        CMP AL, [DI]
        JNE neq
        SUB DI, 2   ; 4 is the size of the two equal elements
w2:     MOV CX, DI
        SUB CX, SI
        MOV COMPRESSED[BX], CL
        OR COMPRESSED[BX], 80H
        INC BX
        ADD CX, 1
copy:   MOV AX, [SI]
        MOV COMPRESSED[BX], AL
        INC BX
        ADD SI, 1
        LOOP copy
        MOV SI, DI ; is the first element not analyzed, because it's equal to the next one
        ADD SI, 1
        JMP ciclo

exit:   NOP
        NOP
        NOP
        NOP
        .EXIT
        END
