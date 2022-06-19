int minOf3(int x, int y, int z) {    
    int min = x;
    if (y < min) min = y;
    if (z < min) min = z;
    return min;
}
