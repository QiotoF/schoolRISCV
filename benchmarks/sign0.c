int sign0 (int a) {
  return (a >> 31) | ((unsigned int)(-a) >> 31);
}