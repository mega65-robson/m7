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
        lda     $00,x                       ; copy the address of the string to A and zTemp0
        sta     aRegister
        sta     zTemp0
        lda     $01,x
        sta     aRegister+1
        sta     zTemp0+1        
_SHSkip:
        lda     (zTemp0),y                  ; skip over the ASCIIZ string
        iny
        cmp     #0
        bne     _SHSkip
        rts

        .endsection

