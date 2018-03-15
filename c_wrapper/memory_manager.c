#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <sys/mman.h>

void *init_memory(size_t size)
{
	fprintf(stderr, "init memory\n");

	void *memory = mmap(NULL, size, PROT_EXEC | PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE,
				                     -1, 0); // IGNORED
	assert(memory != MAP_FAILED);

	return memory;
}

void write_memory(void *dst, void *src, size_t size)
{
	memcpy(dst, src, size);
}

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
