; ************************************************************************************************
; ************************************************************************************************
;
;       Name :      00main.asm
;       Purpose :   Main Program (wrapper for testing with api in api directory)
;       Date :      21st March 2026
;       Author :    Paul Robson (paul@robsons.org.uk)
;
; ************************************************************************************************
; ************************************************************************************************

; ************************************************************************************************
;
;                               Set up the three required sections
;
; ************************************************************************************************

        * = CODEADDR
        .dsection code
        
        * = STORAGE
        .dsection storage

        * = ZEROPAGE
        .dsection zeropage

; ************************************************************************************************
;
;                                       Test code boot
;
; ************************************************************************************************

        .section code

Start:  
        jmp     RunProgram

        * = Start + 32

BootAddress:
        .dword  0                           ; Boot address          +32
DictAddress:        
        .dword  Dictionary                  ; Dictionary address    +36        
FreeMemoryAddress:        
        .dword  0                           ; Free memory           +40


        .endsection