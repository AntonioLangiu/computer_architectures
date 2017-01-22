        .MODEL small
        .DATA
NUMA    DD          1000000
NUMB    DD          1000000
NUMC    DD          ?
        .CODE
        .STARTUP
        MOV AX, WORD PTR NUMA
        ADD AX, WORD PTR NUMB   ; if the number is bigger than the number that
                                ; can be rappresented on 16 bits, than the carry
                                ; flag is setted and ADC will use it in the next sum
        MOV WORD PTR NUMC, AX
        MOV AX, WORD PTR NUMA+2
        ADC AX, WORD PTR NUMB+2
        ADD WORD PTR NUMC+2, AX
        NOP                     ; here the value of NUMC should be 2000000
        .EXIT
        END
