extern printStrLn
extern readTextFile
section .data
    hi: db "Hello World!", 0
    fileName: db "test.txt", 0 
    buffer times 1024 db 0 ; Allocate 1KB buffer


section .text
    global _start

_start:
mov RDI, hi
call printStrLn

mov RDI, fileName
mov RSI, buffer
call readTextFile

mov RDI, buffer
call printStrLn



; Additional sections can be added as needed
end: