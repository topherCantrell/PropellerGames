{{
 Hi/Lo 
 by Chris Cantrell
 Version 1.0 4/9/2012
 Copyright (c) 2012 Chris Cantrell
 See end of file for terms of use.
}}

{{


  Hi/Lo breadboard layout: 5 buttons, a speaker, and
  a two-digit 7-segment LED display.

  ┌────────────────────────────────────────────────────┐                                                               
  │                                        ┌─┐         │
  │   u                                    └─┘         │
  │        a(LED)      A                  S(Speaker) │
  │       ─────       ─────      y                     │
  │      │     │     │     │                           │
  │     f│    b│    F│    B│                           │
  │      │     │     │     │                           │          
  │       ─────       ─────                            │
  │      │  g  │     │  G  │                          │
  │     e│    c│    E│    C│         x(Button)         │
  │      │     │     │     │                           │
  │       ─────  •    ─────  •                         │
  │        d    p      D    P                        │
  │   v                          w                     │
  └────────────────────────────────────────────────────┘  

  I/O Pin Function
  
  33222222 22221111 111111
  10987654 32109876 54321098 76543210
  ****BAFb agf----S yuvwx--e dcpEDGCP  I/O pin function

  * = USB/EPROM
  - = not used (available)

  ################# LED Display #################

  http://www.mouser.com
  Mouser Electronics
  PN: 630-HDSP-521E
  Common anode red 7-segment display (two)

                     ┌───┳──────────────────┐
                     │   │                  
     f   g   a   b   │C1 │C2 F   A   B     Ground
  ┌──┻───┻───┻───┻───┻───┻───┻───┻───┻─┐ 
  │ 18  17  16  15  14  13  12  11  10 │       
  │                                    │       
  │  LED Display: Avago HDSP-523E      │
  │                                    │
  │• 1   2   3   4   5   6   7   8   9 │                        
  └──┳───┳───┳───┳───┳───┳───┳───┳───┳─┘
     e   d   c   p   E   D   G   C   │P  220Ω
                                     └───── Propeller

  ################# Pushbuttons #################
  
  http://www.pololu.com
  Pololu Robotics & Electronics
  PN: 1400
  Mini Pushbutton Switdh: PCB-Mount, 2-Pin, SPST, 50mA (5-Pack)
  
  
  3.3V       Push buttons                         
          ─┴─
    └───── ───┳─────────  Propeller
                   10KΩ
                                     
                 Ground

  ################# Speaker #################

  http://www.digikey.com/
  Digi-Key
  PN: 668-1140-ND
  SPEAKER 32OHM .2W 90DB 17MM PCMT - AST-1732MR-R
  
    Speaker ┌──┐+
        ┌───┫  ┣───  Propeller
           └──┘
       Ground
}}

CON
  _clkmode = xtal1 + pll16x
  _xinfreq = 5_000_000

  SPLASH_DELAY = 8000        ' Delay between Hi and Lo in splash sequence
  
  TONE_P10_FREQ = 40000      ' Delay/length constants for four tones
  TONE_P10_LEN  = 200

  TONE_M10_FREQ = 50000
  TONE_M10_LEN  = 200

  TONE_P1_FREQ  = 45000
  TONE_P1_LEN   = 200

  TONE_M1_FREQ  = 55000
  TONE_M1_LEN   = 200

OBJ

  'PST : "Parallax Serial Terminal"   ' For debugging
  
  DIGITS  : "TwoDigitLED"
  SPEAKER : "Speaker"

VAR

  long computerNumber     ' Holds the computer's number throughout a game
  long playerGuess        ' Holds the player's guess throughout a game

DAT
  ' These are the output pin bit-patterns for numeric digits. To create a two-
  ' digit display you OR a long from the left and a long from the right and
  ' write it to the output pins.
                                                                      
  '                [0] = Left digit                    [1] = Right digit
  '            BAFb agf----S yuvwx--e dcpEDGCP     BAFb agf----S yuvwx--e dcpEDGCP
  LED_00 long %0001_10100000_00000001_11000000,   %1110_00000000_00000000_00011010
  LED_11 long %0001_00000000_00000000_01000000,   %1000_00000000_00000000_00000010
  LED_22 long %0001_11000000_00000001_10000000,   %1100_00000000_00000000_00011100
  LED_33 long %0001_11000000_00000000_11000000,   %1100_00000000_00000000_00001110
  LED_44 long %0001_01100000_00000000_01000000,   %1010_00000000_00000000_00000110
  LED_55 long %0000_11100000_00000000_11000000,   %0110_00000000_00000000_00001110
  LED_66 long %0000_11100000_00000001_11000000,   %0110_00000000_00000000_00011110
  LED_77 long %0001_10000000_00000000_01000000,   %1100_00000000_00000000_00000010
  LED_88 long %0001_11100000_00000001_11000000,   %1110_00000000_00000000_00011110
  LED_99 long %0001_11100000_00000000_11000000,   %1110_00000000_00000000_00001110
  LED_Hi long %0001_01100000_00000001_01000000,   %0000_00000000_00000000_00010000
  LED_Lo long %0000_00100000_00000001_10000000,   %0000_00000000_00000000_00011110
  
PUB start
'
'' This entry function manages the splash (attract) sequence and the game
'' play for Hi-Lo.



  DIGITS.start
  repeat



  ' USB terminal for debugging
  ' waitcnt(clkfreq+cnt)  ' Wait for user to switch to terminal
  ' PST.start(115200)     ' Start the terminal driver
    
  ' ****BAFb_agf----S_yuvwx--e_dcpEDGCP  I/O pin function
  ' 00001111_11100001_00000001_11111111  I/O pin direction OR mask

  'dira := dira | %00001111_11100001_00000001_11111111
    
  'repeat
    'splash
    'playGame

