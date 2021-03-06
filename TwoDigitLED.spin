{{
 TwoDigitLED
 by Chris Cantrell
 Version 1.0 6/27/2012
 Copyright (c) 2012 Chris Cantrell
 See end of file for terms of use.
}}

{{

F000        twoDigitDecimal   00-99 (FF=use patterns)
F001        leftPattern       Dabcdefg
F002        rightPattern      Dabcedfg
F003        blinkRate         00=slow .. FF=fast
F004        blinkOn           00=off  .. FF=full
F010..F01F  ledShades[16]     00=off  .. FF=full

}}

var

long stackSpace[16]
long cognum

pub start

cognum := cognew(TwoDigitLED, @stackSpace)
return cognum

pri TwoDigitLED


  dira := dira | %00001111_11100001_00000001_11111111


  repeat
    repeat i from 1 to 10
      if i<5
        outa := 0
      else
        outa := %11110
  
     
{{

┌──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│                                                   TERMS OF USE: MIT License                                                  │                                                            
├──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation    │ 
│files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,    │
│modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software│
│is furnished to do so, subject to the following conditions:                                                                   │
│                                                                                                                              │
│The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.│
│                                                                                                                              │
│THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE          │
│WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR         │
│COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,   │
│ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.                         │
└──────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────┘
}}    