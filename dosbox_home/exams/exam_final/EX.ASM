;*******************************************;
;**************  MACRO  ********************;
;*******************************************;

;*******************************************;
;				PRINTP						;
; Macro to print a dot						;
;*******************************************;
PRINTP 	MACRO
		PUSH AX
		PUSH DX
			XOR DH, DH;
			MOV DL, DOT
			MOV AH, 2
			INT 21H
		POP DX
		POP AX
		ENDM

;*******************************************;
;				PRINTLN						;
; Macro to print a new line					;
;*******************************************;
PRINTLN MACRO
		PUSH AX
		PUSH DX
			XOR DH, DH;
			MOV DL, CR
			MOV AH, 2
			INT 21H

			XOR DH, DH;
			MOV DL, LF
			MOV AH, 2
			INT 21H	
		POP DX
		POP AX
		ENDM
;*******************************************;
;			CONSTANTS						;
;*******************************************;
CR      EQU     13
LF 		EQU		10
DOT		EQU		46
		.MODEL small
        .STACK
        .DATA
;*******************************************;
;           INPUT VARIABLES                 ;
;*******************************************;
CAT_TAX 				DB 00H, 0BH, 019H, 10H
NUM_PUR 				DB 8
PUR_OBJ 				DW 02BB0H, 08B58H, 03AA8H, 0514H
        				DW 0F58H, 011DCH, 02BF8H, 0E300H
;*******************************************;
;           OUTPUT VARIABLES                ;
;*******************************************;
TOTAL_FINAL_PRICE   	DW ?
TOTAL_DISCOUNT      	DW ?
TOTAL_NET_PRICE     	DW ?
TOTAL_TAX          		DW ?
OUTPUT              	DB 8*4 DUP(?)
CAT_TOTAL_FINAL_PRICE 	DW 4 DUP(0)
CAT_TOTAL_TAX_DUE     	DW 4 DUP(0)
CAT_TOTAL_APPL_DISC   	DW 4 DUP(0)
CAT_TOTAL_NET_PRICE   	DW 4 DUP(0)
;*******************************************;
;           MESSAGES                        ;
;*******************************************;
MESS_INV_NUMBER DB "Errore, numero non valido!", 0DH, 0AH, "$"
MESS_OVERFLOW	DB "The number you are trying to convert can't be stored on 32 bit", 0DH, 0AH, "$"
;*******************************************;
;			SUPPORT VARIABLES				;
;*******************************************;
TRANSLATION_VETT    	DB 0, 25, 50, 75
CBUF                	DB 5 DUP(0)

        .CODE
        .STARTUP
; TODO here you should do the input output
; TODO first read all the

        MOV CL, NUM_PUR
        XOR CH, CH

        LEA SI, PUR_OBJ
        LEA DI, OUTPUT

loop1:  MOV BX, [SI]
        XOR AX, AX
        XCHG AH, BH
        AND BL, 03FH
        SHR AX, 1
        SHR AX, 1
        SHL BX, 1
        SHL BX, 1
        MUL BX
        CMP DX, 0
        JE smaller
        PUSH CX
        MOV CX, 14
loop2:  SHR DX, 1
        RCR AX, 1
        LOOP loop2
        POP CX
        JMP ok
smaller: PUSH CX
        MOV CL, 14
        SHR AX, CL
        POP CX
