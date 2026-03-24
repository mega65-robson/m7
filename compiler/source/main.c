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
    IDClearIdentifiers();
    printf("%s\n",argv[1]);
    RTLoad(argv[1]);
    RTSave(argv[2]);
    return 0;
}

