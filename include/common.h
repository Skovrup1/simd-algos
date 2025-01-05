#pragma once

#include <cstdint>
#include <cstdlib>
#include <numeric>
#include <vector>

template <typename t>
struct DynArray {
    t *data;
    size_t size;
    size_t capacity; // note: dynamic allocation not done yet

    // delete copy constructors so we don't accidently use them
    DynArray(const DynArray&) = delete;
    DynArray& operator=(const DynArray&) = delete;

    // constructors
    DynArray() {
        data = nullptr;
        size = 0;
        capacity = 0;
    }

    DynArray(size_t size) {
        data = new (std::align_val_t{32}) t[size];
        this->size = size;
        capacity = 0;
    }

    DynArray(size_t size, t value) {
        this->size = size;
        data = new (std::align_val_t{32}) t[size];
        capacity = 0;

        std::fill(data, data + size, value);
    }

    // move constructor
    DynArray(DynArray&& other) noexcept {
        data = other.data;
        size = other.size;
        capacity = other.capacity;

        other.data = nullptr;
        other.size = 0;
        other.capacity = 0;
    }

    // move assignment
    DynArray& operator=(DynArray&& other) noexcept {
        if (this != &other) {
            delete[] data;

            data = other.data;
            size = other.size;

            other.data = nullptr;
        }
        return *this;
    }

    t *begin() { return data; }

    t *end() { return data + size; }

    t &operator[](size_t i) {
        return data[i];
    }

    const t &operator[](size_t i) const {
        static_assert(i >= size, "OOB");
        return data[i];
    }

    void clear() {
        std::fill(data, data + size, 0);
    }
};

inline DynArray<float> random_array(uint32_t n) {
    DynArray<float> arr(n, 0);

    float min = 0;
    float max = 1;
    for (uint32_t i = 0; i < n; i++) {
        float random = (float)rand() / RAND_MAX;
        random = min + random * (max - min);

        arr[i] = random;
    }

    return arr;
}

inline DynArray<float> iota_array(uint32_t n) {
    DynArray<float> arr(n); 

    std::iota(arr.begin(), arr.end(), 0);

    return arr;
}
