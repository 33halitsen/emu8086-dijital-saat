;in this line, open the simulator extention
#start = emulation_kit.exe#
 
MOV [0300h], 0 ; set second to zero and use 0300h memory for second
MOV [0304h], 0 ; set second to zero and use 0304h memory for minute
MOV [0308h], 0 ; set second to zero and use 0308h memory for hour

CALL SECOND
CALL MINUTE
CALL HOUR

 

BEGIN:           ; this label to start BEGIN

MOV DX, 2084h    ; in this line, take input set switch to set BEGIN. 2084h is addres of input switch.
IN  AL, DX  ;The value of the input switch is read into the AL register
CMP AL, 1 ; AL register is compared with 1 to check if the switch is set. If set, the program jumps
          ; to the SET label to allow for clock adjustment.
JE SET      ; jump the set 

INC [0300h] 
CALL SECOND ; prýnt second after ýncreasing teh second in 0300h

CMP [0300h], 59
JNE BEGIN   ; if second is not equal to 59 jump BEGIN, equal to 59, continue the code and increase minute

MOV [0300h], 0 
CALL SECOND    

INC [0304h] 
CALL MINUTE  ; prýnt minute after ýncreasing teh minute in 0304h

CMP [0304h], 59
JNE BEGIN ; ; if minute is not equal to 59 jump BEGIN, equal to 59, continue the code and increase hour

MOV [0304h], 0
CALL MINUTE

INC [0308h]
CALL HOUR   ; prýnt minute after ýncreasing teh minute in 0308h

CMP [0308h], 24
JNE BEGIN 

MOV [0308h], 0
CALL HOUR 

JMP BEGIN ; the hour is 24, so ti is finish, agin start for zero



SECOND: ; this label use for print the second ýn 7 segment

MOV AX, [0300h]
MOV BL, 10d
DIV BL          ; second value divide by 10 to find ones place and tens place
MOV BH, AL

MOV DX, 2037h
MOV [0101h], AH
CALL SEVEN_SEGMENT  ; calling to find seven segment binary code for printed value
OUT DX, AL

MOV DX, 2036h
MOV [0101h],BH 
CALL SEVEN_SEGMENT
OUT DX, AL

RET


MINUTE:  ; this label use for print the second ýn 7 segment

MOV AX, [0304h]
MOV BL, 10d
DIV BL      ; second value divide by 10 to find ones place and tens place
MOV BH, AL

MOV DX, 2034h
MOV [0101h], AH
CALL SEVEN_SEGMENT  ; calling to find seven segment binary code for printed value
OUT DX, AL

MOV DX, 2033h
MOV [0101h], BH
CALL SEVEN_SEGMENT
OUT DX, AL 

RET


HOUR:  ; this label use for print the second ýn 7 segment

MOV AX, [0308h]
MOV BL, 10d
DIV BL    ; second value divide by 10 to find ones place and tens place
MOV BH, AL

MOV DX, 2031h
MOV [0101h], AH
CALL SEVEN_SEGMENT   ; calling to find seven segment binary code for printed value
OUT DX, AL

MOV DX, 2030h
MOV [0101h], BH
CALL SEVEN_SEGMENT
OUT DX, AL 

RET



SEVEN_SEGMENT: ; this label to find binary code for printed value. if 7 segment pýn's acitve, their binary order is one.

CMP [0101h], 0 
JE ZERO        ; in this, je commands to jump label of printed value
  
                 
CMP [0101h], 1 
JE ONE  


CMP [0101h], 2 
JE TWO  

            
CMP [0101h], 3
JE THREE 


CMP [0101h], 4 
JE FOUR  


CMP [0101h], 5 
JE FIVE 


CMP [0101h], 6 
JE SIX 


CMP [0101h], 7 
JE SEVEN
   

CMP [0101h], 8 
JE EIGHT
 

CMP [0101h], 9h 
JE NINE 

RET
 



ZERO: MOV AL, 00111111b  ; label of value is to move binary codes to al register
RET
                             
ONE: MOV AL, 00000110b
RET       
       
TWO: MOV AL, 01011011b 
RET

THREE: MOV AL, 01001111b
RET

FOUR: MOV AL,  01100110b 
RET

FIVE: MOV AL, 01101101b  
RET

SIX: MOV AL, 01111101b 
RET

SEVEN: MOV AL, 00000111b 
RET

EIGHT: MOV AL, 01111111b  
RET

NINE: MOV AL, 01101111b 
RET 


SET:          ; this label to set to BEGIN
   
MOV DX, 2084h
IN  AX, DX
CMP AX, 0
JE SECOND_ZERO   ; if the set switch is closed, return to count BEGIN.


MOV AH, 1 
INT 21h 

CMP AL, 31h    
JE DEC_MIN  ; if keybord interrupt is equal to 31 jump DEC_MIN
 
CMP AL, 32h
JE INC_MIN  ; if keybord interrupt is equal to 32 jump INC_MIN

CMP AL, 33h
JE DEC_HOUR ; if keybord interrupt is equal to 33 jump DEC_HOUR
 
CMP AL, 34h
JE INC_HOUR ; if keybord interrupt is equal to 34 jump INC_HOUR


MOV DX, 2084h
IN  AX, DX
CMP AX, 1
JE SET ; if the set switch is opened, jump to set and again.



DEC_MIN:       ; this label to decrease minute

CMP [0304h], 0 
JE DEC_MIN_2


DEC [0304h]
CALL MINUTE 
JMP SET
 
DEC_MIN_2:      ; if the minute is equal to zero, set the minute to 59   
MOV [0304h], 59
CALL MINUTE
JMP SET 


 

INC_MIN:        ; this label to decrease minute

CMP [0304h], 59 
JE INC_MIN_2

INC [0304h]
CALL MINUTE 
JMP SET 

INC_MIN_2:        ; if the minute is equal to 59, set the minute to 0
MOV [0304h], 0
CALL MINUTE
JMP SET

 
 
 

DEC_HOUR:       ; this label to decrease hour

CMP [0308h], 0 
JE DEC_HOUR_2

DEC [0308h]
CALL HOUR 
JMP SET 


DEC_HOUR_2:       ; if the hour is equal to zero, set the hour to 23  

MOV [0308h], 23
CALL HOUR
JMP SET




INC_HOUR:        ; this label to decrease hour

CMP [0308h], 23 
JE INC_HOUR_2

INC [0308h]
CALL HOUR 
JMP SET 

INC_HOUR_2:       ; if the hour is equal to 23, set the hour to zero  

MOV [0308h], 0
CALL HOUR
JMP SET 


SECOND_ZERO:

MOV [0300h], 0 
CALL SECOND

JMP BEGIN