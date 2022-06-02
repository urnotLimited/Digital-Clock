ORG 0000H
JMP MAIN
ORG 0003H
LJMP INTER0
ORG 000BH
LJMP INTT0

MaxCLK BIT  P1.0
MaxCS  BIT  P1.1
MaxDIN BIT  P1.2
	
RST    BIT  P1.3
DSIO   BIT  P1.4
SCLK   BIT  P1.5

BEEP   BIT  P1.6
	
ORG 1000H
MAIN:			
                ;CALL Ds1302Init   ;计时模块初始化
				;CALL DELAY
				CALL Init_MAX     ;显示模块初始化
				SETB IT0          ;中断设置                      
				SETB EA
				SETB EX0
				SETB ET0
				MOV 5BH,#00H       ;定时器计数标志位
				MOV TMOD, #01H
				MOV TH0,#3CH
				MOV TL0,#0B0H
				SETB TR0

LOOP:      		
				CALL DATAPROS      ;读取计时模块时间数据
				CALL TIME1         ;显示时分秒
				CALL DELAY
				JMP LOOP
				
				
WRITE_BYTE:  	MOV R1 ,#8         ;向MAX7219的一个寄存器写入数据
				CLR MaxCS
WRITE_BYTE1:	MOV A ,40H												
				CLR MaxCLK
				ANL A,#80H
				CJNE A,#80H,BYTE1
				SETB MaxDIN
				JMP BYTE2
BYTE1:			CLR  MaxDIN	
BYTE2:			SETB MaxCLK
				MOV A ,40H
				RL A
				MOV 40H ,A	
				DJNZ R1, WRITE_BYTE1
				RET


Write_Max1:		                   ;写第一个矩阵模块的8行数据
				CLR MaxCS
			    MOV  40H, R2
				CALL WRITE_BYTE
				MOV 40H, R3
				CALL WRITE_BYTE
				SETB MaxCS
				RET
				
Write_Max2:		                  ;写第二个矩阵模块的8行数据
				CLR MaxCS
			    MOV  40H, R2
				CALL WRITE_BYTE
				MOV  40H, R3
				CALL WRITE_BYTE
				SETB MaxCLK
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				SETB MaxCS
				RET				

Write_Max3:			                  ;写第三个矩阵模块的8行数据	
				CLR MaxCS
			    MOV  40H, R2
				CALL WRITE_BYTE
				MOV  40H, R3
				CALL WRITE_BYTE
				SETB MaxCLK
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				SETB MaxCS
				RET			

Write_Max4:			                  ;写第四个矩阵模块的8行数据	
				CLR MaxCS
			    MOV  40H, R2
				CALL WRITE_BYTE
				MOV  40H, R3
				CALL WRITE_BYTE
				SETB MaxCLK
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				MOV  40H, #00H
				CALL WRITE_BYTE
				SETB MaxCS
				RET	
MULITWrite:			                  ;写总共4个矩阵模块的8行数据	
				CLR MaxCS
			    MOV  40H, R2
				CALL WRITE_BYTE				
				MOV  40H, 41H
				CALL WRITE_BYTE
				MOV  40H, R2
				CALL WRITE_BYTE
				MOV  40H, 42H
				CALL WRITE_BYTE
				MOV  40H, R2
				CALL WRITE_BYTE
				MOV  40H, 43H
				CALL WRITE_BYTE
				MOV  40H, R2
				CALL WRITE_BYTE
				MOV  40H, 44H
				CALL WRITE_BYTE
				SETB MaxCS
				RET	
				
				
				
