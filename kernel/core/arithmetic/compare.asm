; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      compare.asm
;       Purpose :   Comparison words
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section code

; ************************************************************************************************
;
;;                          Set A to -1 if B < A , unsigned test
;
; ************************************************************************************************

		.bytecode  "u<"
UnsignedLess:
        lda     bRegister
        cmp     aRegister
        lda     bRegister+1
        sbc     aRegister+1
        bcc     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;;                          Set A to -1 if B < A , signed test
;
; ************************************************************************************************

		.bytecode  "<"
SignedLess:
        jsr     SignedCompareBA
        bcs     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;;                          Set A to -1 if B > A , signed test
;
; ************************************************************************************************

		.bytecode  ">"
SignedGreater:
        jsr     SignedCompareAB
        bcs     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;;                          Set A to -1 if B >= A , signed test
;
; ************************************************************************************************

		.bytecode  ">="
SignedGreaterEqual:
        jsr     SignedCompareBA
        bcc     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;;                          Set A to -1 if B <= A , signed test
;
; ************************************************************************************************

		.bytecode  "<="
SignedLessEqual:
        jsr     SignedCompareAB
        bcc     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;;                          Set A to -1 if A < 0, 0 otherwise
;
; ************************************************************************************************

		.bytecode  "0<"
IsNegative:
        lda     aRegister+1
        bmi     ReturnTrue
ReturnFalse:
        stz     aRegister
        stz     aRegister+1
        .donext

; ************************************************************************************************
;
;;                          Set A to -1 if A >= 0, 0 otherwise
;
; ************************************************************************************************

		.bytecode  "0>="
IsPositive:
        lda     aRegister+1
        bmi     ReturnFalse
ReturnTrue:
        lda     #$FF
        sta     aRegister
        sta     aRegister+1
        .donext

; ************************************************************************************************
;
;;                          Set A to -1 if A = 0, 0 otherwise
;
; ************************************************************************************************

		.bytecode  "0="
IsZero:
        lda     aRegister+1
        ora     aRegister
        beq     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;;                          Set A to -1 if A = B, 0 otherwise
;
; ************************************************************************************************

		.bytecode  "=="
IsEqual:
        lda     aRegister
        cmp     bRegister
        bne     ReturnFalse
        lda     aRegister+1
        cmp     bRegister+1
        bne     ReturnFalse
        bra     ReturnTrue

; ************************************************************************************************
;
;;                          Set A to -1 if A <> B, 0 otherwise
;
; ************************************************************************************************

		.bytecode  "<>"
IsNotEqual:
        lda     aRegister
        cmp     bRegister
        bne     ReturnTrue
        lda     aRegister+1
        cmp     bRegister+1
        bne     ReturnTrue
        bra     ReturnFalse

; ************************************************************************************************
;
;                Signed compare of A < B and B < A, returns CC if <, CS if >=
;
; ************************************************************************************************

SignedCompareAB:
        lda     aRegister
        cmp     bRegister
        lda     aRegister+1
        sbc     bRegister+1
        bvc     _NoOverflow2
        eor     #$80
_NoOverflow2:
        asl     a        
        rts

SignedCompareBA:
        lda     bRegister
        cmp     aRegister
        lda     bRegister+1
        sbc     aRegister+1
        bvc     _NoOverflow
        eor     #$80
_NoOverflow:
        asl     a        
        rts

; ************************************************************************************************
;
;;                               Put signed smaller of A and B in A
;
; ************************************************************************************************

		.bytecode  "min"
MinAB:
        jsr     SignedCompareBA
        bcs     CopyBA
        .donext

; ************************************************************************************************
;
;;                               Put signed larger of A and B in A
;
; ************************************************************************************************

		.bytecode  "max"
MaxAB:
        jsr     SignedCompareAB
        bcs     CopyBA
        .donext

CopyBA:
        lda     bRegister
        sta     aRegister        
        lda     bRegister+1
        sta     aRegister+1
        .donext

        .endsection

