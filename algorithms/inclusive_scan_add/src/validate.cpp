#include <cmath>
#include <cstdint>
#include <cstdio>
#include <vector>

#include "../../../include/common.h"
#include "../include/declarations.h"

constexpr float EPS = 0.01;

bool compare_rel_diff(float a, float b) { return std::abs(a - b) / a < EPS; }

int main() {
    uint32_t n = 100000;
    std::vector<float> input = random_array(n);
    // std::vector<float> input = iota_array(n);
    std::vector<float> cpp_output = std::vector<float>(n, 0);
    std::vector<float> ispc_output = std::vector<float>(n, 0);
    std::vector<float> asm_output = std::vector<float>(n, 0);

    scan_cpp(input.data(), cpp_output.data(), n);
    scan_ispc(input.data(), ispc_output.data(), n);
    scan_asm(input.data(), asm_output.data(), n);

    {
        auto [fst, snd] = std::mismatch(
            cpp_output.begin(), cpp_output.end(), ispc_output.begin(),
            [](float a, float b) { return compare_rel_diff(a, b); });

        if (fst != cpp_output.end()) {
            auto index = std::distance(cpp_output.begin(), fst);
            printf("at index %td value %f does not match %f \n", index, *fst,
                   *snd);
        }
    }

    {
        auto [fst, snd] = std::mismatch(
            cpp_output.begin(), cpp_output.end(), asm_output.begin(),
            [](float a, float b) { return compare_rel_diff(a, b); });

        if (fst != cpp_output.end()) {
            auto index = std::distance(cpp_output.begin(), fst);
            printf("at index %td value %f does not match %f \n", index, *fst,
                   *snd);
        }
    }

    printf("validation done\n");

    return 0;
}
