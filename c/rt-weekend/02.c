#include <stdio.h>
#include <stdlib.h>

int main (int argc, const char **argv) {
	const int img_width = argc == 3 ? atoi(argv[1]) : 256;
	const int img_height = argc == 3 ? atoi(argv[2]) : 256;

	fprintf(stdout, "P3\n%d %d\n%d\n", img_width, img_height, 255);

	return 0;
}
