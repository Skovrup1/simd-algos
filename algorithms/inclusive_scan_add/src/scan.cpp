#include "../include/common.h"

void scan_cpp(float *input, float *output, int count) {
    float acc = 0;
    for (int i = 0; i < count; i++) {
        acc += input[i];
        output[i] = acc;
    }
}
