; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      multiply.asm
;       Purpose :   Multiply a by b
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section code

; ************************************************************************************************
;
;;                                   Multiply A by B
;
; ************************************************************************************************

		.codeword  "*"
Multiply:
        lda     aRegister                   ; copy A to zTemp0
        sta     zTemp0
        lda     aRegister+1
        sta     zTemp0+1

        stz     aRegister                   ; zero zTemp0
        stz     aRegister+1
_MultLoop:
        lsr     zTemp0+1                    ; shift zTemp0 right into carry
        ror     zTemp0
        bcc     _MultNoAdd

        clc                                 ; add b to a if bit set
        lda     aRegister
        adc     bRegister
        sta     aRegister
        lda     aRegister+1
        adc     bRegister+1
        sta     aRegister+1

_MultNoAdd:
        asl     bRegister                   ; shift b left
        rol     bRegister+1

        lda     zTemp0                      ; until zTemp0 is zero
        ora     zTemp0+1
        bne     _MultLoop

        .donext

        .endsection

