#!/usr/bin/env ruby

require_relative "Environment"
require_relative "Unserializer"

global = Environment.new()
unserializer = Unserializer.new(ARGF)
body = unserializer.readStatementList()
for st in body
  st.evaluate(global)
end
