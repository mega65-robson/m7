; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      sdivide.asm
;      Purpose :   Signed divide
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;      Signed Division of B by A. A = 0 is indeterminate.
;;
; *******************************************************************************************		

		.codeword "/"
SignedDivide:  
        lda     aRegister+1                 ; push the sign of the result on the stack.
        eor     bRegister+1
        pha
        jsr     SDAbsolute                  ; calculate |a| and |b|
        jsr     DivideMain                  ; do the primary divide.
        lda     bRegister                   ; copy result in B to A
        sta     aRegister
        lda     bRegister+1
        sta     aRegister+1
        pla                                 ; sign of result
        bpl     _SDExit
        ldx     #aRegister
        jsr     SDNegate
_SDExit:        
        rts

; *******************************************************************************************
;;
;;      Modulus of Signed Division of B by A. A = 0 is indeterminate. Calculates |a| 
;;      mod |b|.
;;
; *******************************************************************************************       

        .codeword "mod"
SignedModulus:  
        jsr     SDAbsolute                  ; calculate |a| and |b|
        jsr     DivideMain                  ; do the primary divide.
        lda     zTemp0                      ; copy zTemp0 to A
        sta     aRegister
        lda     zTemp0+1
        sta     aRegister+1
        rts

; *******************************************************************************************       
;
;                                   Do |A| and |B|
;
; *******************************************************************************************       

SDAbsolute:
        ldx     #aRegister
        jsr     _SDAbsolute
        ldx     #bRegister
_SDAbsolute:
        lda     1,x
        bmi     SDNegate
        rts

; *******************************************************************************************       
;
;                                   Calculate -A / -B
;
; *******************************************************************************************       

SDNegate:
        sec
        lda     #0
        sbc     0,x
        sta     0,x
        lda     #0
        sbc     1,x
        sta     1,x
        rts

        .endsection