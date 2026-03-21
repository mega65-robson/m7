; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      io.asm
;       Purpose :   Hardware input/output
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

        .section code

; ************************************************************************************************
;
;;      Dump the Register state
;
; ************************************************************************************************

		.codeword  "reg"
WriteReg:
        phx
        lda     #65
        ldx     aRegister
        ldy     aRegister+1
        jsr     _WROut
        lda     #66
        ldx     bRegister
        ldy     bRegister+1
        jsr     _WROut
        lda     #67
        ldx     cRegister
        ldy     cRegister+1
        jsr     _WROut
        lda     #13
        jsr     ChrOut
        plx
        .donext

_WROut:
        jsr     ChrOut
        lda     #':'        
        jsr     ChrOut
        tya
        jsr     PrintByte
        txa
        jsr     PrintByte
        lda     #32
        jmp     ChrOut


; ************************************************************************************************
;
;;              Read Character into A Register from system input. 0 if none available
;
; ************************************************************************************************

		.codeword  "raw.read"
ReadChar:
        phy
        .copyAB 
        jsr     $FFE4
        sta     aRegister
        stz     aRegister+1
        ply
        .donext 

; ************************************************************************************************
;
;;                          Write Character in A Register to system output
;
; ************************************************************************************************

		.codeword  "raw.write"
WriteChar:
        lda     aRegister
        jsr     ChrOut
        .donext      

; ************************************************************************************************
;
;                       Character output that preserves the X register
;
; ************************************************************************************************

ChrOut:
        phy
        jsr     $FFD2
        ply
        rts

; ************************************************************************************************
;
;;             Write Number in A Register as hex to system output, space prefixed
;
; ************************************************************************************************

		.codeword  "raw.hex"
WriteHex:
        lda     #32
        jsr     ChrOut
WriteHexNS:        
        lda     aRegister+1
        jsr     PrintByte
        lda     aRegister
        jsr     PrintByte
        .donext

; ************************************************************************************************
;
;                                       Print Byte A
;
; ************************************************************************************************

PrintByte:
        pha
        lsr     a
        lsr     a
        lsr     a
        lsr     a
        jsr     PrintNibble
        pla
PrintNibble:
        and     #15
        cmp     #10
        bcc     _NotHex
        adc     #7-1
_NotHex:
        adc     #48
        jmp     ChrOut

        .donext      
        .endsection
