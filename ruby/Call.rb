require_relative 'Expression'

class Call < Expression
	#    private Expression function;
	#    private List<Expression> arguments;i

	attr_accessor :function, :arguments, :nodeId

	def initialize (function, arguments)
		if function.class == Call
			self.function = function.function ## CACA
		else
			self.function = function
		end

		self.arguments = arguments
		self.nodeId = 4
	end

	def evaluate(env)
		if self.function.token.type != :Identifier
			raise "Function " + self.function.token.svalue.to_s + " not yet implemented"
		end

		if self.function.token.svalue == "print"
			for expr in self.arguments
				puts expr.evaluate(env).to_s
			end
			return Value.new(:Undefined)
		end

		if env.exist(self.function.token.svalue)
			func = env.get(self.function.token.svalue)
			env.create
			nb_arg = func.parameters.length

			if nb_arg != self.arguments.length
				raise "Wrong number of argument for function : " + func.token.svalue
			end

			for arg_index in 0..(nb_arg - 1)
				env.put(func.parameters[arg_index].svalue, self.arguments[arg_index].evaluate(env))
			end

			for expr in func.body
				tmp = expr.evaluate(env)

				if (tmp.type == :Return)
					env.pop
					return tmp.obj
				end
			end
			return Value.new(:Undefined)
		end

		raise "Function " + self.function.token.svalue.to_s + " not yet implemented"
	end

	def funjit_compile(jit_string, env)
		param2reg = ["\x5f" ,#mov ???, rdi
	      		"\x5e" ,#mov ???, rsi
	      		"\x5a" ,#mov ???, rdx
	      		"\x59" ,#mov ???, rcx
	      		"\x41\x58" ,#mov ???, r8
	      		"\x41\x59"] #mov ???, r9
		if $var_table[self.function.token.svalue] != nil	

			if $var_table[self.function.token.svalue].size == 1
				raise self.function.token.svalue+" is not a function"
			end

			nb_arg = $var_table[self.function.token.svalue][0].size

			# put all parameters in registers
			if nb_arg != self.arguments.length
				raise "Wrong number of argument for function : " + func.token.svalue
			end
			for arg_index in 0..(nb_arg - 1)
				self.arguments[arg_index].funjit_compile(jit_string, env)
				jit_string << param2reg[arg_index]
			end

			# jit_string << "\xb8\x00\x00\x00\x00" # mov 0, %eax
			jit_string << "\xe8" #call
			write_diff_to(jit_string, self.function.token.svalue)

			jit_string << "\x50" # push %rax
		end
	end


	def jit_compile(jit_string)
		param2reg = ["\x5f" ,#mov ???, rdi
	      		"\x5e" ,#mov ???, rsi
	      		"\x5a" ,#mov ???, rdx
	      		"\x59" ,#mov ???, rcx
	      		"\x41\x58" ,#mov ???, r8
	      		"\x41\x59"] #mov ???, r9
		if $var_table[self.function.token.svalue] != nil	

			if $var_table[self.function.token.svalue].size == 1
				raise self.function.token.svalue+" is not a function"
			end

			nb_arg = $var_table[self.function.token.svalue][0].size

			# put all parameters in registers
			if nb_arg != self.arguments.length
				raise "Wrong number of argument for function : " + func.token.svalue
			end
			for arg_index in 0..(nb_arg - 1)
				self.arguments[arg_index].jit_compile(jit_string)
				jit_string << param2reg[arg_index]
			end

			# jit_string << "\xb8\x00\x00\x00\x00" # mov 0, %eax
			jit_string << "\xe8" #call
			write_diff_to(jit_string, self.function.token.svalue)

			jit_string << "\x50" # push %rax
		end
	end

	def compile(env)
		if (self.function.token.type == :Identifier and self.function.token.svalue == "print") 
			to_print = self.function.arguments[0].line.to_s + self.function.arguments[0].column.to_s 
			puti to_print + ":"
			puti ".string \"" + self.function.arguments[0].svalue.to_s + "\""
			puti "movl $4, %eax"
			puti "movl $1, %ebx"
			puti "movl $to_print, %ecx"
			puti "movl $" + to_print.size.to_s + ", %ecx"
		end

	end

	def to_s()
		return "Call " + self.function.to_s() + " " + self.arguments.to_s();
	end
end
