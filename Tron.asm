INCLUDE Irvine32.inc

.data
playerX     BYTE    10
playerY     BYTE    10
deltaX      BYTE    1
deltaY      BYTE    0
score       WORD    0
level       BYTE    0
floor       BYTE    80 dup(1), 23 dup(1, 78 dup(0), 1), 80 dup(1)       ; 0 - Empty Space
                                                                        ; 1 - Obstacle / Occupied
gameOverS   BYTE "Game Over!", 0
scoreS      BYTE "Score: ", 0


.code

main PROC

    call        ClrScr

    mov     eax,    cyan + (gray * 16)
    call    SetTextColor

    mov         ecx,   23
    mov         playerX,     0
    mov         playerY,     0

    topY:
        movzx       eax,    playerX
        push        eax
        movzx       eax,    playerY
        push        eax
        call        GetLocationAt

        cmp         eax, 1
        jne         cleared
        mov         dl, playerX
        mov         dh, playerY
        call        Gotoxy
        mov         al, 219
        call        WriteChar
        jmp         overStuff
    cleared:
        mov         eax, yellow + (gray * 16)
        call        SetTextColor
        mov         dl, playerX
        mov         dh, playerY
        call        Gotoxy
        mov         al, 219
        call        WriteChar
        mov         eax, cyan + (gray * 16)
        call        SetTextColor
    overStuff:
        inc         playerX

        cmp         playerX, 80
        jb          allGood
        mov         playerX, 0
        inc         playerY
    allGood:
        cmp         playerY, 25
        jb          topY
        
    mov         playerX, 10
    mov         playerY, 10

    call        GameLoop

    exit    

main ENDP

                    ; Push x, then push y, then call
                    ; Using STDCALL notation
GetLocationAt PROC

    push        ebp
    mov         ebp,    esp

    push        ebx
    push        ecx

    mov         ecx,    [ebp + 8]
    mov         ebx,    ecx
    shl         ecx,    6
    shl         ebx,    4
    add         ecx,    ebx
    add         ecx,    [ebp + 12]

    mov         ebx,    offset floor
    movzx       eax,    BYTE PTR [ebx + ecx]

    pop         ebx
    pop         ecx

    pop         ebp

    ret         8

GetLocationAt ENDP

; Push xpos
; Push ypos
; Push value to set
SetLocationAt PROC
    push        ebp
    mov         ebp,    esp

    push        eax
    push        ebx
    push        ecx

    xpos        equ     [ebp + 16]
    ypos        equ     [ebp + 12]
    toPlace     equ     [ebp + 8]

    mov         eax,    ypos
    mov         ebx,    ypos
    shl         eax,    6
    shl         ebx,    4
    add         eax,    ebx
    add         eax,    xpos
    mov         ecx,    toPlace

    mov         ebx,    offset  floor
    mov         BYTE PTR [ebx][eax], cl

    pop         ecx
    pop         ebx
    pop         eax
    pop         ebp

    ret         12

SetLocationAt ENDP

GameLoop PROC
L1:
    call    Input
    call    UpdatePlayer

    mov     eax, 100
    call    Delay

    jmp     L1

    ret
GameLoop ENDP

UpdatePlayer PROC
    pushad

    mov     dl,     playerX
    mov     dh,     playerY
    call    Gotoxy

    mov     eax,    cyan + (gray * 16)
    call    SetTextColor

    xor     eax,    eax
    mov     al,     219
    call    WriteChar

    movzx   eax,    playerX
    push    eax
    movzx   eax,    playerY
    push    eax
    mov     eax, 1
    push    eax
    call    SetLocationAt

    mov     al,     playerX
    add     al,     deltaX
    mov     playerX,    al
    
    mov     al,     playerY
    add     al,     deltaY
    mov     playerY,    al

    mov     dl,     playerX
    mov     dh,     playerY
    call    Gotoxy

    movzx   eax,    playerX
    push    eax
    movzx   eax,    playerY
    push    eax
    call    GetLocationAt

    cmp     eax, 1
    jne     safe

    cmp     score, 500
    jb      gameOverBit
    exit
    ;call    NewLevel
    ret
gameOverBit:
    call    GameOver
    exit
safe:
    inc     score
    
    mov     eax,    red + (gray * 16)
    call    SetTextColor

    mov     al,     219
    call    WriteChar
    
    popad

    ret
UpdatePlayer ENDP

NewLevel PROC
    pushad

    

    popad
    ret
NewLevel ENDP

GameOver PROC

    call    ClrScr
    mov     dl, 10
    mov     dh, 10
    call    Gotoxy

    mov     edx, offset gameOverS
    call    WriteString
    
    mov     dl, 10
    mov     dl, 11
    call    Gotoxy
    
    mov     edx, offset scoreS
    call    WriteString
    
    movzx   eax, score
    call    WriteDec
    
    call    Crlf
    call    Crlf
    
    call    WaitMsg

    exit
GameOver ENDP

Input PROC
    pushad

    call    ReadKey
    cmp     dx,     'W'
    jne     notW
    mov     deltaY, -1
    mov     deltaX, 0
    jmp     doneInput
notW:
    cmp     dx,     'S'
    jne     notS
    mov     deltaY, 1
    mov     deltaX, 0
    jmp     doneInput
notS:
    cmp     dx,     'A'
    jne     notA
    mov     deltaX, -1
    mov     deltaY, 0
    jmp     doneInput
notA:
    cmp     dx,     'D'
    jne     notD
    mov     deltaX, 1
    mov     deltaY, 0
    jmp     doneInput
notD:
    ; Todo(Joshua): Pause Feature

doneInput:
    popad

    ret
Input ENDP


END main