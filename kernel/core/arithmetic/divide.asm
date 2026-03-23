; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      divide.asm
;      Purpose :   Unsigned divide
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;      Unsigned Division of B by A. A = 0 is indeterminate.
;;
; *******************************************************************************************		

		.codeword "u/"
UnsignedDivide:  
        jsr     DivideMain                  ; do the primary divide.
        lda     bRegister                   ; copy result in B to A
        sta     aRegister
        lda     bRegister+1
        sta     aRegister+1
        .donext

; *******************************************************************************************
;;
;;      Unsigned Modulus of B by A. A = 0 is indeterminate.
;;
; *******************************************************************************************       

        .codeword "umod"
UnsignedModulus:  
        jsr     DivideMain                  ; do the primary divide.
        lda     zTemp0                      ; copy zTemp0 to A
        sta     aRegister
        lda     zTemp0+1
        sta     aRegister+1
        .donext

; *******************************************************************************************
;
;       16 bit divide of B/A. See divide.py. Result in B, Remainder in zTemp0
;   
; *******************************************************************************************		

DivideMain:
        phy
        stz     zTemp0                      ; clear zTemp0
        stz     zTemp0+1
        ldx     #16                         ; this is the loop count
_DivideLoop:
        asl     bRegister                   ; shift ZTemp0:B left once.
        rol     bRegister+1
        rol     zTemp0
        rol     zTemp0+1        

        sec                                 ; calculate Z-A
        lda     zTemp0
        sbc     aRegister
        tay                                 ; save LSB of result
        lda     zTemp0+1
        sbc     aRegister+1
        bcc     _DivideNoSubtract

        sta     zTemp0+1                    ; update the subtraction
        sty     zTemp0
        inc     bRegister                   ; set bit 0 of B
_DivideNoSubtract:        
        dex
        bne     _DivideLoop                 ; do 16 times
        ply
        rts

        .endsection