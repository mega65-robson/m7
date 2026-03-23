; *******************************************************************************************
; *******************************************************************************************
;
;      Name :      transfer.asm
;      Purpose :   Copy and fill.
;      Date :      23rd March 2026
;      Author :    Paul Robson (paulrobsons.org.uk)
;
; *******************************************************************************************
; *******************************************************************************************

        .section    code

; *******************************************************************************************
;;
;;      Fill memory from address in A with byte B, for a count of C. C = 0 is supported.
;;
; *******************************************************************************************		

		.codeword "fill"
FillMemory:  
        lda     cRegister
        ora     cRegister+1
        beq     _FillExit

        lda     bRegister
        sta     (aRegister)

        .incword aRegister
        .decword cRegister

        bne     FillMemory
_FillExit:        
        .donext

; *******************************************************************************************
;;
;;     Copy memory from the address in B to the address in A, C times. C = 0 is supported
;;     This is a single forward copy so cannot cope with overlaps.
;;
; *******************************************************************************************		

        .codeword   "copy"
CopyMemory:  
        lda     cRegister
        ora     cRegister+1
        beq     _CopyExit

        lda     (bRegister)
        sta     (aRegister)

        .incword aRegister
        .incword bRegister
        .decword cRegister

        bne     CopyMemory
_CopyExit:        
        .donext        
        
        .endsection