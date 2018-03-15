#include <stdio.h>

#include "memory_manager.h"

int main(int argc, char **argv)
{
	char *MEMORY = init_memory(1000);

	write_memory(MEMORY, "\x48\xc7\xc0\x05\x00\x00\x00\xc3", 100);

	int (*func)() = MEMORY;
	fprintf(stderr, "before call\n");

	int caca = func();

	printf("%d\n", caca);
	return 0;
}
