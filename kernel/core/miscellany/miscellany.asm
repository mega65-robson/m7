; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      miscellany.asm
;       Purpose :   Miscellaneous words
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section code

; ************************************************************************************************
;
;;                                  System debug break
;
; ************************************************************************************************

		.codeword  "break"
DebugBreak:
        .byte   $DB
        .donext

; ************************************************************************************************
;
;;                                          Swap A & B
;
; ************************************************************************************************

		.bytecode  "swap"
SwapReg:
        lda     aRegister
        ldy     bRegister
        sta     bRegister
        sty     aRegister
        lda     aRegister+1
        ldy     bRegister+1
        sta     bRegister+1
        sty     aRegister+1
        .donext      
        
; ************************************************************************************************
;
;;  Copy A to B and Pop A off the stack. This is used in arithmetic operations ; suppose there 
;;  is an interim value on the stack, you can do "4 pop +". Generally use this for binary
;;  operators and the >a a> form for saving and restoring values.
;
; ************************************************************************************************

		.bytecode  "pop"
PopA:
        .copyAB
        pla
        sta aRegister+1
        pla
        sta aRegister
        .donext

        .endsection
