// ************************************************************************************************
// ************************************************************************************************
//
//       Name :      compiler.h
//       Purpose :   General include file
//       Date :      23rd March 2026
//       Author :    Paul Robson (paul@robsons.org.uk)
//
// ************************************************************************************************
// ************************************************************************************************
 
#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <ctype.h>
#include <stdarg.h>

#include "identifiers.h"
#include "runtime.h"
#include "process.h"
#include "split.h"
#include "worker.h"

#define ERROR       ReportError

#ifdef DEBUG
#define ASSERT(x)   if (!(x)) exit(fprintf(stderr,"ASSERT: %s (%d)\n",__FILE__,__LINE__))
#define LOG         LogInformation
#else
#define ASSERT(x)   {}
#define LOG(x,...)  {}
#endif

void ReportError(char *format, ...);
void LogInformation(char *format , ...);
bool StringToInteger(char *s,int *pResult);
