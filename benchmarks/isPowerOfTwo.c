int isPowerOfTwo(int x)
{
	return x && (!(x & (x - 1)));
}
