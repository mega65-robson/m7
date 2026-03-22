; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      exec.asm
;       Purpose :   Execute code
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;                               Execute code
;
; ************************************************************************************************

        .section code

RunProgram:
        tsx                                 ; save SP
        stx     stackPointer
        ldx     #pcStack                    ; Start on the PC Stack.

        lda     BootAddress                 ; set the start PC value.
        ldx     BootAddress+1

        jsr     RunOneWord
        rts


RunOneWord:

        .bytecode   "const.1::0"
Const1Byte:
        .bytecode   "const.2::1"
Const2Byte:

ByteCodeError:
        brk
        
; ************************************************************************************************
;
;;                          Return to the calling operating system.
;        
; ************************************************************************************************

        .codeword  "bye"
ReturnToCaller:
        ldx     stackPointer
        txs
        rts

        .bytecode  ";"
SubReturn:        
        clv

        .endsection

