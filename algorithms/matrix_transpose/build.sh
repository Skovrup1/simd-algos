#!/bin/bash

NAME="transpose"

SRC_DIR="src"
INCLUDE_DIR="include"
BENCHMARK_DIR="../../benchmark/include"
ASM_DIR="../../include/"
BUILD_DIR="build"

CXX=g++

CXXFLAGS="-fno-exceptions"

# debug
CXXFLAGS="${CXXFLAGS} -O0 -g"
# optimized
#CXXFLAGS="${CXXFLAGS} -O3 -march=native"

# debug
ISPCFLAGS="-O0 -g --arch=x86-64 --target=avx2-i32x4"
# optimized
#ISPCFLAGS="-O3 --arch=x86-64 --target=avx2"

ASM_FLAGS="-g -F dwarf"
#ASM_FLAGS=""

mkdir -p $BUILD_DIR

# Compile NASM code
echo "Compiling NASM code"
nasm $ASM_FLAGS -f elf64 -I$ASM_DIR -o $BUILD_DIR/transpose_asm.o $SRC_DIR/transpose.asm

# Compile ISPC code
echo "Compiling ISPC code"
ispc $ISPCFLAGS -o $BUILD_DIR/transpose_ispc.o -h $BUILD_DIR/transpose_ispc.h $SRC_DIR/transpose.ispc

# Compile C++ code
echo "Compiling C++ code"
$CXX $CXXFLAGS -c -I$INCLUDE_DIR -o $BUILD_DIR/transpose_cpp.o $SRC_DIR/transpose.cpp

# function to build an executable
build_exe() {
    local main_file=$1
    local output_name=$2

    $CXX $CXXFLAGS -c -I$INCLUDE_DIR -I$BENCHMARK_DIR -o $BUILD_DIR/$main_file.o $SRC_DIR/$main_file

    echo "Compiling $output_name"
    $CXX $CXXFLAGS -o $BUILD_DIR/$output_name $BUILD_DIR/$main_file.o $BUILD_DIR/transpose_cpp.o $BUILD_DIR/transpose_asm.o $BUILD_DIR/transpose_ispc.o -lbenchmark -lpthread -lm
}

#build_exe "benchmark.cpp" "benchmark"
build_exe "validate.cpp" "validate"

echo "Build complete! Executables are in the $BUILD_DIR directory."