Init_MAX:		                     ;矩阵模块初始化
				MOV R2,#09H
				MOV R3,#00H
				CALL Write_Max1
				MOV R2,#0AH
				MOV R3,#03H
				CALL Write_Max1
				MOV R2,#0BH
				MOV R3,#07H
				CALL Write_Max1
				MOV R2,#0CH
				MOV R3,#01H
				CALL Write_Max1
				MOV R2,#0FH
				MOV R3,#00H
				CALL Write_Max1
				MOV R2,#09H
				MOV R3,#00H
				CALL Write_Max2
				MOV R2,#0AH
				MOV R3,#03H
				CALL Write_Max2
				MOV R2,#0BH
				MOV R3,#07H
				CALL Write_Max2
				MOV R2,#0CH
				MOV R3,#01H
				CALL Write_Max2
				MOV R2,#0FH
				MOV R3,#00H
				CALL Write_Max2
				MOV R2,#09H
				MOV R3,#00H
				CALL Write_Max3
				MOV R2,#0AH
				MOV R3,#03H
				CALL Write_Max3
				MOV R2,#0BH
				MOV R3,#07H
				CALL Write_Max3
				MOV R2,#0CH
				MOV R3,#01H
				CALL Write_Max3
				MOV R2,#0FH
				MOV R3,#00H
				CALL Write_Max3
				MOV R2,#09H
				MOV R3,#00H
				CALL Write_Max4
				MOV R2,#0AH
				MOV R3,#03H
				CALL Write_Max4
				MOV R2,#0BH
				MOV R3,#07H
				CALL Write_Max4
				MOV R2,#0CH
				MOV R3,#01H
				CALL Write_Max4
				MOV R2,#0FH
				MOV R3,#00H
				CALL Write_Max4
				RET



Ds1302Write:    CLR RST     ;计时模块写数据
				NOP
				CLR SCLK
				NOP
				SETB RST
				NOP
                MOV R0,#8
Ds1302Write1:	MOV A ,R2
				ANL A ,#01H
				CJNE A,#01H,Write1
				SETB DSIO
				JMP Write2
Write1:         CLR  DSIO
Write2:         MOV A,R2
				RR A
				MOV R2,A
				SETB SCLK
				NOP
				CLR SCLK
				NOP
				DJNZ R0, Ds1302Write1
				MOV R0,#8
Ds1302Write2:	MOV A ,R3
				ANL A ,#01H
				CJNE A,#01H,Write3
				SETB DSIO
				JMP Write4
Write3:         CLR  DSIO
Write4:         MOV A,R3
				RR A
				MOV R3,A
				SETB SCLK
				NOP
				CLR SCLK
				NOP
				DJNZ R0, Ds1302Write2				
				CLR RST
				NOP
				RET



Ds1302Read:		CLR RST         ;计时模块读数据   
				NOP
				CLR SCLK
				NOP
				SETB RST
				NOP
				MOV R0,#8
Ds1302Read1:	MOV A ,R2
				ANL A ,#01H
				CJNE A,#01H,Read1
				SETB DSIO
				JMP Read2
Read1:         	CLR  DSIO
Read2:         	MOV A,R2
				RR A
				MOV R2,A
				SETB SCLK
				NOP
				CLR SCLK
				NOP
				DJNZ R0, Ds1302Read1				
				NOP
				MOV R0,#8
				MOV 45H,#00H    ;45H放从ds1302读取的数据
Ds1302Read2:	MOV C ,DSIO 
				JNC  Address1
				MOV A,45H
				RRC A
				MOV 45H,A
				JMP Address2
Address1:		MOV A,45H	
				RR A
				MOV 45H ,A
Address2:		SETB SCLK
				NOP
				CLR  SCLK
				NOP
				DJNZ R0 ,Ds1302Read2
				CLR RST
				NOP
				SETB SCLK
				NOP
				CLR DSIO
				NOP
				SETB DSIO
				NOP
				RET
 


Ds1302Init:                      ;计时模块初始化
				MOV R2,#8EH
				MOV R3,#00H
				CALL Ds1302Write
				MOV R1,#0
Init1:		    MOV A,R1
				MOV DPTR,#WRITE_ADDR
				MOVC A,@A+DPTR
				MOV R2,A
				MOV A,R1
				MOV DPTR,#TIME
				MOVC A,@A+DPTR
				MOV R3,A
				CALL Ds1302Write
				INC R1
				CJNE R1,#7,Init1
				MOV R2,#8EH
				MOV R3,#80H
				CALL Ds1302Write
				RET
				
Ds1302ReadTime:	 
				MOV DPTR,#READ_ADDR
				MOV R1 ,#46H                
				MOV R3,#0
ReadTime1:		MOV A,R3
                MOVC A,@A+DPTR
				MOV R2,A
				CALL Ds1302Read				
				INC R3
				MOV @R1,45H
				INC R1                       
				CJNE R1,#4DH,ReadTime1
				RET
				
