#include <stdio.h>

int extract_n(int x, int pos) {
        return (x >> pos) & 1;
}

int set_n(int x, int pos) {
        return x | (1 << pos);
}
int main() {
  int x = 10;
  int i = 32;
  int y = 0,b;
  while (--i >= 0 ) {
    b = extract_n(x, i);
    if (b == 0)
        y = set_n(y, i);
    printf("%d", b);
  }
  printf("\n%d\n", y);
}
