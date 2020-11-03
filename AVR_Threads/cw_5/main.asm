; Cw_5.asm
; Author : Hubert Mucha

.CSEG
.ORG 0 RJMP _main 
.ORG OC1Aaddr RJMP _timer_isr 
       
_timer_isr: 
    push R20
    in   R20,SREG
    inc CurrentThread
    andi CurrentThread,1
    cpi CurrentThread,1
    breq _Thread_B

_Thread_A:
    sts  0x60,R23
    sts  0x61,R24
    sts  0x62,R25
    lds  R23, 0x63
    lds  R24, 0x64
    lds  R25,0x65

    mov   ThreadB_SREG_COPY,R20
    pop R20
    out  SREG,ThreadA_SREG_COPY

    pop  ThreadB_MSB
    pop  ThreadB_LSB
    push ThreadA_LSB
    push ThreadA_MSB
reti

_Thread_B:
    sts  0x63,R23
    sts  0x64,R24
    sts  0x65,R25
    lds  R23, 0x60
    lds R24, 0x61
    lds  R25,0x62

    mov  ThreadA_SREG_COPY,R20
    pop  R20
    out  SREG,ThreadB_SREG_COPY

    pop  ThreadA_MSB
    pop  ThreadA_LSB
    push ThreadB_LSB
    push ThreadB_MSB
reti                         
               
.def ThreadA_LSB=R0
.def ThreadA_MSB=R1

.def ThreadB_LSB=R2
.def ThreadB_MSB=R3

.def ThreadA_SREG_COPY=R4
.def ThreadB_SREG_COPY=R5

.def CurrentThread=R21
                

_main:
    sei 
    ldi R16,9
    out TCCR1B,R16
    ldi R16,high(100)
    out OCR1AH,R16
    ldi R16,LOW(100)
    out OCR1AL,R16
    ldi R16,64
    out TIMSK,R16
    clr R16
    out TCNT1L,R16
    out TCNT1H,R16
    clr CurrentThread

    ldi R16,LOW(ThreadA)
    mov ThreadA_LSB,R16
    ldi R16,HIGH(ThreadA)
    mov ThreadA_LSB,R16
    ldi R16,LOW(ThreadB)
    mov ThreadB_LSB,R16
    ldi R16,HIGH(ThreadB)
    mov ThreadB_MSB,R16
               
    ldi R16,0x66                      
    ldi R17,24 
    out Digits_P,R17
    out DDRD,R16
    out DDRB,R17
    ldi R16,0x3F
    out Segments_P,R16
    clr R16
    clr R17
                
ThreadA:              
    in R24,Digits_P
    in R25,Digits_P
    andi R24,8
    ldi R23,16
    add R25,R23
    andi R25,16
    add R24,R25
    out Digits_P,R24
               
    ldi R23 ,20

    ThreadALoop: 
        ldi R24,52
        ldi R25,5
        ThreadADelayOneMsLoop:
            nop
            sbiw R24,1
            brbs 1,ThreadADelayOneMsEnd
            rjmp ThreadADelayOneMsLoop
            ThreadADelayOneMsEnd:
                dec R23
                cpse R23,R24
    rjmp ThreadALoop                   
rjmp ThreadA

ThreadB:                          
    in R24,Digits_P
    in R25,Digits_P
    andi R24,16
    ldi R23,8
    add R25,R23
    andi R25,8
    add R24,R25
    out Digits_P,R24

    ldi R23 ,255

    ThreadBLoop: 
        ldi R24,52
        ldi R25,5
        ThreadBDelayOneMsLoop:
            nop
            sbiw R24,1
            brbs 1,ThreadBDelayOneMsEnd
            rjmp ThreadBDelayOneMsLoop
            ThreadBDelayOneMsEnd:
                dec R23
                cpse R23,R24
        rjmp ThreadBLoop        
    rjmp ThreadB
reti