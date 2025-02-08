int8 unpack_low_mask() {
    bool even = programIndex % 2 == 0;
    int group = programIndex / 2;

    return even ? group : group + programCount;
}

int8 unpack_high_mask() {
    return unpack_low_mask() + programCount / 2;
}

// added _ since there is some weird name confict
float _unpack_low(float a, float b) {
    int8 mask = unpack_low_mask();

    return shuffle(a, b, mask);
}

// added _ since there is some weird name confict
float _unpack_high(float a, float b) {
    int8 mask = unpack_high_mask();

    return shuffle(a, b, mask);
}

// registers X programCount
void transpose_16x16(uniform float data[]) {
    // tell the compiler that the data is aligned to target width
    assume(((uniform uint64)((void*)data) & (32 * TARGET_WIDTH)-1) == 0);

    unmasked {
        int32 const i = programIndex;
        uniform int32 const pc = programCount;

        // note: play around with streaming loads/stores
        float p0 = data[i];
        float p1 = data[i + pc];
        float p2 = data[i + pc * 2];
        float p3 = data[i + pc * 3];
        float p4 = data[i + pc * 4];
        float p5 = data[i + pc * 5];
        float p6 = data[i + pc * 6];
        float p7 = data[i + pc * 7];
        float p8 = data[i + pc * 8];
        float p9 = data[i + pc * 9];
        float p10 = data[i + pc * 10];
        float p11 = data[i + pc * 11];
        float p12 = data[i + pc * 12];
        float p13 = data[i + pc * 13];
        float p14 = data[i + pc * 14];
        float p15 = data[i + pc * 15];

        // k = 1
        float a0  = _unpack_low(p0, p8);
        float a1  = _unpack_low(p1, p9);
        float a2  = _unpack_low(p2, p10);
        float a3  = _unpack_low(p3, p11);
        float a4  = _unpack_low(p4, p12);
        float a5  = _unpack_low(p5, p13);
        float a6  = _unpack_low(p6, p14);
        float a7  = _unpack_low(p7, p15);
        float a8  = _unpack_high(p0, p8);
        float a9  = _unpack_high(p1, p9);
        float a10 = _unpack_high(p2, p10);
        float a11 = _unpack_high(p3, p11);
        float a12 = _unpack_high(p4, p12);
        float a13 = _unpack_high(p5, p13);
        float a14 = _unpack_high(p6, p14);
        float a15 = _unpack_high(p7, p15);

        // k = 2
        float b0  = _unpack_low(a0, a8);
        float b1  = _unpack_low(a1, a9);
        float b2  = _unpack_low(a2, a10);
        float b3  = _unpack_low(a3, a11);
        float b4  = _unpack_low(a4, a12);
        float b5  = _unpack_low(a5, a13);
        float b6  = _unpack_low(a6, a14);
        float b7  = _unpack_low(a7, a15);
        float b8  = _unpack_high(a0, a8);
        float b9  = _unpack_high(a1, a9);
        float b10 = _unpack_high(a2, a10);
        float b11 = _unpack_high(a3, a11);
        float b12 = _unpack_high(a4, a12);
        float b13 = _unpack_high(a5, a13);
        float b14 = _unpack_high(a6, a14);
        float b15 = _unpack_high(a7, a15);

        // k = 3
        float c0  = _unpack_low(a0, a8);
        float c1  = _unpack_low(a1, a9);
        float c2  = _unpack_low(a2, a10);
        float c3  = _unpack_low(a3, a11);
        float c4  = _unpack_low(a4, a12);
        float c5  = _unpack_low(a5, a13);
        float c6  = _unpack_low(a6, a14);
        float c7  = _unpack_low(a7, a15);
        float c8  = _unpack_high(a0, a8);
        float c9  = _unpack_high(a1, a9);
        float c10 = _unpack_high(a2, a10);
        float c11 = _unpack_high(a3, a11);
        float c12 = _unpack_high(a4, a12);
        float c13 = _unpack_high(a5, a13);
        float c14 = _unpack_high(a6, a14);
        float c15 = _unpack_high(a7, a15);

        // k = 4
        float d0  = _unpack_low(c0, p8);
        float d1  = _unpack_high(c1, p9);
        float d2  = _unpack_low(c2, p10);
        float d3  = _unpack_high(c3, p11);
        float d4  = _unpack_low(c4, p12);
        float d5  = _unpack_high(c5, p13);
        float d6  = _unpack_low(c6, p14);
        float d7  = _unpack_high(c7, p15);
        float d8  = _unpack_low(c0, p8);
        float d9  = _unpack_high(c1, p9);
        float d10 = _unpack_low(c2, p10);
        float d11 = _unpack_high(c3, p11);
        float d12 = _unpack_low(c4, p12);
        float d13 = _unpack_high(c5, p13);
        float d14 = _unpack_low(c6, p14);
        float d15 = _unpack_high(c7, p15);

        data[i]           = d0;
        data[i + pc]      = d1;
        data[i + pc * 2]  = d2;
        data[i + pc * 3]  = d3;
        data[i + pc * 4]  = d4;
        data[i + pc * 5]  = d5;
        data[i + pc * 6]  = d6;
        data[i + pc * 7]  = d7;
        data[i + pc * 8]  = d0;
        data[i + pc * 9]  = d1;
        data[i + pc * 10] = d2;
        data[i + pc * 11] = d3;
        data[i + pc * 12] = d4;
        data[i + pc * 13] = d5;
        data[i + pc * 14] = d6;
        data[i + pc * 15] = d7;
    }
}

