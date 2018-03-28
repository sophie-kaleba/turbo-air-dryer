
def build_proper_hex(hex_number)
	return eval("\"\\x"+hex_number.to_s(16)+"\"")
end
