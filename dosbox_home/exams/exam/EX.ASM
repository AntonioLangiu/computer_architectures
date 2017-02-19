        .MODEL small
        .STACK
        .DATA
CAT_TAX DB          00H, 0BH, 019H, 05H
NUM_PUR DB          1
PUR_OBJ DW          02BB0H, 6 DUP(?)
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
        LOOP loop2
        POP CX
        JMP ok
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
        XOR CH, CH
        MOV BP, CX
        
        XOR AH, AH
        ADD TOTAL_DISCOUNT, AX
        MOV BL, BYTE PTR [SI]+1
        
        SUB BL, AL ; in BL I have the net price
        XOR BH, BH
        
        ADD TOTAL_NET_PRICE, BX
        MOV [DI][1], BL
        ; start calculating the total tax due
        XCHG AX, BX
        ; in BX I have the discount and in AX the net price
        
        ADD CAT_TOTAL_NET_PRICE[BP], AX
        ADD CAT_TOTAL_APPL_DISC[BP], BX

        MOV BL, BYTE PTR [SI]
        XOR BH, BH
        SHL BX, 1
        SHL BX, 1
        ; now in BH I have the category
        MOV DH, CAT_TAX[BP]
        AND DH, 00011111B

        XOR DL, DL
        SHR DX, 1

        PUSH AX
        MOV CL, 6
        SHL AX, CL

        MOV BX, DX
        MUL BX
        ; now in DX I have the high part of the result and in AX the low part
        ; I should divide by 100
        MOV BX, 06400H
        DIV BX
        ; now in AX I have the result
        XCHG BX, AX
        POP AX
        ; now I have the net price in AX and tax due in BX
        ; but the tax needs to be shifted
        MOV CL, 6
        SHR BX, CL

        ADD TOTAL_TAX, BX
        ; start calculating the final price
        ADD AX, BX
        ; in Ax I have now the final price
        ADD TOTAL_FINAL_PRICE, AX
        ADD CAT_TOTAL_FINAL_PRICE[BP], AX
        ADD CAT_TOTAL_TAX_DUE[BP], BX

        MOV [DI][2], BL
        MOV [DI][3], AL
        
        ADD DI, 4
        ADD SI, 2
        POP CX
        DEC CX
        NOP
        NOP
        NOP
        NOP

        JNZ loop1

        ; here you should print the result
        .EXIT
        END
