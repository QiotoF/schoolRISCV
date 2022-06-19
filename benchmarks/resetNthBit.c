int resetNthBit(int x, int n)
{     
    return x & ~(1<<n);
}