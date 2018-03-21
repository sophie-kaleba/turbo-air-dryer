// Include the Ruby headers and goodies
#include "ruby.h"

// Defining a space for information and references about the module to be stored internally
VALUE MyTest = Qnil;

// Prototype for the initialization method - Ruby calls this, not you
void Init_mytest();

// Prototype for our method 'test1' - methods are prefixed by 'method_' here
VALUE method_test1(VALUE self);
VALUE check_ptr(VALUE self, VALUE ptr);

// The initialization method for this module
void Init_mytest() {
	MyTest = rb_define_module("MyTest");
	rb_define_method(MyTest, "test1", method_test1, 0);
	rb_define_method(MyTest, "check_ptr", check_ptr, 1);
}

// Our 'test1' method.. it simply returns a value of '10' for now.
VALUE method_test1(VALUE self) {
	int x = 10;
	void * caca = (void *) method_test1;
	printf("%x\n", caca);
	return INT2NUM(caca);
}


VALUE check_ptr(VALUE self, VALUE ptr) {
	printf("%x\n", NUM2INT(ptr));
	return Qnil;
}
