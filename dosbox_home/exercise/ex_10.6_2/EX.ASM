        .MODEL small
        .STACK
        .DATA
NUM     DW          1000
RES     DD          ?   ; it should become 1000000, so we need 32 bits to store it
        .CODE
        .STARTUP
        MOV AX, NUM
        MUL NUM
        MOV WORD PTR RES, AX
        MOV WORD PTR RES+2, DX
        NOP             ; check the variable RES
        .EXIT
        END
