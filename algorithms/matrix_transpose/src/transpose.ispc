int8 unpack_low_mask() {
    bool even = programIndex % 2 == 0;
    int group = programIndex / 2;

    return even ? group : group + programCount;
}

int8 unpack_high_mask() {
    return unpack_low_mask() + programCount / 2;
}

// added _ since there is some weird name confict
float _unpack_low(float &a, float &b) {
    int8 mask = unpack_low_mask();

    return shuffle(a, b, mask);
}

// added _ since there is some weird name confict
float _unpack_high(float &a, float &b) {
    int8 mask = unpack_high_mask();

    return shuffle(a, b, mask);
}

// registers X programCount
void transpose_8x8(uniform float data[], uniform uint32 n) {
    // tell the compiler that the data is aligned to target width
    assume(((uniform uint64)((void*)data) & (32 * TARGET_WIDTH)-1) == 0);

    unmasked {
        int32 const i = programIndex;
        uniform int32 const pc = programCount;

        // note: play around with streaming loads/stores
        float row0 = data[i];
        float row1 = data[i + pc];
        float row2 = data[i + pc * 2];
        float row3 = data[i + pc * 3];
        float row4 = data[i + pc * 4];
        float row5 = data[i + pc * 5];
        float row6 = data[i + pc * 6];
        float row7 = data[i + pc * 7];

        // k = 1
        float temp0 = _unpack_low(row0, row4);
        float temp1 = _unpack_low(row1, row5);
        float temp2 = _unpack_low(row2, row6);
        float temp3 = _unpack_low(row3, row7);
        float temp4 = _unpack_high(row0, row4);
        float temp5 = _unpack_high(row1, row5);
        float temp6 = _unpack_high(row2, row6);
        float temp7 = _unpack_high(row3, row7);

        // k = 2
        row0 = _unpack_low(temp0, temp2);
        row1 = _unpack_low(temp1, temp3);
        row2 = _unpack_low(temp4, temp6);
        row3 = _unpack_low(temp5, temp7);
        row4 = _unpack_high(temp0, temp2);
        row5 = _unpack_high(temp1, temp3);
        row6 = _unpack_high(temp4, temp6);
        row7 = _unpack_high(temp5, temp7);

        // k = 3
        temp0 = _unpack_low(row0, row1);
        temp4 = _unpack_low(row2, row3);
        temp2 = _unpack_low(row4, row5);
        temp6 = _unpack_low(row6, row7);
        temp1 = _unpack_high(row0, row1);
        temp5 = _unpack_high(row2, row3);
        temp3 = _unpack_high(row4, row5);
        temp7 = _unpack_high(row6, row7);

        data[i]          = temp0;
        data[i + pc]     = temp1;
        data[i + pc * 2] = temp2;
        data[i + pc * 3] = temp3;
        data[i + pc * 4] = temp4;
        data[i + pc * 5] = temp5;
        data[i + pc * 6] = temp6;
        data[i + pc * 7] = temp7;
    }
}

// registers X programCount
void transpose_4x4(uniform float data[], uniform uint32 n) {
    // tell the compiler that the data is aligned to target width
    // note: verify if this is correct later
    assume(((uniform uint64)((void*)data) & (32 * TARGET_WIDTH)-1) == 0);

    unmasked {
        int32 const i = programIndex;
        uniform int32 const pc = programCount;

        // note: play around with streaming loads/stores
        float row0 = data[i];
        float row1 = data[i + pc];
        float row2 = data[i + pc * 2];
        float row3 = data[i + pc * 3];

        // k = 1
        float temp0 = _unpack_low(row0, row2);
        float temp1 = _unpack_low(row1, row3);
        float temp2 = _unpack_high(row0, row2);
        float temp3 = _unpack_high(row1, row3);

        // k = 2
        row0 = _unpack_low(temp0, temp1);
        row2 = _unpack_low(temp2, temp3);
        row1 = _unpack_high(temp0, temp1);
        row3 = _unpack_high(temp2, temp3);

        data[i]          = row0;
        data[i + pc]     = row1;
        data[i + pc * 2] = row2;
        data[i + pc * 3] = row3;
    }
}

void transpose_generic() {
}

export void transpose_ispc(uniform float data[], uniform uint32 n) {
    #if TARGET_WIDTH == 4
        transpose_4x4(data, n);
    #elif TARGET_WIDTH == 8
        transpose_8x8(data, n);
    #endif
}

