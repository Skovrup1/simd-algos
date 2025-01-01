#pragma once

#include <cstdint>
#include <cstdio>
#include <cstdlib>

#include <limits>
#include <vector>

inline std::vector<float> random_array(uint32_t n) {
    std::vector<float> vec(n, 0);

    float min = 0;
    float max = 1;
    for (uint32_t i = 0; i < n; i++) {
        float random = (float)rand() / RAND_MAX;
        random = min + random * (max - min);

        vec[i] = random;
    }

    return vec;
}

extern "C" {
void scan_cpp(float *input, float *output, uint32_t n);

void scan_ispc(float *input, float *output, uint32_t n);

void scan_asm(float *input, float *output, uint32_t n);
}

#include "../build/scan_ispc.h"
