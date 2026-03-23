; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      repeat.asm
;      Purpose :   Repeat loop
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;     Repeat loop. The syntax is repeat [word] ; the word is executed until the A register
;;     is non zero on exit. The loop is executed at least once.
;;
; *******************************************************************************************

        .bytecode   "repeat"
RepeatStructure: 
        phy                                 ; save position
        jsr     RunOneWord                  ; run the world
        lda     aRegister                   ; exit if non zero
        ora     aRegister+1
        bne     _RepeatExit
        ply                                 ; restore and loop back
        bra     RepeatStructure

_RepeatExit:
        pla                                 ; throw saved position        
        .donext

        .endsection
                