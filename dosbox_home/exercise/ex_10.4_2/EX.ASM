SUBBIG  MACRO       VAL1, VAL2, RES, OFFSET
        PUSH AX
        MOV AX, WORD PTR VAL1+OFFSET
        SBB AX, WORD PTR VAL2+OFFSET
        MOV WORD PTR RES+OFFSET, AX
        POP AX
        ENDM
        .MODEL small
        .STACK
        .DATA
NUMA    DQ              100000000000
NUMB    DQ              200000000000
NUMC    DQ      ? ;RES=-100000000000
        .CODE
        .STARTUP
        CLC
        SUBBIG      NUMA, NUMB, NUMC, 0
        SUBBIG      NUMA, NUMB, NUMC, 2
        SUBBIG      NUMA, NUMB, NUMC, 4
        SUBBIG      NUMA, NUMB, NUMC, 6
        NOP         ; check the result, it should be -100000000000
        .EXIT
        END
