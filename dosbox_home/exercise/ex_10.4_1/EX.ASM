SUBBIG  MACRO       NUMA, NUMB, NUMC, OFFSET
        PUSH AX
        MOV AX, WORD PTR NUMA+OFFSET
        SBB AX, WORD PTR NUMB+OFFSET
        MOV WORD PTR NUMC+OFFSET, AX
        POP AX
        ENDM
        .MODEL small
        .STACK
        .DATA
NUMA    DD         100000
NUMB    DD         200000
NUMC    DD         ?
        .CODE
        .STARTUP
        CLC
        SUBBIG      NUMA, NUMB, NUMC, 0
        SUBBIG      NUMA, NUMB, NUMC, 2
        NOP         ; here the result of NUMC should be -100000
        .EXIT
        END
