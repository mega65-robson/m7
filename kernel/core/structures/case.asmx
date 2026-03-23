// *******************************************************************************************
// *******************************************************************************************
//
//      Name :      case.asm
//      Purpose :   Case structure
//      Date :      23rd March 2026
//      Author :    Paul Robson (paulrobsons.org.uk)
//
// *******************************************************************************************
// *******************************************************************************************

        .section    code

// *******************************************************************************************
//
//                                  Support words.
//
// *******************************************************************************************

        +alignword
otherwiseWord:  ;; code:otherwise
        ldq     currentTest
        stq     aRegister
        +donext

        +alignword
endcaseWord:    ;; code:endcase        
        dec     endCaseFlag
        +donext

// *******************************************************************************************
;;
;;     Case structure, tests A. 
;;
;;     Form is case [test] [word] [test] [word] otherwise [word] endcase
;;     The otherwise is optional. Once a match has been made (otherwise matches all)
;;     then we shift beyond endcase. A is not restored afterwards, so values can be passed
;;     out. The [word] can be a single value, or a compound word.
;;     Otherwise is optional.
;;
// *******************************************************************************************

        +alignword
caseStructure:  ;; code:case
        ldq     currentTest                 // So we can nest them.
        +tpushq

        ldq     aRegister                   // A is the current test
        stq     currentTest

_caseLoop:
        ldz     #0                          // Get the next test value.
        stz     endCaseFlag                 // Reset the end case flag
        jsr     ExecuteAtOffset             // execute the test word
        lda     endCaseFlag                 // Did we execute endcase
        bne     _caseExit

        ldq     aRegister                   // Check aRegister = currentTest
        cmp     currentTest
        beq     _caseFound
        lda     #8                          // Go to the next word.
        jsr     AdvanceProgramCounter
        bra     _caseLoop

_caseFound:
        ldz     #4                          // Case execute word
        jsr     ExecuteAtOffset             // Execute it.
_findEndCase:        
        lda     pctrStackPointer            // Scan forward looking for endCase
        sta     caseReadCurrent
        ldz     #0
        ldq     [0],z
caseReadCurrent = * - 1
        cpq     endCaseAddress              // Found endcase ?
        beq     _caseExit
        lda     #4                          // No, try next.
        jsr     AdvanceProgramCounter
        bra     _findEndCase

_caseExit:
        +tpopq                              // Restore last current test.
        stq     currentTest
        lda     #4                          // Skip over endcase.
        jsr     AdvanceProgramCounter
        +donext

;
;       Current case value
;
currentTest:                    
        !32     0        
;
;       Word representing compiled representation of endcase
;
endCaseAddress:
        !32     endcaseWord + $10000000
;
;       Flag set when endcase is executed.
;
endCaseFlag:
        !8      0

        .endsection