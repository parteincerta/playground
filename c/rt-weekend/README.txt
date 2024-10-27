Ray Tracing in One Weekend [1] implemented in C99.

Prerequisites:
- A compiler w/ support for C99, like Clang or GCC.
  In macOS it defaults to `clang`. In Linux to `gcc`.

Instructions:
- To build all exercises in debug mode:
	./build.sh
- To check additional build options:
	./build.sh --help
- To run a specific exercise:
	./bin/01 >./render.ppm

Notes:
- The `build.sh` could very well just have been a Makefile, but I took the
  chance to exercise a little bit of Bash script too.

[1]: https://raytracing.github.io/books/RayTracingInOneWeekend.html
