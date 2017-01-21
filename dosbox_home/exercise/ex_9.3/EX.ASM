LUNG    EQU         20
CAR_A   EQU         "a"
CAR_Z   EQU         "z"
        .MODEL small
        .STACK
        .DATA
STRING  DB          "AbAbAbAbAbAbAbAbAbAb" ; it should be 10
LOWER_CASE DW       ?
        .CODE
        .STARTUP
        XOR BX, BX  ; use BX as accumulator for the lower case
        MOV CX, LUNG
        XOR SI, SI
lp:     CMP STRING[SI], CAR_A ; is CAR_A > [SI]
        JB no                 ; if yes jump
        CMP STRING[SI], CAR_Z ; is CAR_B < [SI]
        JA no                 ; if yes jump
        INC BX
no:     INC SI
        LOOP lp
        MOV LOWER_CASE, BX
        NOP
        .EXIT
        END