DATAPROS:
                CALL Ds1302ReadTime
				MOV R1, #4DH
				MOV R0, #4CH
DATAPROS1: 		MOV B,#16
                MOV A,@R0
				DIV AB
				MOV @R1,A
				INC R1
				MOV A,@R0
				ANL A,#0FH
				MOV @R1,A
				INC R1
				DEC R0
				CJNE R0,#45H,DATAPROS1
				RET
				
SHOWTIME:
				MOV R0, #0
				
SHOWTIME1:		MOV A, #8
				MOV B, 4DH
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE2
                MOVC A,@A+DPTR
				MOV 41H,A
				MOV A,#8
				MOV B,4EH
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE2
                MOVC A,@A+DPTR
				MOV B,#16
				DIV AB
				ORL 41H,A
				
				MOV A, #8
				MOV B, 51H
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE1
                MOVC A,@A+DPTR
				MOV 42H,A
				MOV A,#8
				MOV B,52H
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE1
                MOVC A,@A+DPTR
				MOV B,#32
				DIV AB
				ORL 42H,A
				
				MOV A,#8
				MOV B,52H
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE1
                MOVC A,@A+DPTR
				MOV B,#8
				MUL AB
				MOV 43H,A
				MOV A,#8
				MOV B,53H
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE1
                MOVC A,@A+DPTR
				MOV B,#8
				DIV AB
				ORL 43H,A
				
				MOV A,#8
				MOV B,54H
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE1
                MOVC A,@A+DPTR
				MOV 44H,A
				MOV A,#8
				MOV B,50H
				MUL AB
				ADD A, R0
				MOV DPTR,#TABLE2
                MOVC A,@A+DPTR
				MOV B,#32
				DIV AB
				ORL 44H,A
				
				MOV A, R0
				MOV R2 ,A
				INC R2
				CALL MULITWrite
				INC R0
				CJNE R0,#8,MID
				RET
MID:            LJMP SHOWTIME1
				
TIME1:			CALL Ds1302ReadTime
				MOV R2,#1
				
TM1:		    MOV A,48H                ;DATAPROS ADN SHOWTIME 
				SWAP A
				ANL A,#0FH
				MOV B,#8                 
				MUL AB
				MOV R5,A
				MOV A,R2
				ADD A,R5
				DEC A
				MOV DPTR,#TABLE1			
				MOVC A, @A+DPTR
				MOV 30H,A
				
				MOV A,48H
				ANL A,#0FH
				MOV B,#8
				MUL AB
				MOV R5,A
				MOV A,R2
				ADD A,R5
				DEC A
				MOV DPTR,#TABLE1		
				MOVC A, @A+DPTR
				MOV 31H,A
				RL A
				RL A
				RL A
				ANL A,#0FH
				ORL A,30H
				MOV 41H,A
				
				MOV A,31H
				RL A
				RL A
				RL A
				ANL A,#0F0H           
				MOV 31H,A
				
				MOV A,47H              ;MININTE
				SWAP A
				ANL A,#0FH
				MOV B,#8
				MUL AB
				MOV R5,A
				MOV A,R2
				ADD A,R5
				DEC A
				MOV DPTR,#TABLE1			
				MOVC A, @A+DPTR
				MOV 32H,A				
				RL A
				RL A
				ANL A,#0FH
				ORL A,31H
				CJNE R2,#2,POINT1
				ORL A,#10H
				JMP TM3
POINT1:			CJNE R2,#3,POINT2
				ORL A,#10H
				JMP TM3
POINT2:			CJNE R2,#5,POINT3
				ORL A,#10H
				JMP TM3
POINT3:			CJNE R2,#6,TM3
				ORL A,#10H
				JMP TM3
TM3:			MOV 42H,A
				JMP TM5
TM4:          JMP TM1                     

