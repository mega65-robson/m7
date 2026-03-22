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
        stx     stack6502

        lda     #pcStack                    ; reset the internal stack
        sta     stackPtr

        lda     BootAddress                 ; set the start PC value.
        sta     pcStack
        lda     BootAddress+1
        sta     pcStack+1
        ldy     #0                          ; now a limit of 256 bytes per word.
RunLoop:
        jsr     RunOneWord
        bra     RunLoop

; ************************************************************************************************
;
;                   Run one word - could be a call or a bytecode.
;
; ************************************************************************************************

RunOneWord:


        lda     ($00),y                     ; this $00 value is the 'stack pointer'.
stackPtr = * - 1                            ; this points to the $00 which is manipulated, and copied.                                    

        bmi     CallRoutine
;
;       Handle bytecodes.
;        
        iny                                 ; consume it
        asl     a                           ; make it an offset into the vector table.
        tax
        jmp     (VectorTable,x)             ; and go there.

;
;       Handle calls. These can either be code (with a $EA prefix, NOP) or a call to more bytecodes and calls
;       e.g. the virtual machine code. $EA is not a legitimate value for the MSB of a call as it's in ROM.
;
CallRoutine:
        iny                                 ; consume value.
        ldx     stackPtr                    ; get the stack pointer, copy the MSB to the next level up.
        sta     3,x 
        stx     _CRead1+1                   ; we're going to read the LSB next
_CRead1:
        lda     ($00),y     
        iny                                 ; and consume it.
        asl     a                           ; now we double the address as it's encoded halved.
        sta     2,x
        rol     3,x
        lda     ($02,x)                     ; read the byte there, to see if it is a code word
        cmp     #$EA
        bne     _VMCall
        jmp     ($02,x)                     ; go execute it.
;
;       Now an actual VM word call.
;
_VMCall:
        inx                                 ; bump up to the next level.
        inx
        stx     stackPtr
        stz     returnFlag                  ; this flag is set by ;
        phy                                 ; save Y
        ldy     #0                          ; new word.
_VMCallLoop:
        jsr     RunOneWord                  ; keep executing words until we've done a ;
        lda     returnFlag
        beq     _VMCallLoop

        stz     returnFlag                  ; clear the return flag
        dec     stackPtr                    ; drop one level
        dec     stackPtr
        ply                                 ; restore the former Y position
        rts

; ************************************************************************************************
;
;                               Handle a 1 byte constant
;
; ************************************************************************************************

        .bytecode   "const.1::0"
Const1Byte:
        .copyAB                             ; do the A->B copy
        lda     stackPtr                    ; copy the stack pointer
        sta     _Read1+1                    
_Read1: lda     ($00),y                     ; read the byte and consume it
        iny
        sta     aRegister                   ; copy to A
        stz     aRegister+1
        rts

; ************************************************************************************************
;
;                               Handle a 2 byte constant
;
; ************************************************************************************************

        .bytecode   "const.2::1"
Const2Byte:
        .copyAB                             ; do the A->B copy
        lda     stackPtr                    ; copy the stack pointer
        sta     _Read2Low+1                    
        sta     _Read2High+1                    
_Read2Low: 
        lda     ($00),y                     ; read the byte and consume it
        iny
        sta     aRegister                   ; copy to A.0
_Read2High: 
        lda     ($00),y                     ; read the byte and consume it
        iny
        sta     aRegister+1                 ; copy to A.1
        rts

; ************************************************************************************************
;
;                                   Unknown byte code
;
; ************************************************************************************************

ByteCodeError:
        brk
        
; ************************************************************************************************
;
;;                          Return to the calling operating system.
;        
; ************************************************************************************************

        .codeword  "bye"
ReturnToCaller:
        ldx     stack6502
        txs
        rts

        .bytecode  ";"
SubReturn:        
        inc     returnFlag
        rts


        .endsection

