#include <benchmark/benchmark.h>
#include <vector>

#include "../include/common.h"

class TestFixture : public benchmark::Fixture {
  public:
    void SetUp(const benchmark::State &state) override {
        n = state.range(0);
        input = random_array(n);
        output = std::vector<float>(n, 0);
    }

    void TearDown(const benchmark::State &) override {
        n = 0;
        input.clear();
        output.clear();
    }

    uint32_t n;
    std::vector<float> input;
    std::vector<float> output;
};

BENCHMARK_DEFINE_F(TestFixture, BM_SCAN_CPP)(benchmark::State &state) {
    for (auto _ : state) {
        scan_cpp(input.data(), output.data(), n);
    }
}

BENCHMARK_DEFINE_F(TestFixture, BM_SCAN_ISPC)(benchmark::State &state) {
    for (auto _ : state) {
        scan_ispc(input.data(), output.data(), n);
    }
}

BENCHMARK_DEFINE_F(TestFixture, BM_SCAN_ASM)(benchmark::State &state) {
    for (auto _ : state) {
        scan_asm(input.data(), output.data(), n);
    }
}

BENCHMARK_REGISTER_F(TestFixture, BM_SCAN_CPP)
    ->Unit(benchmark::kMicrosecond)
    ->Arg(10e3)
    ->Arg(10e4)
    ->Arg(10e5);

BENCHMARK_REGISTER_F(TestFixture, BM_SCAN_ISPC)
    ->Unit(benchmark::kMicrosecond)
    ->Arg(10e3)
    ->Arg(10e4)
    ->Arg(10e5);

BENCHMARK_REGISTER_F(TestFixture, BM_SCAN_ASM)
    ->Unit(benchmark::kMicrosecond)
    ->Arg(10e3)
    ->Arg(10e4)
    ->Arg(10e5);

BENCHMARK_MAIN();
