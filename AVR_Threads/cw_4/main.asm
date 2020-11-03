; cw_4.asm
; Author : Mucha Hubert 

    .CSEG
    .ORG 0 rjmp _main 
    .ORG OC1Aaddr rjmp _timer_isr   

.def CurrentThread=R19

.def ThreadA_LSB=R20
.def ThreadA_MSB=R21

.def ThreadB_LSB=R22
.def ThreadB_MSB=R23


.def CtrA=R24
.def CtrB=R25

.def ThreadReturnL=R26
.def ThreadReturnH=R27

_timer_isr:
    clr R26
    cp CurrentThread,R26
    breq _irsThreadA
    rjmp _irsThreadB
    _irsThreadA:
        pop ThreadA_LSB
        pop ThreadA_MSB
        inc CurrentThread
        andi CurrentThread,1 
        push ThreadB_LSB
        push ThreadB_MSB
        reti 
    _irsThreadB: 
        pop ThreadB_LSB
        pop ThreadB_MSB
        dec CurrentThread
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
    ldi ThreadB_LSB,LOW(ThreadB)
    ldi ThreadB_MSB,HIGH(ThreadB)



ThreadA:   ; 0
    inc CtrA
    inc CtrA
    inc CtrA
    inc CtrA
    inc CtrA
    rjmp ThreadA
    reti

ThreadB:   ; 1
    inc CtrB
    inc CtrB
    inc CtrB
    inc CtrB
    inc CtrB
    rjmp ThreadB
    reti