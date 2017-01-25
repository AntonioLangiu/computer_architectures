NUM     EQU             8       ; you can't use an odd number
MIN     EQU             07H
        .MODEL small
        .STACK
        .DATA
;TIMES   DB              NUM DUP (?,?,?)
TIMES   DB              08H, 00H, 06H
        DB              07H, 0EH, 05H
        DB              06H, 00H, 05H
        DB              05H, 0EH, 34H
        DB              04H, 00H, 34H
        DB              03H, 00H, 04H
        DB              02H, 0FFH, 01H
        DB              01H, 00H, 01H
STANDINGS DB            NUM DUP(?,?,?)
DIFF_PREV DW            NUM DUP(?)
        .CODE
        .STARTUP
        ; start copying the string to the new vector to avoid changing the old vector
        PUSH DS
        POP ES
        LEA SI, TIMES
        LEA DI, STANDINGS
        MOV CX, NUM*3 ; the numeber must be even
        CLD             ; move forward
        REP MOVSW
        ; now set for SI and DI the same string
        MOV DX, 0
cicloe: MOV CX, NUM
        LEA SI, STANDINGS
        LEA DI, STANDINGS+3
        SUB CX, DX
        PUSH DX
ciclo:  PUSH CX
        MOV AX, [SI]
        MOV BH, [SI+2]
        MOV CX, [DI]
        MOV DH, [DI+2]
        ; compare minutes
        MOV BL, BH
        AND BL, MIN
        MOV DL, DH
        AND DL, MIN
        CMP BL, DL
        JL next
        JG switch
        ; comparing seconds
        SHR AH, 1
        RCR BH, 1
        SHR CH, 1
        RCR DH, 1
        PUSH CX
        MOV CL, 2
        SHR BH, CL
        SHR DH, CL
        POP CX
        CMP BH, DH
        JL next
        JG switch
        CMP AH, CH
        JL next
switch: MOV AX, [DI]
        MOV BH, [DI+2]
        XCHG AX, [SI]
        XCHG BH, [SI+2]
        XCHG AX, [DI]
        XCHG BH, [DI+2]
        ; end switch
next:   ADD SI, 3
        ADD DI, 3
        POP CX
        LOOP ciclo
        POP DX
        INC DX
        CMP DX, NUM-1
        JLE cicloe
        NOP
;*********** START ITEM 2 **************;
        XOR SI, SI
        XOR DI, DI
        MOV CX, NUM
        
ciclo2: PUSH CX

        MOV WORD PTR DIFF_PREV, 0
        MOV AX, WORD PTR STANDINGS[SI]
        MOV BH, STANDINGS[SI+2]
        MOV CX, WORD PTR STANDINGS[SI+3]
        MOV DH, STANDINGS[DI+5]
        ; diff for minutes
        MOV BL, BH
        MOV DL, DH
        AND BL, MIN
        AND DL, MIN
        SUB DL, BL          ; in DL I have the difference in minutes
        ; diff for seconds
        SHR AH, 1
        RCR BH, 1
        SHR CH, 1
        RCR DH, 1
        SHR BH, 1
        SHR BH, 1
        SHR DH, 1
        SHR DH, 1

        SUB DH, BH         ; in DH I have the difference in seconds
        JNL ok
        DEC DL             ; remove one to the minutes
        ADD DH, 60         ; and change the seconds to the correct value
ok:
        ; diff of milliseconds
        SUB CH, AH         ; in CH I have the difference in milliseconds
        JNL ok2
        DEC DH
        ADD AH, 60
ok2:
        ; start moving values to AX
        XOR AX, AX
        XOR AL, DL          ; move minutes
        
        MOV CL, 3
        SHL DH, CL
        ; now in the carry I should have the first bit, that needs to to be added to CH
        RCL CH, 1
        XOR AL, DH          ; move seconds
        MOV AH, CH
        XCHG AH, AL 
        MOV DIFF_PREV[SI+1], AX

        ADD SI, 3
        INC DI
        POP CX
        LOOP ciclo2

        NOP
        NOP
        NOP
        NOP
        .EXIT
        END
