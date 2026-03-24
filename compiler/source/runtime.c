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

uint8_t memory[65536];                                                              // Represents the memory space.
uint16_t baseAddress;                                                               // The load address of the PRG file
uint16_t nextFree;                                                                  // Next free byte.

static void _RTLoadDictionary(void);
/**
 * @brief      Load in the runtime, decode the dictionary and set up for compilation.
 *
 * @param      fileName  The file name
 */
void RTLoad(char *fileName) {
    IDClearIdentifiers();                                                           // Clear out all identifiers.
    LOG("Loading %s",fileName);
    FILE *f = fopen(fileName,"rb");                                                 // Open file.
    if (f == NULL) ERROR("Can't open kernel file %s to read.",fileName);
    baseAddress = fgetc(f);baseAddress += fgetc(f) << 8;                            // Read in the base address.
    LOG("Base address is %04x",baseAddress);
    size_t size = fread(memory+baseAddress,1,65536-baseAddress,f);                  // Read in the runtime into memory.
    LOG("Read %04lx bytes.",size);
    fclose(f);
    nextFree = baseAddress + size;                                                  // This is where we start writing
    LOG("Writing from %04x",nextFree);
    _RTLoadDictionary();                                                            // Load in the dictionary.
}

/**
 * @brief      Load the dictionary into memory.
 */
static void _RTLoadDictionary(void) {
    uint8_t *p = memory + baseAddress + RTOFFSET_DICTIONARY;                        // Where the dictionary starts is here.
    char name[MAX_IDENT_LENGTH+1];                                                  // Buffer for name.
    p = memory + (p[0] + (p[1] << 8) + (p[2] << 16) + (p[3] << 24));                // Read the start address.
    LOG("Dictionary at $%04x",p - memory);
    while (*p != '\0') {
        char *t = name;
        while ((*p & 0x80) == 0) *t++ = *p++;                                       // Copy from dictionary
        *t++ = (*p++) & 0x7F;
        *t = '\0';
        int address = p[0] + p[1] * 256;
        IDAdd(name,(address < 128) ? ByteCode : CodeWord,address);                  // Save in identifier structure.
        p += 2;
    }
    IDList();
}

/**
 * @brief      Write a long to a memory location
 *
 * @param[in]  address  The address
 * @param[in]  v        { parameter_description }
 */
void RTWriteLong(uint16_t address,uint32_t v) {
    ASSERT(address >= baseAddress && address < nextFree);
    memory[address] = v;
    memory[address+1] = v >> 8;
    memory[address+2] = v >> 16;
    memory[address+3] = v >> 24;
}

/**
 * @brief      Write a byte to the program position and advance that position.
 *
 * @param[in]  b     Byte to write.
 */
void RTWriteByte(uint8_t b) {
    memory[nextFree++] = b;    
}

/**
 * @brief      Get the base address of the kernel in memory
 *
 * @return     Load address of the kernel
 */
int RTGetBaseAddress(void) {
    return baseAddress;
}

/**
 * @brief      Get the current program pointer value
 *
 * @return     Current program pointer.
 */
int RTGetPCTR(void) {
    return nextFree;
}

/**
 * @brief      Write current kernel to storage
 *
 * @param      fileName  File to save under
 */
void RTSave(char *fileName) {
    LOG("Saving %s $%x-$%x",fileName,baseAddress,nextFree-1);
    RTWriteLong(baseAddress+RTOFFSET_FREEMEM,nextFree);                             // Set free memory pointer to next free byte
    FILE *f = fopen(fileName,"wb");
    if (f == NULL) ERROR("Can't open %s to write app",fileName);
    fputc(baseAddress & 0xFF,f);                                                    // Write header
    fputc(baseAddress >> 8,f);
    size_t w = fwrite(memory+baseAddress,1,nextFree-baseAddress,f);                 // Write the body out.
    if (w != nextFree-baseAddress) ERROR("Write failed to %s",fileName);
    fclose(f);
}
