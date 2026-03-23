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
    zz = 0                   
    bb = dividend            
    aa = divisor             

    for i in range(0,16):
        # shift left ZZ:BB as 32 bit value
        zz = ((zz << 1) | ((bb >> 15) & 1)) & 0xFFFF
        bb = (bb << 1) & 0xFFFF
        # can we subtract ? if so save result in A and set LSB of q
        if zz >= aa:
            bb = bb | 1
            zz = zz - aa

    quotient = bb
    remainder = zz
    #
    #   a unchanged. Copy B or Z and restore B.
    #
    #print(quotient,remainder,actualQ,actualR)
    assert actualQ == quotient
    assert actualR == remainder

for t in range(0,10*1000):
    v1 = random.randint(1,0xFFFF)
    v2 = random.randint(1,0xFFFF)
    if random.randint(0,1) == 0:
        v2 = random.randint(1,0xFF)
    if random.randint(0,1) == 0:
        v2 = random.randint(1,0xF)
    divide(v1,v2)
