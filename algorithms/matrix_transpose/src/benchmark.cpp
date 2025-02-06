#include <benchmark/benchmark.h>

#include "../../../include/common.h"
#include "../include/declarations.h"

class TestFixture : public benchmark::Fixture {
  public:
    void SetUp(const benchmark::State &state) override {
        n = state.range(0);
        input = random_array(n);
        output = DynArray<float>(n, 0);
    }

    void TearDown(const benchmark::State &) override {
        n = 0;
        input.clear();
        output.clear();
    }

    uint32_t n;
    DynArray<float> input;
    DynArray<float> output;
};

BENCHMARK_DEFINE_F(TestFixture, BM_TRANSPOSE_CPP)(benchmark::State &state) {
    for (auto _ : state) {
        transpose_cpp(input.data, output.data, n);
    }
}

BENCHMARK_DEFINE_F(TestFixture, BM_TRANSPOSE_ISPC)(benchmark::State &state) {
    for (auto _ : state) {
        transpose_ispc(input.data, output.data, n);
    }
}

BENCHMARK_DEFINE_F(TestFixture, BM_TRANSPOSE_ASM)(benchmark::State &state) {
    for (auto _ : state) {
        transpose_asm(input.data, output.data, n);
    }
}

BENCHMARK_REGISTER_F(TestFixture, BM_TRANSPOSE_CPP)
    ->Unit(benchmark::kMicrosecond)
    ->Arg(10e3)
    ->Arg(10e4)
    ->Arg(10e5);

BENCHMARK_REGISTER_F(TestFixture, BM_TRANSPOSE_ISPC)
    ->Unit(benchmark::kMicrosecond)
    ->Arg(10e3)
    ->Arg(10e4)
    ->Arg(10e5);

BENCHMARK_REGISTER_F(TestFixture, BM_TRANSPOSE_ASM)
    ->Unit(benchmark::kMicrosecond)
    ->Arg(10e3)
    ->Arg(10e4)
    ->Arg(10e5);

BENCHMARK_MAIN();
