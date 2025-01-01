export void scan_ispc(uniform float input[], uniform float output[], uniform uint32 n) {
    uniform float sum = 0;
    foreach (i = 0...n) {
        float value = input[i];

        // inclusive scan on vector
        #pragma unroll
        for (uniform int v = 1; v < programCount; v = v * 2) {
            value += shift(value, -v);
        }

        output[i] = value + sum;

        // add the last value to the sum
        sum += extract(value, programCount - 1);
    }
}
