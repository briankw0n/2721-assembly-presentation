
;------------------------------------------
; int slen(String message)
; String length calculation function
slen:
    push    ebx             ; push ebx onto stack to preserve value of ebx
    mov     ebx, eax        ; move value of eax into ebx
 
nextchar:
    cmp     byte [eax], 0   ; compare byte pointed to by eax with 0 (null terminator)
    jz      finished        ; jump to finished if null terminator is found
    inc     eax             ; increment eax
    jmp     nextchar        ; jump back up to nextchar to process next character
 
finished:
    sub     eax, ebx        ; subtract value of ebx from value of eax
    pop     ebx             ; pop from stack to restore value of ebx
    ret                     ; return length of string

;------------------------------------------
; void sprint(String message)
; String printing function
sprint:
    push    edx             ; push edx onto stack to preserve value of edx
    push    ecx             ; push ecx onto stack to preserve value of ecx
    push    ebx             ; push ebx onto stack to preserve value of ebx
    push    eax             ; push eax onto stack to preserve value of eax
    call    slen            ; call slen function
 
    mov     edx, eax        ; move value of eax into edx
    pop     eax             ; pop from stack to restore value of eax
 
    mov     ecx, eax        ; move value of eax into ecx
    mov     ebx, 1          ; set ebx to 1 to indicate write to standard output
    mov     eax, 4          ; set eax to 4 to indicate use of write system call
    int     80h             ; invoke write system call to print to standard output
 
    pop     ebx             ; pop from stack to restore value of ebx
    pop     ecx             ; pop from stack to restore value of ecx
    pop     edx             ; pop form stack to restore value of edx
    ret                     ; return from function
    
;------------------------------------------
; int atoi(char* str)
; Ascii to integer function (atoi)
atoi:
    push    ebx             ; push edx onto stack to preserve value of ebx
    push    ecx             ; push edx onto stack to preserve value of ecx
    push    edx             ; push edx onto stack to preserve value of edx
    push    esi             ; push edx onto stack to preserve value of esi
    mov     esi, eax        ; move value of eax into esi
    mov     eax, 0          ; initialize eax to 0
    mov     ecx, 0          ; initialize ecx to 0
 
multiplyLoop:
    xor     ebx, ebx        ; reset both lower and uppper bytes of ebx to 0
    mov     bl, [esi+ecx]   ; move single byte into lower half of ebx
    cmp     bl, 48          ; compare lower half of ebx with ASCII value 48 (char value 0)
    jl      .finished       ; jump to finished if bl less than 48
    cmp     bl, 57          ; compare lower half of ebx with ASCII value 57 (char value 9)
    jg      .finished       ; jump to finished if bl greater than 57
 
    sub     bl, 48          ; subtract 48 from value of bl to convert to decimal representation of ASCII value
    add     eax, ebx        ; add value of ebx to value of eax
    mov     ebx, 10         ; set ebx to 10
    mul     ebx             ; multiply value of eax by 10 to shift to the left by one digit
    inc     ecx             ; increment ecx
    jmp     multiplyLoop    ; jump to multiplyLoop
 
.finished:
    cmp     ecx, 0          ; compare value of ecx with 0
    je      restore         ; jump to restore if equal to 0
    mov     ebx, 10         ; set ebx to 10
    div     ebx             ; divide value of eax by 10 to shift to the right by one digit
 
restore:
    pop     esi             ; pop from stack to restore value of esi
    pop     edx             ; pop from stack to restore value of edx
    pop     ecx             ; pop from stack to restore value of ecx
    pop     ebx             ; pop from stack to restore value of ebx
    ret                     ; return from function

;------------------------------------------
; void iprint(Integer number)
; Integer printing function (itoa)
iprint:
    push    eax             ; push eax onto stack to preserve value of eax
    push    ecx             ; push ecx onto stack to preserve value of ecx
    push    edx             ; push edx onto stack to preserve value of edx
    push    esi             ; push esi onto stack to preserve value of esi
    mov     ecx, 0          ; initialize ecx to 0 to keep track of number of bytes to print
 
divideLoop:
    inc     ecx             ; increment ecx
    mov     edx, 0          ; initialize edx to 0
    mov     esi, 10         ; set esi to 10
    idiv    esi             ; divide value of eax by value of esi
    add     edx, 48         ; add 48 to value of edx to convert to ASCII representation (remainder)
    push    edx             ; push edx onto stack (string representation of integer)
    cmp     eax, 0          ; determining if integer can be divided further
    jnz     divideLoop      ; jump back up to divideLoop if not 0
 
printLoop:
    dec     ecx             ; decrement ecx
    mov     eax, esp        ; move value of esp into eax
    call    sprint          ; call sprint function
    pop     eax             ; pop last character from stack to move stack pointer forward
    cmp     ecx, 0          ; determining if everything has been printed from stack
    jnz     printLoop       ; jump back up to printLoop if not 0
 
    pop     esi             ; pop from stack to restore value of esi
    pop     edx             ; pop from stack to restore value of edx
    pop     ecx             ; pop from stack to restore value of ecx
    pop     eax             ; pop from stack to restore value of eax
    ret                     ; return from function
 
;------------------------------------------
; void iprintLF(Integer number)
; Integer printing function with linefeed (itoa)
iprintLF:
    call    iprint          ; call iprint function
 
    push    eax             ; push eax onto stack to preserve value of eax
    mov     eax, 0Ah        ; move 0Ah into eax (0Ah = ASCII character for newline character)
    push    eax             ; push newline character onto stack
    mov     eax, esp        ; move address of current stack pointer into eax
    call    sprint          ; call sprint function
    pop     eax             ; pop newline character from stack
    pop     eax             ; pop from stack to restore value of eax
    ret                     ; return from function
    
;------------------------------------------
; void exit()
; Exit program and restore resources
quit:
    mov     ebx, 0          ; initialize ebx to 0
    mov     eax, 1          ; initialize eax to 1
    int     80h             ; invoke system call
    ret                     ; return from function
    
