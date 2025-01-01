#include <cstdint>

#include "../include/declarations.h"

void scan_cpp(float *input, float *output, uint32_t n) {
    float acc = 0;
    for (uint32_t i = 0; i < n; i++) {
        acc += input[i];
        output[i] = acc;
    }
}
