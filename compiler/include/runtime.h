// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      runtime.h
//       Purpose :   Runtime include
//       Date :      23rd March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#pragma once

void RTLoad(char *fileName);
void RTSave(char *fileName);
void RTWriteLong(uint16_t address,uint32_t v);
int RTGetBaseAddress(void);
int RTGetPCTR(void);

#define RTOFFSET_BOOT           (8)
#define RTOFFSET_DICTIONARY     (12)
#define RTOFFSET_FREEMEM        (16)