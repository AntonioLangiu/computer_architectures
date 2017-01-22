LUNG    EQU             100 ; put an upper max to the number of divisors        
        .MODEL small
        .STACK
        .DATA
NUM     DW              16
FACTOR  DW              LUNG DUP(?)
        .CODE
        .STARTUP
        XOR SI, SI
        MOV AX, NUM
        XOR DX, DX      ; we don't need the DX because we are dividing a DW with a DW

        MOV FACTOR[SI], 1 ; 1 is always a factor
        MOV BX, 2       ; use it as divisor
        ADD SI, 2
ciclo:  MOV CX, AX      ; save the dividend
        CMP AX, 1
        JE fine
        DIV BX
        CMP DX, 0
        JNE restore
        MOV FACTOR[SI], AX
        ADD SI, 2
        JMP ciclo
restore: XOR DX, DX
        MOV AX, CX
        INC BX
        JMP ciclo
fine:   NOP             ; check the solution
        .EXIT
        END
