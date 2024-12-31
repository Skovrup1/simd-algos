section .note.GNU-stack noalloc noexec nowrite progbits

section .data

section .text
    global scan_asm

scan_asm:
    mov rcx, rdx        ; rcx = count
    mov rax, [rsi]      ; rax = output[0] = input[0]
    add rsi, 4          ; Move to next element
    add rdi, 4          ; Move to next element
    dec rcx             ; Decrement count
.loop:
    add rax, [rdi]      ; Add input[i] to rax
    mov [rsi], rax      ; Store result in output[i]
    add rsi, 4          ; Move to next element
    add rdi, 4          ; Move to next element
    loop .loop          ; Loop until rcx == 0
    ret
