// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      runtime.c
//       Purpose :   Runtime Management
//       Date :      23rd March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#include <compiler.h>

static IDENTIFIER identifiers[MAX_IDENTIFIERS];

static void _RTEraseIdentifier(int n);

/**
 * @brief      Erase all Runtime identifiers
 */
void RTClearIdentifiers(void) {
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {
        _RTEraseIdentifier(i);
    }
}

/**
 * @brief      Erase a runtime identifier
 *
 * @param[in]  n     index of identifier
 */
static void _RTEraseIdentifier(int n) {
    IDENTIFIER *id = &identifiers[n];
    id->type = Unused;
    id->name[0] = '\0';
    id->hash = 0;
    id->isLocal = false;
}

