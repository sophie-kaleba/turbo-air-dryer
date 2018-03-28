
def build_proper_hex(hex_number)
	return eval("\"\\x"+hex_number.to_s(16)+"\"")
	# "TADA"
end


def write_int_as_4bytes(num, jit_string)
	jit_string << build_proper_hex(num & 255)
	jit_string << build_proper_hex((num >> 8) & 255)
	jit_string << build_proper_hex((num >> 16) & 255)
	jit_string << build_proper_hex((num >> 24) & 255)
end
