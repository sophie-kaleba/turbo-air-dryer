#ifndef _MEMORY_MANAGER_H_
#define _MEMORY_MANAGER_H_

/**
 * Init readable, writable and executable memory somewhere.
 *
 * @param size : The number of byte you want to allocate
 * @return Pointer to the start of the memory
 */
void *init_memory(size_t size);

/**
 * Write something in memory (actually just a wrapper for memcpy)
 *
 */
void write_memory(void *dst, void *src, size_t size);

/**
 * Call a function at the given addr
 *
 */
int call_function(const void *func_addr);



//////////////////////////////////////
////////// probably useless
/////////////////////////////////////

int write_and_call_function(void *dst, void *src, size_t size);

#endif /* _MEMORY_MANAGER_H_ */
