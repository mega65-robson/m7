# *******************************************************************************************
# *******************************************************************************************
#
#      Name :      divide.py
#      Purpose :   16 bit divide algorithm.
#      Date :      21st March 2026
#      Author :    Paul Robson (paul@robsons.org.uk)
#
# *******************************************************************************************
# *******************************************************************************************

import random

def divide(dividend,divisor):
    actualQ = int(dividend/divisor)
    actualR = dividend % divisor
    #
    #       Calculate B/A
    #
    z = 0                   
    b = dividend            
    a = divisor             

    for i in range(0,16):
        # shift left Z:B as 32 bit value
        z = ((z << 1) | ((b >> 15) & 1)) & 0xFFFF
        b = (b << 1) & 0xFFFF
        # can we subtract ? if so save result in A and set LSB of q
        if z >= a:
            b = b | 1
            z = z - a

    quotient = b
    remainder = z
    #
    #   a unchanged. Copy B or Z and restore B.
    #
    #print(quotient,remainder,actualQ,actualR)
    assert actualQ == quotient
    assert actualR == remainder

for t in range(0,1000*1000):
    v1 = random.randint(1,0xFFFF)
    v2 = random.randint(1,0xFFFF)
    if random.randint(0,1) == 0:
        v2 = random.randint(1,0xFF)
    if random.randint(0,1) == 0:
        v2 = random.randint(1,0xF)
    divide(v1,v2)
