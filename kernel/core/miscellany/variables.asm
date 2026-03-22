; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      variables.asm
;       Purpose :   Variable handlers
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section code

; ************************************************************************************************
;
;                                   Variable Handler
;
; ************************************************************************************************

		.bytecode  "var.handler"
VariableHandler:        

        .copyAB                             ; do A->B

;
;       Get value
;
        ldx     stackPtr                    ; access the stack.
        stx     _VH1+1                      ; so we can read the next 2 bytes.
        stx     _VH2+1

_VH1:
        lda     ($00),y
        sta     aRegister
        iny
_VH2:
        lda     ($00),y
        sta     aRegister+1
        iny

        jmp     SubReturn                   ; and end this word.
        
        .endsection

