#!/usr/bin/env ruby

require_relative "Environment"
require_relative "Unserializer"

global = Environment.new()
unserializer = Unserializer.new(ARGF)
body = unserializer.readStatementList()

def puti s
	puts "\t" + s
end

puts ".text"
puts ".global main"
puts "\n\n"

puts "main:"


for st in body
	st.compile(global)
end

puti "popq %rax"

puti "ret"
