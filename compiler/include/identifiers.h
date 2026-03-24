// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      identifiers.h
//       Purpose :   Identifier tracker include
//       Date :      23rd March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#pragma once

#define MAX_IDENTIFIERS     (1024)                                                  // Max # of identifiers supported
#define MAX_IDENT_LENGTH    (32)                                                    // Max size of an identifier.

enum IdentifierType {
    Unused = '.',                                                                   // Free for allocation
    ByteCode = 'B',                                                                 // Byte Code (0-7F)
    CodeWord = 'C'                                                                  // Code Word (8000-FFFF)
};

typedef struct _Identifier {
    enum    IdentifierType type;                                                    // Type of record
    char    name[MAX_IDENT_LENGTH+1];                                               // Identifier in lower case.
    int     value;                                                                  // Associated value (address or bytecode)
    uint16_t hash;                                                                  // Hash of the identifier.    
    bool    isLocal;                                                                // True if local identifier
} IDENTIFIER;

void IDClearIdentifiers(void);
void IDClearLocals(void);
IDENTIFIER *IDFind(char *name);
IDENTIFIER *IDAdd(char *name, enum IdentifierType type,int value);
uint16_t IDCalculateHash(char *name);

void IDTest(void);
void IDList(void);