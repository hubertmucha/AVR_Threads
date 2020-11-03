; cw_3.asm
; Author : Mucha Hubert 

    .CSEG
    .ORG 0 rjmp _main 
    .ORG OC1Aaddr rjmp _timer_isr   

.def CurrentThread=R19

.def ThreadA_LSB=R20
.def ThreadA_MSB=R21


_timer_isr:
        inc CurrentThread
        andi CurrentThread,1 

        push ThreadA_LSB
        push ThreadA_MSB
        reti                          

    _main:
        ldi R16,9
        out TCCR1B,R16
        ldi R16,high(99)
        out OCR1AH,R16
        ldi R16,LOW(99)
        out OCR1AL,R16
        ldi R16,64
        out TIMSK,R16
        clr R16
        out TCNT1L,R16
        out TCNT1H,R16
        sei
        clr CurrentThread
        ldi ThreadA_LSB,LOW(ThreadA)
        ldi ThreadA_MSB,HIGH(ThreadA)

ThreadA:   
        nop
        nop
        nop
        nop
        nop
        rjmp ThreadA
        reti