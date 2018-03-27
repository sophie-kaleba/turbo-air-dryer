#!/usr/bin/env ruby

require_relative "Environment"
require_relative "Unserializer"
require_relative "../c_wrapper/memory_manager"
include MemoryManager

global = Environment.new()
unserializer = Unserializer.new(ARGF)
body = unserializer.readStatementList()

start_address = init_memory(1024)
jit_string = "\x49\x89\xd9\x49\x89\xe8\x48\x89\xe7" #saves rsp, rbp and rbx in r8, r9 and rdi

# somehow, we need to initiate the stack to actually push and pop values.
# the following lines do not work
# maybe rsp and rbp have to be different to actually "Allocate space for local variable"
#"movq $0x7f06d95b3000, %rax" = \x48\x8b\x04\x25
#"addq $50, %rax" = \x48\x03\x04\x25
#"movq %rax, %rbp"= \x48\x89\xc5
#"movq %rax, %rsp"= \x48\x89\xc4

# we can test using
# write_memory(start, "\x48\xc7\xc0\x05\x00\x00\x00\xc3")
# which returns 5


for st in body
	st.jit_compile(global, jit_string)
end

#toto = jit_string.each_byte.map { |b| b.to_s(16) + "_"}.join
#puts toto

jit_string += "\x4c\x89\xcb\x4c\x89\xc5\x48\x89\xfc\xc3" #this part restores rbx, rbp and rsp
write_memory(start_address, jit_string)
dump_memory(start_address, jit_string.size)
puts call_function(start_address)


