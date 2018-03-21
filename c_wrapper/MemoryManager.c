#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <sys/mman.h>
#include "ruby.h"


//////////////////////////////////////////
////////// Used for generating the ruby
//////////////////////////////////////////

// Defining a space for information and references about the module to be stored internally
VALUE MemoryManager = Qnil;

// Prototype for the initialization method - Ruby calls this, not you
void Init_memory_manager();


// Prototype for our method 'test1' - methods are prefixed by 'method_' here
VALUE init_memory(VALUE self, VALUE size);
VALUE write_memory(VALUE self, VALUE dst, VALUE src, VALUE size);
VALUE call_function(VALUE self, VALUE func_addr);
VALUE write_and_call_function(VALUE self, VALUE dst, VALUE src, VALUE size);
VALUE dump_memory(VALUE self, VALUE start, VALUE size);


// The initialization method for this module
void Init_memory_manager() {
	MemoryManager = rb_define_module("MemoryManager");
	rb_define_method(MemoryManager, "init_memory", init_memory, 1);
	rb_define_method(MemoryManager, "write_memory", write_memory, 3);
	rb_define_method(MemoryManager, "call_function", call_function, 1);
	rb_define_method(MemoryManager, "write_and_call_function", write_and_call_function, 3);
	rb_define_method(MemoryManager, "dump_memory", dump_memory, 2);
}


/////////////////////////////////////////////////
////////// c functions that will be used in ruby
/////////////////////////////////////////////////


VALUE init_memory(VALUE self, VALUE size)
{
	fprintf(stderr, "init memory\n");

	void * memory = mmap(NULL, NUM2INT(size), PROT_EXEC | PROT_READ | PROT_WRITE, MAP_ANONYMOUS | MAP_PRIVATE,
				                     -1, 0); // IGNORED
	assert(memory != MAP_FAILED);

	printf("start of mmaped memory: %p\n", memory);
	return LONG2NUM((long) memory);
}

VALUE write_memory(VALUE self, VALUE dst, VALUE src, VALUE size)
{
	printf("memcpy starts ar: %p\n", NUM2LONG(dst));
	memcpy((void *) NUM2LONG(dst), StringValuePtr(src), NUM2INT(size));
	return Qnil;
}

VALUE call_function(VALUE self, VALUE func_addr)
{
	int (*func)(void) = (int (*)(void)) NUM2LONG(func_addr);

	return INT2NUM(func());
}


VALUE dump_memory(VALUE self, VALUE start, VALUE size) {
	char * ss_start = (char *) NUM2LONG(start);
	for (int i = 0; i < NUM2INT(size); i++) {
		printf("%x_", ss_start[i]);	
	}
	fflush(stdout);
	return Qnil;

}



//////////////////////////////////////
////////// probably useless
/////////////////////////////////////

VALUE write_and_call_function(VALUE self, VALUE dst, VALUE src, VALUE size)
{
	write_memory(self, NUM2LONG(dst), NUM2LONG(src), NUM2INT(size));

	return call_function(self, NUM2LONG(dst));
}
