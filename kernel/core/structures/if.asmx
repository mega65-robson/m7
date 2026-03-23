// *******************************************************************************************
// *******************************************************************************************
//
//      Name :      if.asm
//      Purpose :   If and IfElse 
//      Date :      23rd March 2026
//      Author :    Paul Robson (paulrobsons.org.uk)
//
// *******************************************************************************************
// *******************************************************************************************

        .section    code

// *******************************************************************************************
;;
;;     Conditionally executes the following word if A is non zero. The form is if [word]
;;
// *******************************************************************************************

        +alignword
IfCommand:      ;; code:if
        ldq     aRegister
        bne     IfSuccess
IfFailed:
        lda     #4
        jsr     AdvanceProgramCounter
IfSuccess:
        +donext

Const0:
        !32     0        

// *******************************************************************************************
;;
;;     Conditionally executes the following word if A is zero. The form is if [word]
;;
// *******************************************************************************************

        +alignword
IfZeroCommand:      ;; code:if0
        ldq     aRegister
        beq     IfSuccess
        bra     IfFailed

// *******************************************************************************************
;;
;;     Conditionally executes the following word if A is positive. The form is if [word]
;;
// *******************************************************************************************

        +alignword
IfPositiveCommand:  ;; code:if+
        ldq     aRegister
        bpl     IfSuccess
        bra     IfFailed

// *******************************************************************************************
;;
;;     Conditionally executes the following word if A is negative. The form is if [word]
;;
// *******************************************************************************************

        +alignword
IfNegativeCommand:  ;; code:if-
        ldq     aRegister
        bmi     IfSuccess
        bra     IfFailed

// *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is non zero, executes word1 otherwise executes word2
;;
// *******************************************************************************************

        +alignword
IfelseCommand:      ;; code:ifelse
        ldq     aRegister
        bne     IfElseSuccess

IfElseFailed:
        lda     #4
        jsr     AdvanceProgramCounter
        rts

IfElseSuccess:
        ldz     #0
        jsr     ExecuteAtOffset
        lda     #8
        jsr     AdvanceProgramCounter
        rts

// *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is zero, executes word1 otherwise executes word2
;;
// *******************************************************************************************

        +alignword
IfelseZeroCommand:      ;; code:ifelse0
        ldq     aRegister
        beq     IfElseSuccess
        bra     IfElseFailed

// *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is positive, executes word1 otherwise executes word2
;;
// *******************************************************************************************

        +alignword
IfelsePositiveCommand:  ;; code:ifelse+
        ldq     aRegister
        bpl     IfElseSuccess
        bra     IfElseFailed

// *******************************************************************************************
;;
;;     Conditionally executes one of two words depending on the value in A. Form is ifelse
;;     [word1] <word2>. If A is negative, executes word1 otherwise executes word2
;;
// *******************************************************************************************

        +alignword
IfelseNegativeCommand:  ;; code:ifelse-
        ldq     aRegister
        bmi     IfElseSuccess
        bra     IfElseFailed

        .endsection