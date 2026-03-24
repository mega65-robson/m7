// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      utility.c
//       Purpose :   Utility functions
//       Date :      24th March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#include <compiler.h>


/**
 * @brief      Reports a program error
 *
 * @param      format     Format string
 * @param[in]  <unnamed>  Parameters
 */

void ReportError(char *format , ...) {
    char buffer[128];
    va_list arglist;
    va_start(arglist, format);    
    vsprintf(buffer, format, arglist);
    fprintf(stderr,"ERROR : %s\n",buffer);
    exit(-1);
}

/**
 * @brief      Log information
 *
 * @param      format     Format string
 * @param[in]  <unnamed>  Parameters
 */

void LogInformation(char *format , ...) {
    char buffer[128];
    va_list arglist;
    va_start(arglist, format);    
    vsprintf(buffer, format, arglist);
    fprintf(stderr,"INFO : %s\n",buffer);
}

/**
 * @brief      Convert a string to an integer
 *
 * @param      s        String to convert
 * @param      pResult  Result stored here.
 *
 * @return     true if successfully converted.
 */
bool StringToInteger(char *s,int *pResult) {
    int base = 10;
    bool isMinus = false;
    *pResult = 0;
    if (*s == '-') {                                                                // Handle leading -
        isMinus = true;s++;
    }
    if (*s == '$') {                                                                // Handle hex marker.
        base = 16;s++;
    }
    do {
        int digit = *s++;                                                           // Get a digit
        if (!isxdigit(digit)) return false;                                         // Validate as digit.
        digit = (digit >= 'A') ? digit - 'A' + 10 : digit - '0';                    // Convert to integer
        ASSERT(digit >= 0 && digit < 16);
        if (digit >= base) return false;                                            // Not allowed in base
        *pResult = (*pResult * base) + digit;                                       // Add in digit.
    } while (*s != '\0');
    if (isMinus) {                                                                  // Handle -ve
        *pResult = -*pResult;
    }
    return true;
}