ok:     MOV [DI], AL

        PUSH CX
        MOV CX, [SI]
        SHL CX, 1
        SHL CX, 1
        AND CH, 3
        XOR CH, CL
        XOR CL, CH
        XOR CH, CL
        XOR CH, CH
        SHL CX, 1
        MOV BP, CX

        XOR AH, AH
        ADD TOTAL_DISCOUNT, AX
        MOV BL, BYTE PTR [SI]+1

        SUB BL, AL ; in BL I have the net price
        XOR BH, BH

        ADD TOTAL_NET_PRICE, BX
        MOV [DI][1], BL
        ; start calculating the total tax due
        XCHG AX, BX
        ; in BX I have the discount and in AX the net price

        ADD CAT_TOTAL_NET_PRICE[BP], AX
        ADD CAT_TOTAL_APPL_DISC[BP], BX

        MOV BL, BYTE PTR [SI]
        XOR BH, BH
        SHL BX, 1
        SHL BX, 1
        XOR BL, BL
        XCHG BL, BH
        ; now in BH I have the category
        MOV DH, CAT_TAX[BX]
        AND DH, 00011111B

        XOR DL, DL
        SHR DX, 1

        PUSH AX
        MOV CL, 6
        SHL AX, CL

        MOV BX, DX
        MUL BX
        ; now in DX I have the high part of the result and in AX the low part
        ; I should divide by 100
        MOV BX, 06400H
        DIV BX
        ; now in AX I have the result
        XCHG BX, AX
        POP AX
        ; now I have the net price in AX and tax due in BX
        ; but the tax needs to be shifted
        MOV CL, 6
        SHR BX, CL

        ADD TOTAL_TAX, BX
        ; start calculating the final price
        ADD AX, BX
        ; in Ax I have now the final price
        ADD TOTAL_FINAL_PRICE, AX
        ADD CAT_TOTAL_FINAL_PRICE[BP], AX
        ADD CAT_TOTAL_TAX_DUE[BP], BX

        MOV [DI][2], BL
        MOV [DI][3], AL

        ADD DI, 4
        ADD SI, 2
        POP CX
        DEC CX
        JNZ loop1

; TODO: here you should print the result

;*******************************************;
;               FUNCTIONS                   ;
;*******************************************;

;*******************************************;
;               READ 16                     ;
; This function reads a number from the 	;
; command line and returns it through		;
; the stack									;
; This function return the readed values	;
; in DX										;
;*******************************************;
READ16  PROC near
		LOCAL lab0
		LOCAL lab1
		LOCAL error
		LOCAL fine
        PUSH AX			; save the registers
        PUSH BX
lab0:   XOR DX, DX		; use DX to hold part of the result
lab1:   MOV BX, 10		; store in DX the multiplier
        MOV AH, 1		; set the sys call value
        INT 21H			; sys call
        CMP AL, CR		; check if it's a new line
        JE fine			; if it's return
        CMP AL, '0'		; check if it's a number
        JB error		; if not print an error and iterate
        CMP AL, '9'		; check if it's a number
        JA error		; if not print an error and iterate
        SUB AL, '0'		; now you have in AL the number between 0 and 9
        XCHG AX, BX		
        XOR BH, BH		; now in BX you have the readed number
        MUL DX			; multiply DX with 10
        CMP DX, 0		; if DX is 0 we have an overflow
        JNE error		; because we cant' rapresent the number on 16 bits
        MOV DX, AX		; mov the multiplied number again to DX
        ADD DX, BX		; add the readed number to the previous number
        JC error		; overflow, print the error
        JMP lab1		; loop again
error:  LEA DX, ERR_MESS
        MOV AH, 9		; set the sys call value
        INT 21H			; call sys call
        JMP lab0
fine:   POP BX
        POP AX
        RET
        READ16 ENDP
;*******************************************;
;               READ 32                     ;
; This function reads a number from the 	;
; command line and it saves on 32 bits		;
; register SI, DI							;
; It should be used in this context			;
; because it converts number like 6			;
; to 600000, to be easily converted to		;
; fixed point numbers						;
; It is limited to read at most 6 numers	;
; you can change that parameter				;
; by changing CX							;
;*******************************************;
READ32  PROC near
        LOCAL lab0		; define the labels as local
        LOCAL lab1
        LOCAL error
        LOCAL fine
        PUSH AX			; save the registers
        PUSH CX			; save the registers
        PUSH DX			; save the registers
lab0:   XOR AX, AX
        XOR DX, DX
        XOR DI, DI		; this will be used fot the low part
        XOR SI, SI		; this will be used for the high part
        MOV CX, 6		; CX will be used as index to stopping reading numbers after CX times
