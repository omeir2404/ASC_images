extern printStrLn
extern printStr
extern readImageFile
section .data
    buffer times 1024 db 0 
    errArgc db "Error: argc != 3", 10, 0
    errMode db "Mode must be R or S", 20, 0
    infoBuffer times 1024 db 0
    letter db 0

section .bss
    size resq 1
    offset resq 1
    pixelSize resq 1

section .text
    global _start
    global check_mode
    global modeerror
    global argcerror
    global end
    global simples
    global repeat

check_mode:
    ; Check if mode is "R" or "S"
    cmp byte [rbx], 'S'
    je .simple
    cmp byte [rbx], 'R'
    je .repeat
    jmp .error

    .simple:
    mov rbx, 0
    ret

    .repeat:
    mov rbx, 1
    ret
    .error:
    call modeerror

_start:
    ; Get the first command line argument (argv[1])
    pop rax ; argc
    pop rdi ; argv[0]
    pop rbx ; argv[1] - this is the argument "R" or "S"
    pop rdi ; argv[2] - this is the filename
    ;checks argc number
    cmp rax, 3
    jne argcerror
    ; Check if mode is "R" or "S"
    call check_mode
    cmp rbx, 0
    je simples
    jmp repeat

simples:
    mov rsi, buffer
    call readImageFile
    mov [size], rax
    mov eax, [buffer + 10]
    mov [offset], rax
    mov rax, [size]
    sub rax, [offset]
    mov [pixelSize], rax

    mov r13, 0 ; Initialize counter to test multiple of 4
    mov r12, [offset] ; Initialize counter with offset
    mov r8, [size] ; Store size in r8 for comparison

    xor rcx, rcx ; Clear rcx
    xor rax, rax ; Clear rax
    loop:
        cmp r12, r8; Compare counter with the image size
        jge end ; If counter >= size, jump to end

        movzx rsi, byte [buffer + r12] ; Store current byte in rsi
        and rsi, 1 ; test the last bit of the byte

        shl rax, 1 ; Shift the bit to the left by rcx
        and rax, 0xFFFFFFFFFFFFFFFE ; Clear the last bit of rax
        or rax, rsi ; Set the last bit of rax to the value of rsi
        inc rcx ; Increment rcx
        cmp rcx, 8 ; Compare rcx with 8
        jge print_letter ; If rcx >= 8, jump to print_letter

        inc r12 ; Increment counter
        inc r13
        test r13, 3 ; Check if counter is multiple of 4
        jz increment_r13 ; If it is, increment r13 and jump to loop
        jmp loop
    
    increment_r13:
        inc r13
        ; dec rcx
        jmp loop

    print_letter:
        mov rdi, rax
        call printStr
        xor rax, rax
        xor rcx, rcx
        jmp loop

repeat:
    mov rsi, buffer
    call readImageFile
    mov [size], rax
    mov rax, [buffer + 10]
    mov [offset], rax


    
    jmp end


argcerror:
    mov rdi, errArgc
    call printStrLn
    jmp end

modeerror:
    mov rdi, errMode
    call printStrLn
    jmp end

end:
    mov rax, 60
    mov rdi, 0
    syscall