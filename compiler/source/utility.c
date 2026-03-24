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
 * @param[in]  <unnamed>  Parameers
 */

void ReportError(char *format , ...) {
    char buffer[128];
    va_list arglist;
    va_start(arglist, format);    
    vsprintf(buffer, format, arglist);
    fprintf(stderr,"ERROR : %s\n",buffer);
    exit(-1);
}

