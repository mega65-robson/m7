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
;;  When preceding a variable returns the address of the variable. So & count returns the 
;;  address of 'count'. Does A->B
;
; ************************************************************************************************

        .bytecode  "&"
VariableGetAddress:
        lda     #$01                        ; to get address, set to $01.
        sta     varModifier
        rts

; ************************************************************************************************
;
;;  When preceding a variable updates the variable. So 42 -> count writes the value 42 to the
;;  variable count.
;
; ************************************************************************************************

        .bytecode  "->"
VariableWrite:
        lda     #$80                        ; to write set to $80
        sta     varModifier
        rts

; ************************************************************************************************
;
;                                   Variable Handler
;
; ************************************************************************************************

		.bytecode  "var.handler"
VariableHandler:        
        lda     varModifier                 ; modified
        bmi     _VHWrite
        bne     _VHAddress
;
;       Read a variable value.
;
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
_VHExit:
        jmp     SubReturn                   ; and end this word.
;
;       Get address
;
_VHAddress
        .copyAB                             ; A->B  and copy zTemp to A
        ldx     stackPtr                    ; access the stack.
        tya                                 ; work out the physical address.
        clc
        adc     00,x
        sta     aRegister
        lda     $01,x
        adc     #0
        sta     aRegister+1
        stz     varModifier                 ; zero the modifier flag.
        bra     _VHExit
;
;       Write to variable.
;
_VHWrite:
        .debug  
        ldx     stackPtr                    ; access the stack.
        stx     _VW1+1                      ; so we can write the next 2 bytes.
        stx     _VW2+1
        lda     aRegister
_VW1:
        sta     ($00),y
        iny        
        lda     aRegister+1
_VW2:
        sta     ($00),y
        bra     _VHExit

        .endsection

