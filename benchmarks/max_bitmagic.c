int max(int a, int b) {
    return (b & ((a-b) >> 31) | a & (~(a-b) >> 31));
}