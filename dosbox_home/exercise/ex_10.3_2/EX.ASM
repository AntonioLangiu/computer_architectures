        ; the register are of 16 bit so to sum 64 bits I need to split
        ; the number in four parts. Let's do it with a macro
SUMBIG  MACRO       NUMA, NUMB, NUMC, OFFSET
        PUSH AX
        MOV AX, WORD PTR NUMA+OFFSET
        ADC AX, WORD PTR NUMB+OFFSET
        MOV WORD PTR NUMC+OFFSET, AX
        POP AX
        ENDM
        .MODEL small
        .STACK
        .DATA
NUMA    DQ          50000000000 ; 5E11
NUMB    DQ          50000000000 ; 5E11
NUMC    DQ          ?       ; the result should be 10E11
        .CODE
        .STARTUP
        CLC
        SUMBIG      NUMA, NUMB, NUMC, 0
        SUMBIG      NUMA, NUMB, NUMC, 2
        SUMBIG      NUMA, NUMB, NUMC, 4
        SUMBIG      NUMA, NUMB, NUMC, 6
        NOP
        NOP         ; here the value of NUMC should be 10E11
        .EXIT
        END
