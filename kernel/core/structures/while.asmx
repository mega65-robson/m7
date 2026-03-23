; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      while.asm
;      Purpose :   While loop
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;     While loop. Has the form while [test] [body] ; the word [test] is executed, if the
;;     A register is non zero after this, the word [body] is executed. 
;;
; *******************************************************************************************

        +alignword
WhileStructure: ;; code:while
        ldz     #0                          ; Execute test word
        jsr     ExecuteAtOffset
        ldq     aRegister                   ; Exit if A = 0
        beq     .whileExit

        ldz     #4                          ; Execute body word
        jsr     ExecuteAtOffset
        bra     WhileStructure

.whileExit:        
        lda     #8                          ; Skip over.
        jsr     AdvanceProgramCounter
        +donext

        .endsection
        
