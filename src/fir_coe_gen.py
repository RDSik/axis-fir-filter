from __future__ import print_function
from __future__ import division

import numpy as np

# Example code, computes the coefficients of a low-pass windowed-sinc filter.

# Configuration.
fS = 20000000  # Sampling rate.
fL = 2000000  # Cutoff frequency.
N = 29  # Filter length, must be odd.
beta = 3.395  # Kaiser window beta.

# Compute sinc filter.
h = np.sinc(2 * fL / fS * (np.arange(N) - (N - 1) / 2))

# Apply window.
h *= np.kaiser(N, beta)

# Normalize to get unity gain.
h /= np.sum(h)

# Applying the filter to a signal s can be as simple as writing
# s = np.convolve(s, h)

# Python3 program to convert decimal 
# to hexadecimal covering negative numbers 

# Function to convert decimal no. 
# to hexadecimal number 
def Hex(num) : 

    # map for decimal to hexa, 0-9 are 
    # straightforward, alphabets a-f used 
    # for 10 to 15. 
    m = dict.fromkeys(range(16), 0)

    digit = ord('0')
    c = ord('a') 

    for i in range(16) :
        if (i < 10) :
            m[i] = chr(digit)
            digit += 1
        
        else :
            m[i] = chr(c)
            c += 1

    # string to be returned 
    res = "" 

    # check if num is 0 and directly return "0" 
    if (not num) :
        return "0" 

    # if num>0, use normal technique as 
    # discussed in other post 
    if (num > 0) :
        while (num) :
            res = m[num % 16] + res 
            num //= 16 
    
    # if num<0, we need to use the elaborated 
    # trick above, lets see this 
    else :
        
        # store num in a u_int, size of u_it is greater, 
        # it will be positive since msb is 0 
        n = num + 2**32 

        # use the same remainder technique. 
        while (n) :
            res = m[n % 16] + res 
            n //= 16 

    return res[4:]

# This code is contributed by AnkitRai01

file_name = 'coe.mem'

with open (file_name, 'w') as f:
    for i in range(len(h)):
        if h[i] > 0:
            hexa = str(hex(round(h[i]*32768)))[2:]
            if len(hexa) < 4:
                f.write('0' * (4-len(hexa)) + hexa)
            else:
                f.write(hexa)
        else:
            hexa = round(h[i]*32768)
            if len(str(hexa)) < 4:
                f.write('0' * (4-len(str(hexa))) + Hex(hexa))
            else:
                f.write(Hex(hexa))
        if i < len(h) - 1:
            f.write('\n')