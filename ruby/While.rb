class While
#	private Expression condition
#	private List<Statement> body
	attr_accessor :condition, :body, :nodeId

	def initialize(condition, body)
		self.condition = condition
		self.body = body
		self.nodeId = 21
	end

	def evaluate(env)
		while(self.condition.evaluate(env).getBooleanValue())
			for st in self.body
				tmp = st.evaluate(env)
				if (tmp.type == :Return)
					return tmp
				end
			end
		end
		return Value.new(:Undefined)
	end

	def jit_compile(jit_string)
		before_condition = jit_string.size

		self.condition.jit_compile(jit_string)

		jit_string << "\x58" #popq %rax
		jit_string << "\x48\x83\xf8\x00" #cmp $0, %rax 

		jit_string << "\x0F\x84" # "\xe9" # je ???
		pos_jne = jit_string.size
		
		jit_string << "\xcc\xcc\xcc\xcc" # breakpoint

		jit_string << "\x90" # nop before compiling body
		jit_string << "\x90" # nop before compiling body

		for st in self.body
			st.jit_compile(jit_string)
		end

		jit_string << "\xe9" # jmp before_condition
		write_int_as_4bytes(before_condition - jit_string.size - 4, jit_string)

		jit_string << "\x90" # nop after compiling body
		jit_string << "\x90" # nop after compiling body

		nb_bytes_wrote = jit_string.size - pos_jne

		puts "jne " + nb_bytes_wrote.to_s + " bytes forward"

		# -2 is the size of jne
		write_int_as_4bytes(nb_bytes_wrote - 4, jit_string, pos_jne)
		
	end

	def to_s()
		return "While ("
		+ self.condition.to_s() + ") "
		+ self.body.to_s()
	end
end
