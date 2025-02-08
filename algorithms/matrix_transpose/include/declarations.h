#pragma once

#include <cstdint>

extern "C" {
void transpose_cpp(float *data, uint32_t n);

void transpose_ispc(float *data, uint32_t n);

void transpose_asm(float *data, uint32_t n);
}

#include "../build/transpose_ispc.h"
