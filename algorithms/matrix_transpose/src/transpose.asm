%define ARCH_X86_64 1
%define HAVE_ALIGNED_STACK 1
%define private_prefix transpose

%include "x86inc.asm"

SECTION .text

cglobal asm, 3, 4, 4, src, dst, n
INIT_YMM avx2
    vxorps ymm0, ymm0                   ; acc[A..G] = 0
    xor r3q, r3q                        ; i = 0
    shl nq, 2                           ; n * 4

.loop:
    vmovaps ymm1, [srcq + r3q] ; ymm1 = *(src + i)

    vpermilps ymm2, ymm1, 0x93        ; rearrange ymm1[D,A,B,C,H,E,F,G]
    vperm2f128 ymm3, ymm2, ymm2, 0x09 ; rearrange ymm2[0,0,0,0,A,B,C,D]
    vblendps ymm2, ymm2, ymm3, 0x11   ;
    vaddps ymm1, ymm1, ymm2           ; value + value_shift

    vpermilps ymm2, ymm1, 0x4E        ;
    vperm2f128 ymm3, ymm2, ymm2, 0x29 ;
    vblendps ymm2, ymm2, ymm3, 0x33   ;
    vaddps ymm1, ymm1, ymm2           ; value + value_shift

    vperm2f128 ymm2, ymm1, ymm1, 0x29 ;
    vaddps ymm1, ymm1, ymm2           ; value + value_shift

    vaddps ymm1, ymm0, ymm1 ; acc + value

    vmovaps [dstq + r3q], ymm1 ; *(dst + i) = ymm1

    vextractf128 xmm0, ymm1, 1 ; extract ymm1[E..G]
    vpermilps xmm0, xmm0, 0xFF ; replicate xmm0[D]
    vbroadcastss ymm0, xmm0    ; broadcast xmm0

    add r3q, 32 ; i += 32
    cmp r3q, nq ; i < n then
    jl .loop    ; repeat loop

    ret
