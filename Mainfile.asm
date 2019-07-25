#include P16F84A.INC    
    __config _XT_OSC & _WDT_OFF & _PWRTE_ON
    
delay1	EQU 0x21
delay2	EQU 0x22
number	EQU 0x23
digit1	EQU 0x24
digit2	EQU 0x25
digit3	EQU 0x26
digit4	EQU 0x27
reset1	EQU 0x28
reset2	EQU 0x29
reset3	EQU 0x2A
reset4  EQU 0x2B
delay_5s_1  EQU 0x2C
delay_5s_2  EQU 0x2D
delay_5s_3  EQU 0x2E

    
    ORG h'0'
    bsf STATUS,5 ;select bank 1
	movlw B'00000000' ;set up port B as all outputs
	movwf TRISB
	movlw B'11111111'
	movwf TRISA
    bcf STATUS,5 ;select bank 0
    
;set reset code and default code
    movlw B'00000100' ;number 4
    movwf reset1
    movlw B'00000011'
    movwf reset2
    movlw B'00000010' ;number 2
    movwf reset3
    movlw B'00000001'
    movwf reset4
    movlw B'00000100' ;number 4
    movwf digit4
    movlw B'00000011'
    movwf digit3
    movlw B'00000010' ;number 2
    movwf digit2
    movlw B'00000001'
    movwf digit1 
    
start
    call hashpress
    
hashpress
    movlw B'11100011'
    movwf PORTB ;display L
    call delay
    call input
    movlw B'00001011'
    subwf number,0 ;checks if # is pressed
    btfsc STATUS,Z
    call numberpress1 ;# pressed, proceed to number checking
    goto hashpress; # not pressed, loop again till # pressed
    
numberpress1
    movlw B'10111111'
    movwf PORTB ;display -
    call delay
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    call compare1 ;button pressed,checks if 1st digit input is correct
    goto numberpress1; not pressed, loop again till number pressed
    
numberpress2
    movlw B'10111111'
    movwf PORTB ;display -
    call delay
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    call compare2 ;button pressed,checks if 2nd digit input is correct
    goto numberpress2
    
numberpress3
    movlw B'10111111'
    movwf PORTB ;display -
    call delay
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    call compare3 ;button pressed,checks if 3rd digit input is correct
    goto numberpress3
    
numberpress4
    movlw B'10111111'
    movwf PORTB ;display -
    call delay
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    call compare4 ;button pressed,checks if 1st digit input is correct
    goto numberpress4

compare1
    movf digit1,0
    subwf number,0
    btfsc STATUS,Z
    call numberpress2 ;correct, proceed to 2nd digit input
    goto wrongpress2;wrong

compare2
    movf digit2,0
    subwf number,0
    btfsc STATUS,Z
    call numberpress3 ;correct, proceed to 2nd digit input
    goto wrongpress3 ;wrong
 
compare3
    movf digit3,0
    subwf number,0
    btfsc STATUS,Z
    call numberpress4 ;correct, proceed to 2nd digit input
    goto wrongpress4 ;wrong
    
compare4
    movf digit4,0
    subwf number,0
    btfsc STATUS,Z
    call display.u ;correct, proceed to 2nd digit input
    goto hashpress ;wrong
    
display.u
    movlw B'11000111'
    movwf PORTB
    call delay_5s
    goto hashpress
    
wrongpress2
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    call wrongpress3
    goto wrongpress2
    
wrongpress3
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    call wrongpress4
    goto wrongpress3
    
wrongpress4
    call input
    movlw B'11111111'
    andwf number,0 ;detects button press
    btfss STATUS,Z
    goto hashpress
    goto wrongpress4
    
    
    
;###############################################################################   
input
    movlw B'00000010'
    movwf PORTB
    call row1
    movlw B'00000100'
    movwf PORTB
    call row2
    movlw B'00001000'
    movwf PORTB
    call row3
    movlw B'00010000'
    movwf PORTB
    call row4
    call input
    
row1
    btfsc PORTA,0
    call one
    btfsc PORTA,1
    call two
    btfsc PORTA,2
    call three
    return
    
row2
    btfsc PORTA,0
    call four
    btfsc PORTA,1
    call five
    btfsc PORTA,2
    call six
    return
    
row3
    btfsc PORTA,0
    call seven
    btfsc PORTA,1
    call eight
    btfsc PORTA,2
    call nine
    return

row4
    btfsc PORTA,0
    call star
    btfsc PORTA,1
    call zero
    btfsc PORTA,2
    call hash
    return
   
    
one
    movlw B'01011111'
    movwf PORTB
    call delay
    return
    
two
    movlw B'00100101'
    movwf PORTB
    call delay
    return
    
three
    movlw B'00001101'
    movwf PORTB
    call delay
    return
    
four
    movlw B'00011011'
    movwf PORTB
    call delay
    return
    
five
    movlw B'10001001'
    movwf PORTB
    call delay
    return
    
six
    movlw B'10000001'
    movwf PORTB
    call delay
    return
    
seven
    movlw B'01011101'
    movwf PORTB
    call delay
    return
    
eight
    movlw B'00000001'
    movwf PORTB
    call delay
    return
    
nine
    movlw B'00011001'
    movwf PORTB
    call delay
    return
    
star
    movlw B'00011111'
    movwf PORTB
    call delay
    return
    
zero
    movlw B'01000001'
    movwf PORTB
    call delay
    return
    
hash
    movlw B'00010011'
    movwf PORTB
    call delay
    movlw B'00001011'
    movwf number ;moves decimal number 11 to register 'number'
    return
    
    
;###############################################################################    
delay
    movlw H'FF'
    movwf delay1
    movlw H'FF'
    movwf delay2
delay_loop
    decfsz delay1,F
    goto delay_loop
    decfsz delay2,F
    goto delay_loop
    return
    
delay_5s
    movlw H'FA'
    movwf delay_5s_1
    movlw H'90'
    movwf delay_5s_2
    movlw H'06'
    movwf delay_5s_3
delay_loop_5s
    decfsz delay_5s_1,F
    goto delay_loop_5s
    decfsz delay_5s_2,F
    goto delay_loop_5s
    decfsz delay_5s_3,F
    goto delay_loop_5s
    return
    
    
    end