// registers X programCount
void transpose_8x8(uniform float data[]) {
    // tell the compiler that the data is aligned to target width
    assume(((uniform uint64)((void*)data) & (32 * TARGET_WIDTH)-1) == 0);

    unmasked {
        int32 const i = programIndex;
        uniform int32 const pc = programCount;

        // note: play around with streaming loads/stores
        float p0 = data[i];
        float p1 = data[i + pc];
        float p2 = data[i + pc * 2];
        float p3 = data[i + pc * 3];
        float p4 = data[i + pc * 4];
        float p5 = data[i + pc * 5];
        float p6 = data[i + pc * 6];
        float p7 = data[i + pc * 7];

        // k = 1
        float a0 = _unpack_low(p0, p4);
        float a1 = _unpack_low(p1, p5);
        float a2 = _unpack_low(p2, p6);
        float a3 = _unpack_low(p3, p7);
        float a4 = _unpack_high(p0, p4);
        float a5 = _unpack_high(p1, p5);
        float a6 = _unpack_high(p2, p6);
        float a7 = _unpack_high(p3, p7);

        // k = 2
        float b0 = _unpack_low(a0, a2);
        float b1 = _unpack_low(a1, a3);
        float b2 = _unpack_low(a4, a6);
        float b3 = _unpack_low(a5, a7);
        float b4 = _unpack_high(a0, a2);
        float b5 = _unpack_high(a1, a3);
        float b6 = _unpack_high(a4, a6);
        float b7 = _unpack_high(a5, a7);

        // k = 3
        float c0 = _unpack_low(b0, b1);
        float c1 = _unpack_high(b0, b1);
        float c2 = _unpack_low(b4, b5);
        float c3 = _unpack_high(b4, b5);
        float c4 = _unpack_low(b2, b3);
        float c5 = _unpack_high(b2, b3);
        float c6 = _unpack_low(b6, b7);
        float c7 = _unpack_high(b6, b7);

        data[i]          = c0;
        data[i + pc]     = c1;
        data[i + pc * 2] = c2;
        data[i + pc * 3] = c3;
        data[i + pc * 4] = c4;
        data[i + pc * 5] = c5;
        data[i + pc * 6] = c6;
        data[i + pc * 7] = c7;
    }
}

// registers X programCount
void transpose_4x4(uniform float data[]) {
    // tell the compiler that the data is aligned to target width
    assume(((uniform uint64)((void*)data) & (32 * TARGET_WIDTH)-1) == 0);

    unmasked {
        int32 const i = programIndex;
        uniform int32 const pc = programCount;

        // note: play around with streaming loads/stores
        float p0 = data[i];
        float p1 = data[i + pc];
        float p2 = data[i + pc * 2];
        float p3 = data[i + pc * 3];

        // k = 1
        float a0 = _unpack_low(p0, p2);
        float a1 = _unpack_low(p1, p3);
        float a2 = _unpack_high(p0, p2);
        float a3 = _unpack_high(p1, p3);

        // k = 2
        float b0 = _unpack_low(a0, a1);
        float b1 = _unpack_high(a0, a1);
        float b2 = _unpack_low(a2, a3);
        float b3 = _unpack_high(a2, a3);

        data[i]          = b0;
        data[i + pc]     = b1;
        data[i + pc * 2] = b2;
        data[i + pc * 3] = b3;
    }
}

export void transpose_ispc(uniform float data[], uniform uint32 n) {
    #if TARGET_WIDTH == 4
        transpose_4x4(data);
    #elif TARGET_WIDTH == 8
        transpose_8x8(data);
    #elif TARGET_WIDTH == 16
        transpose_16x16(data);
    #endif
}

