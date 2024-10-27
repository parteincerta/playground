#include <stdio.h>
#include <stdlib.h>

// Implements the functionality presented in:
// https://raytracing.github.io/books/RayTracingInOneWeekend.html#outputanimage/theppmimageformat

int main (int argc, const char **argv) {
	const int img_width = argc == 3 ? atoi(argv[1]) : 256;
	const int img_height = argc == 3 ? atoi(argv[2]) : 256;

	// Writing the PPM header.
	fprintf(stdout, "P3\n%d %d\n%d\n", img_width, img_height, 255);

	// Writing the PPM body.
	for (int j = 0; j < img_height; j++) {
	for (int i = 0; i < img_width; i++) {
		const float r = (float)i / (img_width - 1);
		const float g = (float)j / (img_height - 1);

		const int int_r = (int) 255.f * r;
		const int int_g = (int) 255.f * g;

		fprintf(stdout, "%d %d %d\n", int_r, int_g, 0);
	}}

	return 0;
}
