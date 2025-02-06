#include <cmath>
#include <cstdint>
#include <cstdio>

#include "../../../include/common.h"
#include "../include/declarations.h"

constexpr int PC = 8;

void print_out(float *array, size_t n) {
    for (int i = 0; i < n; i++) {
        printf("%f ", array[i]);

        if (i > 0 && (i + 1) % PC == 0)
            printf("\n");
    }
    printf("\n");
}

int main() {
    int n = PC * PC;
    // DynArray<float> input = random_array(n);
    DynArray<float> cpp_input = iota_array(n);
    DynArray<float> ispc_input = iota_array(n);
    DynArray<float> asm_input = iota_array(n);

    transpose_cpp(cpp_input.data, n);

    print_out(ispc_input.data, n);

    transpose_ispc(ispc_input.data, n);

    print_out(ispc_input.data, n);

    printf("done\n");

    return 0;
}
