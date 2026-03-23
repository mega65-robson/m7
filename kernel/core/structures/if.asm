; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      if.asm
;      Purpose :   If and IfElse 
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;     Conditionally executes the following word if A is non zero. The form is if [word]
;;
; *******************************************************************************************

        .bytecode   "if"
IfCommand:      
        lda     aRegister
        ora     aRegister+1
        bne     IfSuccess
IfFailed:
        jsr     SkipInstruction
IfSuccess:
        rts

; *******************************************************************************************
;;
;;     Conditionally executes the following word if A is zero. The form is if [word]
;;
; *******************************************************************************************

        .bytecode   "if0"
IfZeroCommand:      
        lda     aRegister
        ora     aRegister+1
        beq     IfSuccess
        bra     IfFailed

; *******************************************************************************************
;;
;;     Conditionally executes the following word if A is positive. The form is if [word]
;;
; *******************************************************************************************

        .bytecode   "if+"
IfPositiveCommand:  
        lda     aRegister+1
        bpl     IfSuccess
        bra     IfFailed

; *******************************************************************************************
;;
;;     Conditionally executes the following word if A is negative. The form is if [word]
;;
; *******************************************************************************************

        .bytecode   "if-"
IfNegativeCommand:  
        lda     aRegister+1
        bmi     IfSuccess
        bra     IfFailed

; *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is non zero, executes word1 otherwise executes word2
;;
; *******************************************************************************************

        .bytecode   "ifelse"
IfelseCommand:      
        lda     aRegister
        ora     aRegister+1
        bne     IfElseSuccess

IfElseFailed:
        jsr     SkipInstruction
        rts

IfElseSuccess:
        jsr     RunOneWord
        jsr     SkipInstruction
        rts

; *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is zero, executes word1 otherwise executes word2
;;
; *******************************************************************************************

        .bytecode   "ifelse0"
IfelseZeroCommand:      
        lda     aRegister
        ora     aRegister+1
        beq     IfElseSuccess
        bra     IfElseFailed

; *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is positive, executes word1 otherwise executes word2
;;
; *******************************************************************************************

        .bytecode   "ifelse+"
IfelsePositiveCommand:  
        lda     aRegister+1
        bpl     IfElseSuccess
        bra     IfElseFailed

; *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is negative, executes word1 otherwise executes word2
;;
; *******************************************************************************************

        .bytecode   "ifelse-"
IfelseNegativeCommand:  
        lda     aRegister+1
        bmi     IfElseSuccess
        bra     IfElseFailed

        .endsection
        