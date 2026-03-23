// *******************************************************************************************
// *******************************************************************************************
//
//      Name :      repeat.asm
//      Purpose :   Repeat loop
//      Date :      23rd March 2026
//      Author :    Paul Robson (paulrobsons.org.uk)
//
// *******************************************************************************************
// *******************************************************************************************

        .section    code

// *******************************************************************************************
;;
;;     Repeat loop. The syntax is repeat [word] ; the word is executed until the A register
;;     is non zero on exit. The loop is executed at least once.
;;
// *******************************************************************************************

        +alignword
RepeatStructure: ;; code:repeat
        ldz     #0                          // Get and execute word
        jsr     ExecuteAtOffset
        ldq     aRegister                   // Keep going if A = 0
        beq     RepeatStructure
        lda     #4                          // Skip over it.
        jsr     AdvanceProgramCounter
        +donext

        .endsection
                