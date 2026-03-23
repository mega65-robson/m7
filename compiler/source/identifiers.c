// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      identifiers.c
//       Purpose :   Identifier tracking.
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
 * @brief      Erase all Local runtime identifiers.
 */
void RTClearLocals(void) {
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {
        if (identifiers[i].isLocal) {
            _RTEraseIdentifier(i);
        }
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

/**
 * @brief      Look for an identifier in the table
 *
 * @param      name  Identifier name.
 *
 * @return     Identifier record or NULL if not found.
 */
IDENTIFIER *RTFind(char *name) {
    return NULL;
}

/**
 * @brief      Create a new identifier
 *
 * @param      name   Name of identifier
 * @param[in]  type   Type of Identifier
 * @param[in]  value  Associated value
 *
 * @return     Address of identifier record.
 */
IDENTIFIER *RTAdd(char *name, enum IdentifierType type,int value) {
    return NULL;
}