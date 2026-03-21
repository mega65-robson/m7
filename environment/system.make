# *******************************************************************************************
# *******************************************************************************************
#
#       Name :      system.make
#       Purpose :   Top level make include
#       Date :      21st March 2026
#       Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

# Operating system detection
UNAME_S := $(shell uname -s)

ifeq ($(UNAME_S),Linux)
    OS_NAME := linux
    BACKSLASH := 0
endif

ifeq ($(UNAME_S),Darwin)
    OS_NAME := macOS
    BACKSLASH := 0
endif

ifeq ($(OS),Windows_NT)
    OS_NAME := Windows
    BACKSLASH := 1
endif

#@echo "Operation System found: $(OS_NAME)"

MAKEROOTDIR =  $(dir $(realpath $(lastword $(MAKEFILE_LIST))))../
include $(MAKEROOTDIR)environment/common.$(OS_NAME).make

