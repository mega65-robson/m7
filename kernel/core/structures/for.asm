; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      for.asm
;      Purpose :   For loop
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;     For loop index value
;;
; *******************************************************************************************		

        .bytecode   "i"
GetIndexValue: 
        .copyAB
        lda     index
        sta     aRegister
        lda     index+1
        sta     aRegister+1
        .donext

; *******************************************************************************************
;;
;;     For loop. Executes he following word 'aRegister' times, (works correctly for zero)
;;     The index counts from n-1 to 0
;;
; *******************************************************************************************		

        .bytecode   "for"
ForStructure: 
        lda     index                       ; push index on stack
        pha
        lda     index+1
        pha

        lda     aRegister                   ; initialise index
        sta     index
        lda     aRegister+1
        sta     index+1

_ForLoop:
        lda     index                       ; exit if zero
        ora     index+1
        beq     _ForExit

        lda     index                       ; decrement index.
        bne     _ForNoBorrow
        dec     index+1
_ForNoBorrow:
        dec     index        

        phy                                 ; run one word, preserving position. 
        jsr     RunOneWord
        ply
        bra     _ForLoop                    ; and loop back

_ForExit:        
        jsr     SkipInstruction             ; skip over the instruction
        pla                                 ; restore the previous index so we can nest.
        sta     index+1
        pla
        sta     index
        .donext

; *******************************************************************************************
;
;                               Skip the next instruction
;  
; *******************************************************************************************

SkipInstruction:
        ldx     stackPtr                    ; so we can access the instruction
        stx     _SIRead+1
_SIRead:
        lda     ($00),y                     ; read what follows.
        bmi     _SIAdd2                     ; 8000-FFFF add 2.
        bra     SkipInstruction
        cmp     #4                          ; 00..03 add n + 1
        inc     a 
        bcc     _SIAdd
        inc     0,x                         ; 04..7F add 1
        bne     _SIExit
        inc     1,x
_SIExit:
        rts

_SIAdd2:                                    ; add 2 to PC
        lda     #2
_SIAdd:                                     ; add A to PC
        clc
        adc     0,x
        sta     0,x
        bcc     _SIExit
        inc     1,x
        rts

        .endsection