lab1:   MOV AH, 1		; set the value for the sys call
        INT 21H			; sys call
        CMP AL, CR		; check if it's a Carriage Return
        JE finalizza    ; finalizza is used to convert numbers to a format compatible to
        CMP CX, 0		; when CX is 0 and the previous char the user is trying to insert an invalid number
        JE error		
        CMP AL, '0'		; check if it's a number
        JB error
        CMP AL, '9'		; check if it's a number
        JA error
        SUB AL, '0'		; now the value readed is in AL. It's between 0 and 9
        DEC CX
        XOR AH, AH		; store the readed number
        PUSH AX
            MOV AX, 10  ; set the multiply factor
            MUL DI		; multiply the low part
            MOV DI, AX	
            PUSH DX		; save the low part
                MOV AX, 10	; reset the multiply factor
                MUL SI		; multiply the high part
                CMP DX, 0	; if DX is not 0 we have an overflow
                JG error	; bacause the number is can't be rapresented on 32 bits
            POP DX
            MOV SI, AX
            ADD SI, DX		; now SI contains the high part
        POP AX			; recover the readed value
        ADD DI, AX		; add it to the low part
        ADC SI, 0		; add a possible carry to the high part SI
        JMP lab1
error:  LEA DX, MESS_INV_NUMBER
        MOV AH, 9		; print the error message
        INT 21H
        JMP lab0		; get another number
finalizza:
        CMP CX, 0		; if CX is not 0 I need to multiply the number by 10 for CX times
        JE fine
loop3:  MOV AX, 10		; set the multiply factor
        MUL DI			; multiply the low part
        MOV DI, AX		; save the low part
        PUSH DX			; save the high part of the multiplication
            MOV AX, 10	; multiply the low part
            MUL SI      ; we should never have an overflow in this situation because it's limited to 2^6
        POP DX			; recover the high part of the first multiplication
        MOV SI, AX		
        ADD SI, DX		; add it to the high part
        LOOP loop3
fine:   POP DX
        POP CX
        POP AX
        RET
READ32 	ENDP
;*******************************************;
;               CONV16                      ;
; This function converts a 32 bit number 	;
; stored in AX and BX to the fractionary 	;
; part of a fixed point number, with 		;
; fractionary part of 6 bits				;
; The result is returned in BX				;
;*******************************************;
CONV6   PROC near
        LOCAL loop1		; define the labels as local
        LOCAL greather
		LOCAL next
        LOCAL overflow
        LOCAL fine
        PUSH AX			; save the registers
        PUSH CX			; save the registers
        PUSH DX			; save the registers
        MOV CX, 6
        XOR BX, BX		; BX will be used to hold the result
						; start convsion
loop1:  SHL AX, 1 		; multiply low part by 2
        RCL DX, 1		; multiply high part by 2 adding carry
        JC overflow  	; if the carry flag is 1 we have an overflow
        SHL BX, 1		; shift BX by one. In the first iteration it has no effect 0<<1 == 0
        CMP DX, 0FH 	; compare high part with 0FH, that is the limit for 10^6
        JA greather		; if it is greather than 0FH the whole number is greather than 10^6
        CMP DX, 0FH 	; compare the high part to check if it's exacly 0FH
        JB next			; if it's below 0FH it cant' be higher than 10^6
        CMP AX, 04240H 	; compare the low part with the limit
        JB next			; if it's below than the number is < 10^6 and we can consider the next
greather:
        OR BL, 01H		; if you are here the number is > 10^6 and you need to set the bit to 1
        SUB AX, 04240H	; subtract the low part of 10^6
        SBB DX, 0FH 	; subtract the high part of 10^6 (you should not have a borrow because it is higher than 10^6)
next:   LOOP loop1
        JMP fine
overflow: 
		LEA DX, MESS_OVERFLOW
		MOV AH, 09		; print message stored in DX
		INT 21H			; call system call
fine:   POP DX
        POP CX
        POP AX
        RET
CONV6   ENDP
;*******************************************;
;				PRINTFP16					;
; This function prints a fixed point on		;
; 16 bits on 2 fract. bits					;
; TODO da dove prende l'input?				;
;*******************************************;
PRINTFP16 PROC NEAR
		CALL TRANSLATE16 	; result in DX : AX
    	CALL PRINT 			; prints a number contained in DX (the integer part)
    	PRINTP 				; prints a point
		XOR DH, DH			; prepare to print the low part
    	MOV DL, AL 			; mov the low part to DL
    	CALL PRINT			; print the low part contained in DL (fractionary)
    	PRINTLN				; prints a new line
		RET 
