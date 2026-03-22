; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      strings.asm
;       Purpose :   String handler
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section code

; ************************************************************************************************
;
;                                   String Handler
;
; ************************************************************************************************

		.bytecode  "string.handler"
StringHandler:
        .copyAB                             ; copy A to B
        ldx     stackPtr                    ; access the stack.
        stx     _SHSkip+1                   ; patch up the string skipping
        clc
        tya
        adc     $00,x                       ; copy the address of the string to A and zTemp0
        sta     aRegister
        lda     $01,x
        adc     #0
        sta     aRegister+1

_SHSkip:
        lda     ($00),y                     ; skip over the ASCIIZ string
        iny
        cmp     #0
        bne     _SHSkip
        rts

        .endsection

