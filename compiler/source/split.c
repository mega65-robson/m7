// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      split.c
//       Purpose :   Divide code into definitions, compile subsections within.
//       Date :      24th March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#include <compiler.h>

static void _SPCompileDefinitionBlock(char *start,char *end);
static char *_SPFindNextDefinition(char *src);
static void _SPCompileSubword(char *start,char *limit);
static void _SPCompileBlock(char *start,char *end);

//
//      This represents words in [ ] which are compiled as seperate words transparently.
//      In the source, the [ code ] is replaced by chr(128+subwordaddress)
//      
static int  nextSubWordAddress;                                                     // Next [] subword slot
static int  subWordAddresses[SUBWORDCOUNT];                                         // Address of call for subword slot.

/**
 * @brief      Subdivide the source into definitions
 *
 * @param      source  Source to define.
 */
void SPProcess(char *source) {
    char *start = _SPFindNextDefinition(source);                                    // Find the first definition, or end of source
    _SPCompileDefinitionBlock(source,start-1);                                      // Compile to this point.
    while (*start != '\0') {                                                        // Until found EOF
        char *end = _SPFindNextDefinition(start+1);                                 // Find the next one.
        _SPCompileDefinitionBlock(start,end-1);                                     // And do that block.
        start = end;
    }
}



/**
 * @brief      Find next definition or end
 *
 * @param      src   Source position to scan from.
 *
 * @return     The address of the next definition, or EOS if reached end of the
 *             source
 */
static char *_SPFindNextDefinition(char *src) {
    while (true) {
        while (*src == ' ') src++;                                                  // Skip spaces
        if (*src == ':' || *src == '\0') return src;                                // If found a defining word or EOS, then exit.
        while (*src > ' ' ) src++;                                                  // Skip over the word.
    }
}

/**
 * @brief      Compile the code block provided
 *
 * @param      start  Start of code block
 * @param      end    End of code bblock
 */
static void _SPCompileDefinitionBlock(char *start,char *end) {
    nextSubWordAddress = 0;
    for (char *p = start;p < end;p++) {                                             // Look for " [ "
        if (p[0] == ' ' && p[1] == '[' && p[2] == ' ') {                            // If found compile as a sub word.
            _SPCompileSubword(p+1,end);
        }
    }    
    _SPCompileBlock(start,end);                                                     // Compile code from start to end.
}

/**
 * @brief      Compile the words in the block.
 *
 * @param      start  Start of block
 * @param      end    End of block
 */
static void _SPCompileBlock(char *start,char *end) {
    char wordBuffer[256];                                                           // Word extracted goes here.
    while (*start == ' ' && start < end) start++;                                   // Skip spaces
    while (start < end) {                                                           // While not done
        char *b = wordBuffer;
        while ((unsigned char)(*start) > ' ') *b++ = *start++;                      // Copy word into buffer
        *b++ = '\0';
        while (*start == ' ' && start < end) start++;                               // Skip spaces
        if (wordBuffer[0] < 0) {                                                    // Expand the chr(n) marker.
            sprintf(wordBuffer,"__%d",wordBuffer[0] & 0x7F);
        } 
        COMCompileWord(wordBuffer);
    }
}

/**
 * @brief      Compile the subword from the start (points to the [). This is
 *             created as a seperate routine and stored in the subword list. The
 *             source is modified to spaces, with a chr(128+n) to mark the
 *             subword
 *
 * @param      start  Start of subword (the [)
 * @param      limit  Cannot go beyond this, suggest missing ] 
 */
static void _SPCompileSubword(char *start,char *limit) {
    subWordAddresses[nextSubWordAddress] = RTGetPCTR();                             // Remember where this word is for later.
    char *end = start+1;
    while (!(end[0] == ' ' && end[1] == ']' && end[2] == ' ')) {                    // Look for ' ] '
        end++;
        if (end == limit) ERROR("Missing ] in [ ] construct");
    }
    _SPCompileBlock(start+1,end);                                                   // Compile the block.
    COMCompileWord(";");                                                            // And a return.
    for (char *p = start;p < end+2;p++) {                                           // Remove the block.
        *p = ' ';
    }
    *start = 0x80|nextSubWordAddress;                                               // Put a marker there.
    nextSubWordAddress++;                                                          
}

/**
 * @brief      Get the subword code addresss
 *
 * @param[in]  n     Subword code requested
 *
 * @return     Address of the subword code.
 */
int SPGetSubwordAddress(int n) {
    ASSERT(n >= 0 && n < nextSubWordAddress);
    return subWordAddresses[nextSubWordAddress];
}