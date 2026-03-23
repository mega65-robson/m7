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
    
        .bytecode "while"
WhileStructure: 
        phy                                 ; save start
        jsr     RunOneWord                  ; run the test
        lda     aRegister                   ; exit if zero
        ora     aRegister+1
        beq     _WhileExit
        jsr     RunOneWord                  ; run the body
        ply                                 ; back to start and go round
        bra     WhileStructure
_WhileExit:
        pla                                 ; throw saved position
        jsr     SkipInstruction             ; skip over the body.        
        .donext

        .endsection
        
