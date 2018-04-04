#!/usr/bin/env ruby

require_relative "Environment"
require_relative "Unserializer"
require_relative "Memory.rb"
require_relative "Libcaca.rb"

global = Environment.new()
unserializer = Unserializer.new(ARGF)
body = unserializer.readStatementList()

setup_memory_segment()
puts "code "+$start_method_segment.to_s(16)
puts "var "+$start_var_segment.to_s(16)

jit_string = "\x49\x89\xd9\x49\x89\xe8\x48\x89\xe7\x90\x90\x90" #saves rsp, rbp and rbx in r8, r9 and rdi

for st in body
	st.jit_compile(global, jit_string)
end

#toto = jit_string.each_byte.map { |b| b.to_s(16) + "_"}.join

jit_string << "\x90\x90\x90\x4c\x89\xcb\x4c\x89\xc5\x48\x89\xfc\xc3" #this part restores rbx, rbp and rsp
c_write_memory($start_method_segment, jit_string)



puts "===> method segment :"
c_dump_memory($start_method_segment, jit_string.size + 10)
puts c_call_function($start_method_segment)

puts "===> var segment :"
c_dump_memory($start_var_segment, jit_string.size + 10)

for i in $var_table
	puts i[0] + " "+i[1].to_s(16)
	puts i[0] + " = " + get_var_value(i[0]).to_s
end



