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
		param2reg = ["\x57", # pushq rdi
	       "\x56",               # pushq rsi
	       "\x52",               # pushq rdx
	       "\x51",        	     # pushq rcx
	       "\x41\x50",           # pushq r8
	       "\x41\x51"]           # pushq r9


		if $var_table[self.name.svalue] != nil	
			raise self.name.svalue + " is already defined!"
		end

		funjit_string = "\x55" # push   rbp
		funjit_string = "\x48\x89\xe5" # mov    rbp,rsp 

		save_regs(funjit_string)

		# now we're gonna push all the parameter to access them with rsp
		baby_map = Hash.new(nil)

		for arg_index in 0..(parameters.size - 1)
			baby_map[parameters[arg_index].svalue] = arg_index * 8
			funjit_string << param2reg[arg_index]
		end

		for st in body
			st.funjit_compile(funjit_string, baby_map)
		end

		restore_regs(funjit_string)
		funjit_string << "\x5d\xc3"
		func_addr = new_func(self.name.svalue, funjit_string)

		$var_table[self.name.svalue] = [self.parameters, func_addr] # get my addr
		jit_string << "\x68" #push 
		write_diff_to(jit_string, self.name.svalue)

	end


	def to_s()
		return "Function " + self.name.to_s() + " "
		+ self.parameters.to_s() + " "
		+ self.body.to_s()
	end
end