TM5:			MOV A,32H                     ;MAX3
				RL A
				RL A
				ANL A,#0F0H
				MOV 32H,A
				MOV A,47H
				ANL A,#0FH
				MOV B,#8
				MUL AB
				MOV R5,A
				MOV A,R2
				ADD A,R5
				DEC A
				MOV DPTR,#TABLE1			
				MOVC A, @A+DPTR
				MOV 33H,A
				RR A
				RR A
				RR A
				ANL A,#1EH
				ORL A,32H
				MOV 43H,A
				
				MOV A,46H
				SWAP A
				ANL A,#0FH
				MOV B,#8
				MUL AB
				MOV R5,A
				MOV A,R2
				ADD A,R5
				DEC A
				MOV DPTR,#TABLE2			
				MOVC A, @A+DPTR
				RR A
				MOV 33H,A
				
				MOV A,46H
				ANL A,#0FH
				MOV B,#8
				MUL AB
				MOV R5,A
				MOV A,R2
				ADD A,R5
				DEC A
				MOV DPTR,#TABLE2			
				MOVC A, @A+DPTR
				RL A
				RL A
				RL A
				ORL A,33H
				MOV 44H,A
				
				CALL MULITWrite
				INC R2
				CJNE R2,#9,TM4
				RET				
				
INTER0:                              
                CALL DATAPROS
                CALL SHOWTIME
                CALL DELAY2
				RETI

INTT0:			MOV TH0 ,#3CH     ;定时50ms
				MOV TL0 ,#0B0H	
				MOV A,5BH
				XRL A,#100
				JZ  BEEP_RUN
				MOV A,50H
				INC A
				MOV 50H,A
				SETB TR0
				AJMP LOOP
				RETI

BEEP_RUN:       SETB BEEP
                CALL DELAY
				CLR BEEP
				MOV 5BH,#0
				JMP LOOP
				RET
				
DELAY:          MOV R6 ,#200
D1: 	        MOV R7,#19H
				DJNZ R7 ,$
				DJNZ R6 ,D1
				RET	
				
DELAY2:         
                MOV R5,#50
D21:			MOV R6 ,#200
D22: 	        MOV R7,#200
				DJNZ R7 ,$
				DJNZ R6 ,D22
				DJNZ R5,D21
				RET	


				

READ_ADDR:  DB 81H, 83H, 85H, 87H, 89H, 8bH, 8dH
WRITE_ADDR: DB 80H, 82H, 84H, 86H, 88H, 8AH, 8CH
TIME:       DB 00H, 48H, 23H, 21H, 05H, 06H, 22H;2022年5月21日星期六23点48分00秒

TABLE1:		DB 0xF0,0x90,0x90,0x90,0x90,0x90,0xF0,0x00;"0"
            DB 0x40,0x40,0x40,0x40,0x40,0x40,0x40,0x00;"1"
			DB 0xF0,0x10,0x10,0xF0,0x80,0x80,0xF0,0x00;"2"
            DB 0xF0,0x10,0x10,0xF0,0x10,0x10,0xF0,0x00;"3"
			DB 0x90,0x90,0x90,0xF0,0x10,0x10,0x10,0x00;"4"
			DB 0xF0,0x80,0x80,0xF0,0x10,0x10,0xF0,0x00;"5"
			DB 0xF0,0x80,0x80,0xF0,0x90,0x90,0xF0,0x00;"6"
			DB 0xF0,0x10,0x10,0x10,0x10,0x10,0x10,0x00;"7"
			DB 0xF0,0x90,0x90,0xF0,0x90,0x90,0xF0,0x00;"8"
			DB 0xF0,0x90,0x90,0xF0,0x10,0x10,0xF0,0x00;"9"
				
TABLE2:		DB 0x00,0x00,0xE0,0xA0,0xA0,0xA0,0xE0,0x00;"0"
            DB 0x00,0x00,0x40,0x40,0x40,0x40,0x40,0x00;"1"
			DB 0x00,0x00,0xE0,0x20,0xE0,0x80,0xE0,0x00;"2"
            DB 0x00,0x00,0xE0,0x20,0xE0,0x20,0xE0,0x00;"3"
			DB 0x00,0x00,0xA0,0xA0,0xE0,0x20,0x20,0x00;"4"
			DB 0x00,0x00,0xE0,0x80,0xE0,0x20,0xE0,0x00;"5"
			DB 0x00,0x00,0xE0,0x80,0xE0,0xA0,0xE0,0x00;"6"
			DB 0x00,0x00,0xE0,0x20,0x20,0x20,0x20,0x00;"7"
			DB 0x00,0x00,0xE0,0xA0,0xE0,0xA0,0xE0,0x00;"8"
			DB 0x00,0x00,0xE0,0xA0,0xE0,0x20,0xE0,0x00;"9"
END
	