PUB playGame
'
'' This function plays one game by waiting for user input and then
'' giving the "Higer" or "Lower" hints. The function returns when
'' the player has guessed the 'computerNumber'.

  computerNumber := cnt ' Seed the random number with the clock                                          
  computerNumber := (?computerNumber) ' Pseudo random number -MAX to +MAX
  computerNumber := || computerNumber ' Absolute value ... 0 to +MAX
  computerNumber := computerNumber // 100 ' Random number between 0 and 99

  playerGuess := 0  
  repeat
    getPlayerGuess
    if playerGuess==computerNumber
      showWin
      return
    elseif playerGuess<computerNumber
      showHint(true)
    else
      showHint(false)

PUB splash
'
'' This function attracts a player to the game. It flashes "Hi" and "Lo"
'' and returns when the player presses any key. The 'computerNumber' is
'' set here as a fast running counter that freezes when a button is
'' pressed.

  repeat
    drawHi             
    if pauseStopOnAnyButton(SPLASH_DELAY)
      return
    drawLo
    if pauseStopOnAnyButton(SPLASH_DELAY)
      return

PUB showWin | i
'
'' This function shows the player won by playing a tone and flashing the
'' correct number on the display. The function returns when the player
'' presses any button.

  repeat i from 1 to 3
    drawNumber(computerNumber)
    playTone(TONE_P10_FREQ,TONE_P10_LEN)
    drawBlank
    pauseStopOnAnyButton(2500)

  repeat
    drawNumber(computerNumber)
    if pauseStopOnAnyButton(5000)
      repeat while isAny 
      return
    drawBlank
    if pauseStopOnAnyButton(5000)
      repeat while isAny 
      return

PUB showHint(higher)
'
'' This function shows "Hi" for "Higher" or "Lo" for "Lower" as
'' a hint to the player. The function draws the hint and plays
'' a tone and returns immediately.

  if higher
    drawHi
    playTone(TONE_P10_FREQ,TONE_P10_LEN)
  else
    drawLo
    playTone(TONE_M1_FREQ,TONE_M1_LEN)
 
PUB getPlayerGuess
'
'' This function takes the player input. Each digit has an "up" and "down"
'' button on each corner. Tones are played as the input changes. This function
'' returns with 'playerGuess' set when the player presses the right-middle
'' (enter) button.
          
  drawNumber(playerGuess)
  repeat while isAny ' Wait for any previous input

  repeat    
  
    if isMiddleRight
      return
    
    if isUpperLeft      
      playerGuess := playerGuess + 10
      if playerGuess > 99
        playerGuess := playerGuess - 100
      drawNumber(playerGuess)
      playTone(TONE_P10_FREQ,TONE_P10_LEN)  

    if isLowerLeft
      playerGuess := playerGuess - 10
      if playerGuess < 0
        playerGuess := playerGuess + 100
      drawNumber(playerGuess)
      playTone(TONE_M10_FREQ,TONE_M10_LEN)

    if isUpperRight
      playerGuess := playerGuess + 1
      if playerGuess > 99
        playerGuess := playerGuess - 100
      drawNumber(playerGuess)
      playTone(TONE_P1_FREQ,TONE_P1_LEN)

    if isLowerRight
      playerGuess := playerGuess - 1
      if playerGuess < 0
        playerGuess := playerGuess + 100
      drawNumber(playerGuess)
      playTone(TONE_M1_FREQ,TONE_M1_LEN)      





' Functions to read buttons


  
PUB isAny | i
'
'' This function returns 'true' if any button is pressed.

  i := ina & %11111_000_00000000
  return i<>0 
  
PUB isUpperLeft
'
'' This function returns 'true' if the upper-left button is pressed.

  return ina & %01000_000_00000000

PUB isLowerLeft
'
'' This function returns 'true' if the lower-left button is pressed.

  return ina & %00100_000_00000000

PUB isUpperRight
'
'' This function returns 'true' if the upper-right button is pressed.

  return ina & %10000_000_00000000

PUB isLowerRight
'
'' This function returns 'true' if the lower-right button is pressed.

  return ina & %00010_000_00000000

PUB isMiddleRight
'
'' This function returns 'true' if the middle-right (enter) button
'' is pressed.

  return ina & %00001_000_00000000



' Functions to draw on the LED display



PUB drawBlank
'
'' This function blanks both digits.

  outa := 0
  
PUB drawHi | value
'
'' This function draws "Hi".

  value := LED_Hi[0] | LED_Hi[1]
  outa := value

PUB drawLo | value
'
'' This function draws "Lo".

  value := LED_Lo[0] | LED_Lo[1]
  outa := value  
  
PUB drawNumber(value)  | left, right
'
'' This function draws a two-digit (decimal) value.

  left  := value/10
  right := value//10

  left  := LED_00[left*2]
  right := LED_00[right*2 + 1]

  left := left | right
  outa := left


  

' Functions to control the speaker and pauses




PUB pauseStopOnAnyButton(length) | i
'
'' This function pauses for given time. The pause may be aborted
'' by pressing any button. This function returns true if the pause
'' was interrupted by a button or false if the timer expired.

  repeat i from 1 to length
    waitcnt(cnt+length)  
    if isAny
      return true
      
  return false
  
PUB playTone(freq, length) | i
'
'' This function plays a tone on the speaker. The 'freq' input value
'' controls the frequency of the tone and the 'length' input value
'' controls the duration of the tone.

  repeat i from 1 to length
    outa[16] := 1
    waitcnt(cnt+freq)
    outa[16] := 0
    waitcnt(cnt+freq)
      
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
                 