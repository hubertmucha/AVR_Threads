; cw_1.asm
; Author : Mucha Hubert 
        .CSEG
        .ORG 0 RJMP _main 
        .ORG OC1Aaddr RJMP _timer_isr 
       
_timer_isr: 
        NOP
        RETI                          

_main:
        LDI R16,0x9 
        OUT TCCR1B,R16 ; 0b1001 clkI/O/1 (No prescaling)
        LDI R16,high(99)
        OUT OCR1AH,R16 ; Output Compare Register 1 A
        LDI R16,LOW(99)
        OUT OCR1AL,R16
        LDI R16,64
        OUT TIMSK,R16
        CLR R16
        OUT TCNT1L,R16 ; Timer/Counter1 – Counter Register Low Byte
        OUT TCNT1H,R16 ; Timer/Counter1 – Counter Register High Byte
        SEI
ThreadA:   
    NOP
    NOP
    NOP
    NOP
    NOP
    RJMP ThreadA
    RETI