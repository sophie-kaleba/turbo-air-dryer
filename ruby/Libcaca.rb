
def build_proper_hex(hex_number)
	return eval("\"\\x"+hex_number.to_s(16)+"\"")
	# "TADA"
end

def write_int_as_4bytes(num, jit_string, pos = -1)
	if pos == -1
		jit_string << build_proper_hex(num & 255)
		jit_string << build_proper_hex((num >> 8) & 255)
		jit_string << build_proper_hex((num >> 16) & 255)
		jit_string << build_proper_hex((num >> 24) & 255)
	else
		jit_string[pos] = build_proper_hex(num & 255)
		jit_string[pos + 1] = build_proper_hex((num >> 8) & 255)
		jit_string[pos + 2] = build_proper_hex((num >> 16) & 255)
		jit_string[pos + 3] = build_proper_hex((num >> 24) & 255)
	end
end

def write_diff_to(jit_string, var_name)
	puts get_var_addr(var_name).class
	if get_var_addr(var_name).is_a? Array
		magic = 1
		addr = get_var_addr(var_name)[1]
	else
		magic = 0
		addr = get_var_addr(var_name)
	end
	diff_rip = addr - ($start_method_segment + jit_string.size) - 4 \
		- 2 # (DARK) MAGIC NUMBER
	write_int_as_4bytes(diff_rip + magic , jit_string)
end

def dump_hex_string(string)
	puts string.each_byte.map { |b| b.to_s(16) + "_"}.join
end

def save_regs(jit_string)
	jit_string << "\x53\x54\x41\x54\x41\x55\x41\x56\x41\x57\x90\x90\x90"
end

def restore_regs(jit_string)
	jit_string << "\x90\x90\x90\x41\x5f\x41\x5e\x41\x5d\x41\x5c\x5c\x5b"
end
