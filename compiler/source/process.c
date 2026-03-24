// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      process.c
//       Purpose :   Code pre-processing
//       Date :      24th March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#include <compiler.h>

char codeBuffer[65536];                                                             // Currently processed code.

static void _PRRemoveControl(void);
static void _PRRemoveComments(void);
static void _PRCapitalise(void);

/**
 * @brief      Process the code buffer, remove CR/LF to just LF, remove comments and controls.
 *             and capitalise correctly.
 *
 * @param      fileName  The file name
 *
 * @return     { description_of_the_return_value }
 */
char *PRProcess(char *fileName) {
    LOG("Processing %s",fileName);
    FILE *f = fopen(fileName,"r");
    if (f == NULL) ERROR("Cannot open source file %s",fileName);
    size_t count = fread(codeBuffer,1,sizeof(codeBuffer),f);                        // Read it in.
    if (count == sizeof(codeBuffer)) ERROR("Source file %s too large",fileName);    // Probably too big.
    fclose(f);
    LOG("Read %ld bytes.",count);
    _PRRemoveComments();
    _PRRemoveControl();
    _PRCapitalise();
    return codeBuffer;
}

/**
 * @brief      Remove Control
 */
static void _PRRemoveControl(void) {
    char *p = codeBuffer;
    while (*p != '\0') {                                        
        if (*p < ' ') *p = ' ';                                                     // Remove tabs etc.
        p++;
    }
}

/**
 * @brief      Remove comments (//)
 */
static void _PRRemoveComments(void) {
    char *p = codeBuffer;
    while (*p != '\0') {
        if (p[0] == '/' && p[1] == '/') {                                           // Found a comment.
            while (*p >= ' ') {                                                     // Erase up till EOL/EOF
                *p++ = ' ';
            }
        } else {
            p++;
        }
    }
}

/**
 * @brief      Capitalise non string constant words.
 */
static void _PRCapitalise(void) {
    char *p = codeBuffer;
    while (*p != '\0') {
        while (*p == ' ') p++;                                                      // Skip over spaces
        if (*p == '"') {                                                            // If quoted string.
            while (*p > ' ') p++;                                                   // Skip over it.
        } else {                                                                    
            if (*p != '\0') {                                                       // Otherwise it's a word, capitalise it.
                while (*p > ' ') {
                    *p = toupper(*p);p++;                   
                }
            }
        }        
    }
}
