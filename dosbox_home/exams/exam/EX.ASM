        .MODEL small
        .STACK
        .DATA
CAT_TAX DB          4 DUP(?)
NUM_PUR DB          ?
PUR_OBJ DW          8 DUP(?)
; output variables
TOTAL_FINAL_PRICE   DW ?
TOTAL_DISCOUNT      DW ?
TOTAL_NET_PRICE     DW ?
TOTAL_TAX           DW ?
OUTPUT                 DB 8*4 DUP(?)
CAT_TOTAL_FINAL_PRICE DW 4 DUP(0)
CAT_TOTAL_TAX_DUE     DW 4 DUP(0)
CAT_TOTAL_APPL_DISC   DW 4 DUP(0)
CAT_TOTAL_NET_PRICE   DW 4 DUP(0)
        .CODE
        .STARTUP
        MOV CL, NUM_PUR
        XOR CH, CH

        LEA SI, PUR_OBJ
        LEA DI, OUTPUT

loop1:  MOV BX, [SI]
        XOR AX, AX
        XCHG AH, BH
        AND BL, 03FH
        SHR AX, 1
        SHR AX, 1
        SHL BX, 1
        SHL BX, 1
        MUL BX
        CMP DX, 0
        JE smaller
        PUSH CX
        MOV CX, 14
loop2:  SHR DX, 1
        RCR AX, 1
        CMP DX, 0
        JNE loop2
        JMP ok
        POP CX
smaller: PUSH CX
        MOV CL, 6
        SHR AX, CL
        POP CX
ok:     MOV [DI], AL
        
        PUSH CX
        MOV CX, [SI]
        SHL CX, 1
        SHL CX, 1
        AND CH, 3
        XOR CH, CL
        XOR CL, CH
        XOR CH, CL
        
        XOR AH, AH
        ADD TOTAL_DISCOUNT, AX
        MOV BL, BYTE PTR [SI]+1
        
        SUB BL, AH ; in BL I have the net price
        XOR BH, BH
        
        ADD TOTAL_NET_PRICE, BX
        ; start calculating the total tax due
        XCHG AX, BX
        ; in BX I have the discount and in AX the net price
        
        ADD CAT_TOTAL_NET_PRICE[CX], AX
        ADD CAT_TOTAL_APPL_DISC[CX], BX

        MOV BL, BYTE PTR [SI]
        XOR BH, BH
        SHL BX, 1
        SHL BX, 1
        ; now in BH I have the category
        MOV DH, CAT_TAX[BX]
        AND DH, 00011111B

        XOR DL, DL
        SHR DX, 1

        MOV BX, DX
        MUL BX
        ; now in DX I have the high part of the result and in AX the low part
        ; I should divide by 100
        PUSH AX
        MOV BX, 100
        DIV BX
        ; now in AX I have the result
        XCHG BX, AX
        POP AX
        ; now I have the net price in AX and tax due in BX
        ADD TOTAL_TAX, BX
        ; start calculating the final price
        ADD AX, BX
        ; in Ax I have now the final price
        ADD TOTAL_FINAL_PRICE, AX
        ADD CAT_TOTAL_FINAL_PRICE[BP], AX
        ADD CAT_TOTAL_TAX_DUE[BP], BX

        PUSH CX
        MOV CL, 6
        SHR AX, CL
        SHR BX, CL
        POP CX
        MOV [DI][2], BX
        MOV [DI][3], AX
        
        ADD DI, 4*2
        ADD SI, 2
        POP CX
        DEC CX
        JNZ loop1

        ; here you should print the result
        .EXIT
        END
