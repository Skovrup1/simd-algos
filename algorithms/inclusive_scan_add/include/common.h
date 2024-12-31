#pragma once

#include <cstdint>
#include <cstdlib>

#include <limits>
#include <vector>

inline std::vector<float> random_array(uint32_t n) {
    std::vector<float> vec(n, 0);

    float min = std::numeric_limits<float>::min();
    float max = std::numeric_limits<float>::max();

    for (uint32_t i = 0; i < n; i++) {
        float random = (float)rand() / RAND_MAX;
        random = min + random * (max - min);

        vec[i] = random;
    }

    return vec;
}

extern "C" {
void scan_cpp(float *input, float *output, int count);

void scan_ispc(float *input, float *output, int count);

void scan_asm(float *input, float *output, int count);
}

#include "../build/scan_ispc.h"
