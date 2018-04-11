#include <stdio.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>
#include <sys/mman.h>
#include <errno.h>

#include "ruby.h"

#define VAR_SIZE 8

//////////////////////////////////////////
////////// Used for generating the ruby
//////////////////////////////////////////

// Defining a space for information and references about the module to be stored internally
VALUE MemoryManager = Qnil;

// Prototype for the initialization method - Ruby calls this, not you
void Init_memory_manager();


/////////////////////////////////////////////////
////////// c functions - method segment
/////////////////////////////////////////////////


VALUE init_memory(VALUE self, VALUE size, VALUE exec)
{
	void * memory = NULL;

	if (NUM2INT(exec))
		 memory = mmap(NULL, NUM2INT(size), PROT_EXEC | PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE,
				                     -1, 0); // IGNORED
	else
		 memory = mmap(NULL, NUM2INT(size), PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE,
													-1, 0); // IGNORED

	if (memory == MAP_FAILED)
		rb_raise(rb_eRuntimeError, "mmap failed to allocate memory: %s", strerror(errno));

	memset(memory, 0xca, NUM2INT(size));
	return LONG2NUM((long) memory);
}

VALUE write_memory_n(VALUE self, VALUE dst, VALUE src, VALUE size)
{
	memcpy((void *) NUM2LONG(dst), StringValuePtr(src), NUM2INT(size));
	return Qnil;
}

VALUE write_memory(VALUE self, VALUE dst, VALUE src)
{
	memcpy((void *) NUM2LONG(dst), StringValuePtr(src), RSTRING_LEN(src));
	return Qnil;
}

VALUE call_function(VALUE self, VALUE func_addr)
{
	int (*func)(void) = (int (*)(void)) NUM2LONG(func_addr);
	return INT2NUM(func());
}

VALUE dump_memory(VALUE self, VALUE start, VALUE num_size) {
	char * ss_start = (char *) NUM2LONG(start);
	int size = NUM2INT(num_size);
	printf("dump offset: %.2x\n", ss_start[2]);
	for (int i = 0; i < size; i++) {
		printf("%.2x_", (unsigned char) ss_start[i]);
	}
	printf("\n");
	fflush(stdout);
	return Qnil;

}

/////////////////////////////////////////////////
////////// c functions - variable segment
/////////////////////////////////////////////////

static char * current_table_offset = NULL;

VALUE init_var_segment(VALUE self, VALUE base_addr)
{
	current_table_offset = (char *)NUM2LONG(base_addr);
	return Qnil;
}
	
VALUE add_var(VALUE self, VALUE var_value)
{
	char *local_offset = current_table_offset;
	*(int64_t *)current_table_offset = NUM2LONG(var_value);
	current_table_offset += VAR_SIZE;

	return LONG2NUM((long) local_offset);
}

VALUE add_func(VALUE self, VALUE func_value)
{
	char *local_offset = current_table_offset;
	size_t fun_size = RSTRING_LEN(func_value);
	memcpy(local_offset, StringValuePtr(func_value), fun_size);
	current_table_offset += fun_size;

	return LONG2NUM((long) local_offset);
}

VALUE update_var(VALUE self, VALUE var_address, VALUE new_var_value)
{
	*(int64_t *)NUM2LONG(var_address) = NUM2LONG(new_var_value);

	return Qnil;
}

VALUE get_var(VALUE self, VALUE var_address)
{
	return INT2NUM(*(int *)NUM2LONG(var_address));
}

//////////////////////////////////////
////////// probably useless
/////////////////////////////////////

VALUE write_and_call_function(VALUE self, VALUE dst, VALUE src, VALUE size)
{
	write_memory(self, NUM2LONG(dst), NUM2LONG(src));

	return call_function(self, NUM2LONG(dst));
}


// The initialization method for this module
void Init_memory_manager() {
	MemoryManager = rb_define_module("MemoryManager");
	rb_define_method(MemoryManager, "c_init_memory", init_memory, 2);
	rb_define_method(MemoryManager, "c_write_memory", write_memory, 2);
	rb_define_method(MemoryManager, "c_write_memory_n", write_memory_n, 3);
	rb_define_method(MemoryManager, "c_call_function", call_function, 1);
	rb_define_method(MemoryManager, "c_write_and_call_function", write_and_call_function, 3);
	rb_define_method(MemoryManager, "c_dump_memory", dump_memory, 2);
	rb_define_method(MemoryManager, "c_init_var_segment", init_var_segment, 1);
	rb_define_method(MemoryManager, "c_add_var", add_var, 1);
	rb_define_method(MemoryManager, "c_add_func", add_func, 1);
	rb_define_method(MemoryManager, "c_update_var", update_var, 2);
	rb_define_method(MemoryManager, "c_get_var", get_var, 1);
}
