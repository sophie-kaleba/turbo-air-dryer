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

def write_diff_to(jit_string, var_name, base_addr=$start_method_segment)
	if get_var_addr(var_name).is_a? Array
		addr = get_var_addr(var_name)[1]
	else
		addr = get_var_addr(var_name)
	end
	diff_rip = addr - (base_addr + jit_string.size) - 4  - 2
	write_int_as_4bytes(diff_rip, jit_string)
end

def dump_hex_string(string)
	puts string.each_byte.map { |b| sprintf("%.2x_", b)}.join
end

def save_regs(jit_string)

	jit_string << "\x53"         # push   rbx
	jit_string << "\x41\x54"     # push   r12
	jit_string << "\x41\x55"     # push   r13
	jit_string << "\x41\x56"     # push   r14
	jit_string << "\x41\x57"     # push   r15
	jit_string << "\x55"         # push   rbp
	jit_string << "\x48\x89\xe5" # mov rbp, rsp

	jit_string << "\x90\x90\x90" # NOP NOP NOP
end

def restore_regs(jit_string)
	jit_string << "\x90\x90\x90" # NOP NOP NOP

	jit_string << "\x48\x89\xec" #mov rsp, rbp
	jit_string << "\x5d"     # pop    rbp
	jit_string << "\x41\x5f" # pop    r15
	jit_string << "\x41\x5e" # pop    r14
	jit_string << "\x41\x5d" # pop    r13
	jit_string << "\x41\x5c" # pop    r12
	jit_string << "\x5b"     # pop    rbx
end

