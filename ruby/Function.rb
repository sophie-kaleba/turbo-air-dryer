class Function < Expression
	#    private Token name
	#    private List<Token> parameters
	#    private List<Statement> body
	attr_accessor :name, :parameters, :body

	def initialize(name, parameters, body)
		self.name = name
		self.parameters = parameters
		self.body = body
	end

	def getNodeId()
		return 5 if self.name == nil
		return 6
	end

	def evaluate(env)
		if env.exist(self.name.svalue)
			raise self.name.svalue + " is already defined!"
		end
		env.put(self.name.svalue, self)
		return Value.new(:Undefined)
	end

	def jit_compile(jit_string)
		param2reg = ["\x57" ,#push rdi
	       		"\x56" ,#push rsi
	       		"\x52" ,#push rdx
	       		"\x51" ,#push rcx
	       		"\x41\x50" ,#push r8
	       		"\x41\x51"] #push r9

		if $var_table[self.name.svalue] != nil	
			raise self.name.svalue + " is already defined!"
		end

		funjit_string = ""
		save_regs(funjit_string)

		baby_map = Hash.new(nil)
		
		func_addr = c_get_var_segment_addr()
		$var_table[self.name.svalue] = [self.parameters, func_addr]
		
		for arg_index in 0..(parameters.size - 1)
			baby_map[parameters[arg_index].svalue] = -((arg_index + 1) * 8)
			funjit_string << param2reg[arg_index]
		end
		
		for st in body
			st.funjit_compile(funjit_string, baby_map)
		end

		restore_regs(funjit_string)
		funjit_string << "\xc3" #ret (in case there is no return in the function)
		write_func(funjit_string)

		jit_string << "\x68" #push the function address
		write_diff_to(jit_string, self.name.svalue)

	end


	def to_s()
		return "Function " + self.name.to_s() + " "
		+ self.parameters.to_s() + " "
		+ self.body.to_s()
	end
end
