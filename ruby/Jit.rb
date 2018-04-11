#!/usr/bin/env ruby

require_relative "Environment"
require_relative "Unserializer"
require_relative "Memory.rb"
require_relative "Libcaca.rb"

# global = Environment.new()
unserializer = Unserializer.new(ARGF)
body = unserializer.readStatementList()

puts

setup_memory_segment()
puts "code segment addr: " + $start_method_segment.to_s(16)
puts "var segment addr: "  + $start_var_segment.to_s(16)

jit_string = "\x49\x89\xd9\x49\x89\xe8\x48\x89\xe7\x90\x90\x90" #saves rsp, rbp and rbx in r8, r9 and rdi

for st in body
	st.jit_compile(jit_string)
end

jit_string << "\x90\x90\x90\x4c\x89\xcb\x4c\x89\xc5\x48\x89\xfc\xc3" #this part restores rbx, rbp and rsp
c_write_memory($start_method_segment, jit_string)



puts
puts "\e[31;1m===> method segment <===\e[m"
dump_hex_string(jit_string)
c_dump_memory($start_method_segment, jit_string.size + 10)
puts "\e[31;1m========================\e[m"

puts
puts "\e[32;1m======== Execution ========\e[m"
puts c_call_function($start_method_segment)
puts "\e[32;1m===========================\e[m"

puts
puts "\e[31;1m===> var segment <===\e[m"
c_dump_memory($start_var_segment, $var_table.size * 8 + 4)
puts "\e[31;1m=====================\e[m"

puts
puts "\e[31;1m===> dump var <===\e[m"
for i in $var_table
	puts i[1].to_s(16) + i[0] + " = " + get_var_value(i[0]).to_s
end
puts "\e[31;1m==================\e[m"



