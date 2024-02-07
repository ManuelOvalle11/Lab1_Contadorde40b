//*****************************************************************************
// Universidad del Valle de Guatemala
// IE2023: Programación de microcontroladores
// Autor: Manuel Ovalle 
// Proyecto: Contador de 4 bits 
// Hardware: ATMEGA328P
// Creado: 30/01/2024
//*****************************************************************************
// Encabezado
//*****************************************************************************

.include "M328PDEF.inc"
.cseg //Indica inicio del código
.org 0x00 //Indica el RESET

//*****************************************************************************
// Formato Base
//*****************************************************************************
LDI R16, LOW(RAMEND) 
OUT SPL, R16
LDI R17, HIGH(RAMEND)
OUT SPH, R17
//*****************************************************************************
// MCU
//*****************************************************************************

Setup:
	LDI R16, (1 << CLKPCE)
	STS CLKPR, R16

	LDI R16, 0b0000_0011
	STS CLKPR, R16

	LDI R16, 0b0001_1111
	OUT PORTC, R16
	LDI R16, 0b0010_0000
	OUT DDRC, R16

	LDI R16, 0b1111_1111 
	OUT DDRD, R16

	LDI R16, 0b0011_1111 
	OUT DDRB, R16

	CLR R17
	CLR R20

	LDI R23, 0b0000_1111

	CLR R18
	CLR R24
	CLR R25


//*****************************************************************************
Loop:

	IN R16, PINC

	SBRS R16, PC0 //Botón 1
	RJMP DelayBounce

	OUT PORTD, R19 // Output contador1 incremento

	SBRS R16, PC1 // Botón 2
	RJMP DelayBounce2

	OUT PORTD, R19 // Output contador1 decremento

	SBRS R16, PC2 // Botón 3
	RJMP DelayBounce3

	OUT PORTB, R20 // Output contador2 incremento

	SBRS R16, PC3 // Botón 4
	RJMP DelayBounce4

	OUT PORTB, R20 // Output contador2 decremento

	SBRS R16, PC4 // Botón 5
	RJMP DelayBounce5

	//Seteo de pines para el resultado de la suma
	SBRC R18, 0
	SBI PORTB, PB4
	SBRS R18, 0
	CBI PORTB, PB4

	SBRC R18, 1
	SBI PORTC, PC5
	SBRS R18, 1
	CBI PORTC, PC5

	SBRC R18, 2
	SBI PORTD, PD6
	SBRS R18, 2
	CBI PORTD, PD6

	SBRC R18, 3
	SBI PORTD, PD7
	SBRS R18, 3
	CBI PORTD, PD7


	//CARRY
	SBRC R18, 4  
	SBI PORTB, PB5
	SBRS R18, 4
	CBI PORTB, PB5

	RJMP Loop

//*****************************************************************************
// SubRutinas
//*****************************************************************************

DelayBounce: //SubR para incrementar contador 1
	LDI R16, 100
	delay:
		DEC R16
		BRNE delay

	SBIS PINC, PC0
	RJMP DelayBounce
	INC R17 // R17 Contador incrementar 
	AND R17, r23
	
	MOV R19,R17 // Evito usar Rx y Tx en el PORTD
	LSL R19
	LSL R19

	RJMP Loop
//*****************************************************************************
	DelayBounce2: //SubR para decrementar contador 1
	LDI R16, 100
	delay2:
		DEC R16
		BRNE delay2

	SBIS PINC, PC1
	RJMP DelayBounce2
	DEC R17 // R17 contador decrementar 
	AND R17, r23
	
	MOV R19,R17 // Evito usar Rx y Tx en el PORTD
	LSL R19
	LSL R19

	RJMP Loop
//*****************************************************************************
	DelayBounce3: //SubR para incrementar contador 2
	LDI R16, 100
	delay3:
		DEC R16
		BRNE delay3

	SBIS PINC, PC2
	RJMP DelayBounce3
	INC R20 // R20 Contador2 incrementar 
	AND R20, R23

	RJMP Loop
//*****************************************************************************
	DelayBounce4: //SubR para decrementar contador 2
	LDI R16, 100
	delay4:
		DEC R16
		BRNE delay4

	SBIS PINC, PC3
	RJMP DelayBounce4
	DEC R20 // R20 contador2 decrementar 
	AND R20, R23

	RJMP Loop
//*****************************************************************************

	DelayBounce5: //Suma
	LDI R16, 100
	Sumador:
		DEC R16
		BRNE Sumador

	SBIS PINC, PC4
	RJMP DelayBounce5

	//Logica para sumar 
	MOV R24, R17
	MOV R25, R20
	ADD R24, R25	
	MOV R18, R24



	RJMP Loop	

	
