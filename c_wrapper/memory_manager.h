#ifndef _MEMORY_MANAGER_H_
#define _MEMORY_MANAGER_H_

void *init_memory(size_t size);

void write_memory(void *dst, void *src, size_t size);

#endif /* _MEMORY_MANAGER_H_ */
