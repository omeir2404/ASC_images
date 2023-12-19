extern printStrLn
extern readImageFile
section .data
    buffer times 1024 db 0 
    asciiBuffer times 1024 db 0


section .text
    global filterAscii
    global _start


filterAscii:
    ; Process each character
    .loop:
        ; Load character into AL
        movzx eax, byte [rdi] ; Load one character into eax

        ; Check if character is in printable ASCII range
        cmp al, 32
        jl .next
        cmp al, 126
        jg .next

        ; Store character in asciiBuffer
        mov [rdx], al
        inc rdx

        ; Next character
        .next:
        inc rdi
        dec rsi
        jnz .loop

    ; Null-terminate asciiBuffer
    mov byte [rdx], 0
    ret

_start:
    ; Get the first command line argument (argv[1])
    pop rax ; argc
    pop rdi ; argv[0]
    pop rdi ; argv[1] - this is the filename

    ; Read the file into the buffer
    mov rsi, buffer
    call readImageFile

    ; RDI = pointer to buffer
    ; RSI = length of buffer
    ; RDX = pointer to asciiBuffer
    mov rdi, buffer
    mov rsi, 1024 
    mov rdx, asciiBuffer
    call filterAscii

    mov rdi, asciiBuffer
    call printStrLn




end:
    mov rax, 60
    mov rdi, 0
    syscall