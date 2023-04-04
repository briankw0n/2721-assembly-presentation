
%include 'functions.asm'

section .data
    prompt1     db "Enter first positive integer: ", 0
    prompt2     db "Enter second postive integer : ", 0
    prompt3     db "The product is ", 0

section .bss
    input1      resd 1
    input2      resd 1

section .text
    global _start

_start:
    ; Prompt user to enter first integer
    mov     eax, prompt1
    call    sprint
    
    ; Read first input and convert from string to integer
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input1
    mov     edx, 16
    int     0x80
    mov     eax, input1
    call    atoi
    
    ; Push first integer onto stack
    push    eax
    
    ; Prompt user to enter second integer
    mov     eax, prompt2
    call    sprint
    
    ; Read second input and convert from string to integer
    mov     eax, 3
    mov     ebx, 0
    mov     ecx, input2
    mov     edx, 16
    int     0x80
    mov     eax, input2
    call    atoi
    
    ; Pop first integer from stack and store in ebx
    pop     ebx
    
    ; Multiply integers and print result
    imul    ebx, eax
    mov     eax, prompt3
    call    sprint
    mov     eax, ebx
    call    iprintLF
    
    ; Exit the program
    call    quit
     
