require_relative "../c_wrapper/memory_manager"
include MemoryManager

$var_table = Hash.new(nil) 

def setup_memory_segment()
	$start_var_segment = c_init_memory(4096, 1)
	$start_method_segment = c_init_memory(4096, 1)
	c_init_var_segment($start_var_segment)
	if ($start_var_segment - $start_method_segment).abs > 1<<32
		raise "The 2 segments are too far from each other"
	end
	return $start_method_segment, $start_var_segment
end

def new_var(var_name, var_value=0)
	if $var_table[var_name] != nil
		raise "Variable already in use " + var_name.to_s
	end
	new_var_addr = c_add_var(var_value)
	$var_table[var_name] = new_var_addr
	return new_var_addr
end

def write_func(func_body)
	return c_add_func(func_body)
end

def update_var(var_name, new_var_value)
	if $var_table[var_name] == nil
		raise "Unknown variable " + var_name.to_s
	end
	c_update_var($var_table[var_name], new_var_value)
end

def get_var_value(var_name)
	if $var_table[var_name] == nil
		raise "Unknown variable " + var_name.to_s
	end
	if $var_table[var_name].is_a?(Array)
		raise "Can't print a function"
	end
	return c_get_var($var_table[var_name])
end

def get_var_addr(var_name)
	if $var_table[var_name] == nil
		raise "Unknown variable " + var_name.to_s
	end
	return $var_table[var_name]
end

