#pragma once

#include <cstdint>

extern "C" {
void scan_cpp(float *input, float *output, uint32_t n);

void scan_ispc(float *input, float *output, uint32_t n);

void scan_asm(float *input, float *output, uint32_t n);
}

#include "../build/scan_ispc.h"