PRINTFP16 ENDP

;*******************************************;
;				PRINTFP8					;
; This function prints a fixed point 		;
; number stored on 8 bits					;
; It receives the input in AX				;
;*******************************************;
PRINTFP8 PROC NEAR
		CALL TRANSLATE8		; It receives the input in AX and call translate8 to translate it
    	XOR DH, DH 			; set DH to 0
    	MOV DL, AH			; move the integer part to DL
    	CALL PRINT			; prints it
		PRINTP				; prints a dot
		XOR DH, DH			; set DH to 0
    	MOV DL, AL			; moves the fractionary part to DL
   		CALL PRINT			; prints the fractionary part
		PRINTL				; prints a new line
		RET 				
PRINTFP8 ENDP

;*******************************************;
;				TRANSLATE 8					;
; This function receives in AL the value to	;
; translate									;
; The format is zzzzzzvv					;
; where z is the integer part and v the 	;
; fractionary								;
;*******************************************;
TRANSLATE8 PROC NEAR
		PUSH BX				; save registers
		PUSH CX

		XOR AH, AH			; set AH to 0
		XOR BX, BX			; initialize BX
		XOR CX, CX			; initialize CX

		MOV BX, AX			
		AND BL, 00000011B	; apply mask to the number to extract fractionary part

		MOV CL, 6			; shift the the integer part of to AH
		SHL AX, CL			; shift

		MOV AL, BL			; move the fractionary part to AL
		MOV BX, OFFSET TRANSLATION_VETT
		XLAT				; use translation table
							; now in AH you have the integer part and in AL the fractional part,
							; both rapresented in binary
		POP CX				; restore registers
		POP BX
RET
TRANSLATE8 ENDP

;*******************************************;
;				TRANSLATE 16				;
; This functions translates from a 16 bits	;
; fixed point number to binary values.		;
; It receives in AX the the value with 		;
; this format: vvvvvvvvvvvvvvff				;
; and returns in DX the integer part and in ;
; AX the fractionary part					;
;*******************************************;
TRANSLATE16 PROC NEAR
		PUSH BX				; save registers
		PUSH CX		
		XOR BX, BX			; initialize BX
		XOR CX, CX			; initialize CX
		MOV BL, AL			
		AND BL, 00000011B	; apply mask to the low part to obtain the fractionary part
		MOV CL, 2			; shift AX by two to remove the fractionary part
		SHR AX, CL			; shift
		MOV DX, AX			; now in DX you have the integer part
		MOV AL, BL			; now in AL	you have the fractionary part
		MOV BX, OFFSET TRANSLATION_VETT
		XLAT				; apply translation table
		XOR AH, AH			; set AH to 0
		POP CX
		POP BX
		RET
TRANSLATE16 ENDP

;*******************************************;
;				PRINT						;
; Print numbers stored in DX				;
;*******************************************;
PRINT PROC NEAR
		LOCAL loop1
		LOCAL loop2
		PUSH DI				; save registers 
		PUSH AX
		PUSH BX
		PUSH DX
		XOR DI, DI			; initialize DI that will be used as a counter
		MOV AX, DX			; move received number to AX
		XOR DX, DX			
		MOV BX, 10			; set divider
loop1:
		DIV BX				; divide the number by 10
		ADD DL, '0'			; convert the number to ASCII
		MOV CBUF[DI], DL	; move the number to a buffer
		INC DI 				
		XOR DX, DX			; initialize DX
		CMP AX, 0			; while AX != 0 convert the numbers
		JNE loop1
loop2: 	
		XOR DH, DH			; set DH to 0
		DEC DI				; decrement the counter DI
		MOV DL, CBUF[DI]	; print the buffer in reverse order
		MOV AH, 2			; set the sys call number
		INT 21H				; call DOS sys call
		CMP DI, 0			; cycle until DI is equal to 0
		JNE loop2
		
		POP DX				; restore registers
		POP BX
		POP AX
		POP DI
RET
PRINT ENDP

        .EXIT
        END
