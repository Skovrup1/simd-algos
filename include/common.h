#pragma once

#include <cstdint>
#include <cstdlib>
#include <numeric>
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

inline std::vector<float> iota_array(uint32_t n) {
    std::vector<float> vec(n, 0);
    std::iota(vec.begin(), vec.end(), 0);

    return vec;
}
