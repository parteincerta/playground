#include <stdio.h>
#include <stdlib.h>

// Implements the functionaly demonstrated in:
// https://raytracing.github.io/books/RayTracingInOneWeekend.html#outputanimage/theppmimageformat

int main (int argc, char **argv) {
	const int img_width = argc == 3 ? atoi(argv[1]) : 256;
	const int img_height = argc == 3 ? atoi(argv[2]) : 256;

	// Writing the PPM header.
	fputs("P3\n", stdout);
	char dim_buffer[11] = {'\0'};
	sprintf(dim_buffer,"%d", img_width);
	fputs(dim_buffer, stdout);
	fputs(" ", stdout);
	sprintf(dim_buffer,"%d", img_height);
	fputs(dim_buffer, stdout);
	fputs("\n255\n", stdout);

	// Writing the PPM body.
	char channel_buffer[11] = {'\0'};
	for (int j = 0; j < img_height; j++) {
	for (int i = 0; i < img_width; i++) {
		const float r = (float)i / (img_width - 1);
		const float g = (float)j / (img_height - 1);

		const int int_r = (int)255.999f * r;
		const int int_g = (int)255.999f * g;

		sprintf(channel_buffer, "%d", int_r);
		fputs(channel_buffer, stdout);
		fputs(" ", stdout);
		sprintf(channel_buffer, "%d", int_g);
		fputs(channel_buffer, stdout);
		fputs(" ", stdout);
		sprintf(channel_buffer, "%d", 0);
		fputs(channel_buffer, stdout);
		fputs("\n", stdout);
	}}

	return 0;
}
