CALC    MACRO REG1 ; REG1 SHOULD BE A 8 BIT REGISTER
        LOCAL nextdh, next
        XOR DX, DX
        MOV DL, REG1
        SHL DX, CL
        SHR DL, CL
        CMP DL, 5
        JL nextdh
        ADD DL, 3
nextdh: CMP DH, 5
        JL next
        ADD DH, 3
next:   SHL DL, CL
        SHR DX, CL
        MOV REG1, DL
        ENDM
        .MODEL small
        .STACK
        .DATA
INPUT_BIN DW        0FFFFH
OUTPUT_BCD DB       3 DUP(?)
        .CODE
        .STARTUP
        MOV SI, INPUT_BIN
        XOR DI, DI
        XOR BX, BX  ; 1
        XOR AX, AX  ; 2
        MOV CL, 4

ciclo:  SHL SI, 1
        RCL BX, 1
        RCL AL, 1
        CALC BL
        CALC BH
        CALC AL
        INC DI
        CMP DI, 16
        JL ciclo
        ; now copy the result
        MOV OUTPUT_BCD, BL
        MOV OUTPUT_BCD+1, BH
        MOV OUTPUT_BCD+2, AL
        NOP
        NOP
        NOP
        .EXIT
        END
