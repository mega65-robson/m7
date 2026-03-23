; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      case.asm
;      Purpose :   Case structure
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;
;                                  Support words.
;
; *******************************************************************************************

        .bytecode "otherwise"
otherwiseWord:
        lda     currentTest
        sta     aRegister
        lda     currentTest+1
        sta     aRegister+1
        rts

        .bytecode "endcase"
endcaseWord:    
        dec     endCaseFlag
        rts

; *******************************************************************************************
;;
;;     Case structure, tests A. 
;;
;;     Form is case [test] [word] [test] [word] otherwise [word] endcase
;;     The otherwise is optional. Once a match has been made (otherwise matches all)
;;     then we shift beyond endcase. A is not restored afterwards, so values can be passed
;;     out. The [word] can be a single value, or a compound word.
;;     Otherwise is optional.
;;
; *******************************************************************************************

        .bytecode "case"
caseStructure:  
        lda     currentTest                 ; save the current test so case can be nested.
        pha
        lda     currentTest+1
        pha

        lda     aRegister                   ; A is the current test
        sta     currentTest
        lda     aRegister+1
        sta     currentTest+1

        stz     endCaseFlag                 ; Reset the end case flag
;
;       Main Case Loop
;
_caseLoop:
        jsr     RunOneWord                  ; execute the test word
        lda     endCaseFlag                 ; Did we execute endcase
        bne     _caseExit                   ; if so, we are done.

        lda     aRegister                   ; Check aRegister = currentTest        
        cmp     currentTest
        bne     _caseNext
        lda     aRegister+1
        cmp     currentTest+1
_caseNext:                                  ; test failed, so skip the next word                
        beq     _caseFound
        jsr     SkipInstruction
        bra     _caseLoop                   ; and try the next.
;
;       Found a match.
;
_caseFound:
        jsr     RunOneWord                  ; first run the matching word.
_findEndCase:        
        jsr     RunOneWord                  ; run the next test value
        lda     endCaseFlag                 ; exit if end case was executed.
        bne    _caseExit
        jsr     SkipInstruction             ; skip over the instruction which is the body.
        bra     _findEndCase
;
;       Reached endcase.
;
_caseExit:
        pla                                 ; Restore last current test.
        sta     currentTest+1
        pla
        sta     currentTest
        rts

        .endsection