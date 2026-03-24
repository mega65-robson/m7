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
static uint16_t currentHash;
static char currentName[MAX_IDENT_LENGTH+1];

static void _IDEraseIdentifier(int n);
static void _IDProcess(char *name);

/**
 * @brief      Erase all Runtime identifiers
 */
void IDClearIdentifiers(void) {
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {
        _IDEraseIdentifier(i);
    }
}

/**
 * @brief      Erase all Local runtime identifiers.
 */
void IDClearLocals(void) {
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {
        if (identifiers[i].isLocal) {
            _IDEraseIdentifier(i);
        }
    }
}

/**
 * @brief      Erase a runtime identifier
 *
 * @param[in]  n     index of identifier
 */
static void _IDEraseIdentifier(int n) {
    ASSERT(n >= 0 && n < MAX_IDENTIFIERS);
    IDENTIFIER *id = &identifiers[n];
    id->type = Unused;
    id->name[0] = '\0';
    id->hash = 0;
    id->isLocal = false;
}

/**
 * @brief      Process the name, calculating the Hash and an U/C version in the
 *             buffer and hash store
 *
 * @param      name  name of identifier.
 */
static void _IDProcess(char *name) {
    ASSERT(strlen(name) > 0 && strlen(name) <= MAX_IDENT_LENGTH);                   // Check length
    currentHash = 0;
    char *tgt = currentName;
    while (*name != '\0') {                                                         // Copy name in upper case calculating hash as you go.
        char c = toupper(*name++);
        *tgt++ = c;
        currentHash += c;
    }
    *tgt = '\0';
}


/**
 * @brief      Look for an identifier in the table
 *
 * @param      name  Identifier name.
 *
 * @return     Identifier record or NULL if not found.
 */
IDENTIFIER *IDFind(char *name) {
    _IDProcess(name);
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {                                       // Scan the identifiers
        if (identifiers[i].type != Unused && identifiers[i].hash == currentHash) {  // Does it match the hash ?
            if (strcmp(identifiers[i].name,currentName) == 0) {                     // Found if matches the name.
                return &identifiers[i];
            }
        }
    }
    return NULL;
}

/**
 * @brief      Create a new identifier
 *
 * @param      name   Name of identifier
 * @param[in]  type   Type of Identifier
 * @param[in]  value  Associated value
 *
 * @return     Address of identifier record, NULL if failed.
 */
IDENTIFIER *IDAdd(char *name, enum IdentifierType type,int value) {
    if (IDFind(name) != NULL) {                                                     // Already exists
        return NULL;
    }
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {                                       // Look for a blank record. Not doing a full hash here.
        if (identifiers[i].type == Unused) {                                        // If found, fill in record.
            IDENTIFIER *id = &identifiers[i];
            strcpy(id->name,currentName);
            id->type = type;
            id->hash = currentHash;
            id->value = value;
            id->isLocal = (name[0] == '.');                                         // Locals begin with a full stop.
            LOG("Added %s %c %d",name,type,value);
            return id;
        }
    }
    return NULL;
}

/**
 * @brief      List all identifiers.
 */
void IDList(void) {
    for (int i = 0;i < MAX_IDENTIFIERS;i++) {
        IDENTIFIER *id = &identifiers[i];
        if (id->type != Unused) {
            printf("%-4d : %-20s (%c) %-6d $%04x %s\n",i,id->name,id->type,id->value,id->value,id->isLocal ? "(Local)":"");
        }
    }
}
/**
 * @brief      Test routine
 */
void IDTest(void) {
    IDClearIdentifiers();
    IDAdd("test1",ByteCode,42);
    IDAdd("test2",CodeWord,0x8032);
    IDAdd(".test2",CodeWord,0x8032);
    IDList();
    printf("%p\n",IDFind("test2"));
    printf("%p\n",IDFind("test3"));
}
