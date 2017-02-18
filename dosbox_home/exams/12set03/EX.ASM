        .MODEL small
        .STACK
        .DATA
RECORDS  DB              02H, 75H, 02H, 0B2H
RATES    DB              10, 20, 30
; OUTPUT
DURATION_OF_RENTAL DW ?
COST_TO_BE_CHARGED DW ?
        .CODE
        .STARTUP
        MOV AH, RECORDS
        MOV AL, RECORDS+1
        MOV BH, RECORDS+2
        MOV BL, RECORDS+3

        AND AH, 3FH
        AND BH, 3FH
        MOV CL, 5
        SHR AX, CL
        SHR BX, CL

        SUB BX, AX 
        MOV CX, BX
        ; in CX I have the number of days

        MOV AL, RECORDS+1
        MOV BL, RECORDS+3
        AND AL, 1FH
        AND BL, 1FH
        CMP AL, BL
        JLE lower
        DEC CX
        ADD BL, 24
lower:  SUB BL, AL
        ; in BL I have the number of hours

        ; now in BL I have the number of hours and in CX the number of days

        ; now create the first result
        MOV AX, CX
        MOV BH, 7
        DIV BH
        ; now in AH i have the number of days (< 7) and in AL the number of weeks
        ; AH days
        ; AL weeks
        ; BL hours
        MOV DH, AL
        AND DH, 3FH
        MOV DL, AH
        MOV CL, 5
        SHR DL, CL
        AND BL, 1FH
        XOR DL, BL
        ; now in DX I have the solution
        MOV DURATION_OF_RENTAL, DX

        MOV COST_TO_BE_CHARGED, 0
        ; use DX as a temporary variable for the sum
        MOV CX, AX
        ; CH days
        ; CL weeks
        ; BL hours
        XOR AX, AX
        MOV AL, RATES
        MUL BL
        ; INT AX i have the hourly cost
        ; if AH is not null than the cost is greather than the daily cost and i can add a day
        CMP AH, 0
        JNE add_day
        CMP AL, RATES+1
        JGE add_day
        ADD COST_TO_BE_CHARGED, AX
        JMP calc_day
add_day: INC CH
calc_day: MOV AL, RATES+1
        MUL CH
        CMP AH, 0
        JNE add_week
        CMP AL, RATES+2
        JGE add_week
        ADD COST_TO_BE_CHARGED, AX
        JMP calc_week
add_week: INC CL
calc_week: MOV AL, RATES+2
        MUL CL
        ADD COST_TO_BE_CHARGED, AX
        
        NOP
        NOP
        NOP
        NOP
        NOP
        .EXIT
        END
