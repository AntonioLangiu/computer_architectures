        .MODEL small
        .STACK
        .DATA
PR_MSG   DB             "Please insert two numbers", 0DH, 0AH, "$"
NO_WIN  DB              "There is no winner this time", 0DH, 0AH, "$"
USER_MSG DB             "The winner is: the user", 0DH, 0AH, "$"
COMP_MSG DB             "The winner is: the computer! Sorry!", 0DH, 0AH, "$"
TWO_WIN DB              "There are two winners!", 0DH, 0AH, "$"
MSG     DW          NO_WIN
        DW          USER_MSG
        DW          COMP_MSG
        DW          TWO_WIN
        .CODE
        .STARTUP
        ; Get the numbers from the user
        LEA DX, PR_MSG
        MOV AH, 09H
        INT 21H
        MOV AH, 01H
        INT 21H
        MOV BH, AL      ; In BH I have the first number of the user
        SUB BH, 30H     ; convert the ascii to integer
        MOV AH, 01H
        INT 21H
        MOV BL, AL      ; In BL I have the second numebr of the user
        SUB BL, 30H     ; convert the ascii to integer
        ; Generate 2 random numbers
        MOV AH, 2CH     ; call DOS get time
        INT 21H         ; it saves the time in DX 
        MOV AL, DL      ; move the time into AX
        CBW
        MOV CL, 06H       ; set CL as divisor (6)
        DIV CL          ; divide by CL and get the rest
        MOV CH, AH      ; USE CH as storage for the computer's first number
        PUSH CX
        MOV AH, 2CH     ; generate a second time
        INT 21H     
        MOV AL, DL      ; move time to AX to be able to divide
        CBW
        POP CX
        DIV CL          ; divide by 5
        MOV CL, AH      ; get the rest
        ; Now I have all the values in the BX and CX registers
        ; I need to compare to see who is the winner
        XOR AX, AX
        CMP BL, CH
        JNE u_fail
        MOV AL, 01H
u_fail: CMP BH, CL
        JNE c_fail
        OR AL, 02H
c_fail: ; start the comparison
        MOV CL, 2
        MUL CL          ; I need to multiply the value of AL by 2
        MOV DI, AX
        MOV DX, MSG[DI]
        MOV AH, 09H
        INT 21H
        .EXIT
        END
