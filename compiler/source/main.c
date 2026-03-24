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
    if (argc < 4) {
        fprintf(stderr,"m7c <kernel> <application> <source> <source> ....\n");
        return 1;
    }
    IDClearIdentifiers();
    RTLoad(argv[1]);
    for (int n = 3;n < argc;n++) {
        char *code = PRProcess(argv[n]);
        SPProcess(code);
    }
    RTSave(argv[2]);
    return 0;
}

