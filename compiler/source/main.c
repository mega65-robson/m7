// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      main.c
//       Purpose :   Compiler main program.
//       Date :      23rd March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#include <compiler.h>

/**
 * @brief      Main program
 *
 * @param[in]  argc  Argument Count
 * @param      argv  Arguments
 *
 * @return     Error code.
 */
int main(int argc,char *argv[]) {
    RTClearIdentifiers();
    printf("Hello, world\n");
    return 0;
}

