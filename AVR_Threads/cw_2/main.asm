; cw_2.asm
; Author : Mucha Hubert 

    .CSEG
    .ORG 0 rjmp _main 
    .ORG OC1Aaddr rjmp _timer_isr   

.def CurrentThread=R19

_timer_isr:
        inc CurrentThread 
        nop
        reti                          

    _main:
        clr CurrentThread
        ldi R16,0x9 
        out TCCR1B,R16 ; 0b1001 clkI/O/1 (No prescaling)
        ldi R16,high(99)
        out OCR1AH,R16 ; Output Compare Register 1 A
        ldi R16,LOW(99)
        out OCR1AL,R16
        ldi R16,64
        out TIMSK,R16
        clr R16
        out TCNT1L,R16 ; Timer/Counter1 – Counter Register Low Byte
        out TCNT1H,R16 ; Timer/Counter1 – Counter Register High Byte
        sei
ThreadA:   
        nop
        nop
        nop
        nop
        nop
        rjmp ThreadA
        reti