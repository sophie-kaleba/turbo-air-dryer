class IfThenElse
	#	private Expression condition
	#	private List<Statement> thn
	#	private List<Statement> els
	attr_accessor :condition, :thn, :els, :nodeId

	def initialize(condition, thn, els)
		self.condition = condition
		self.thn = thn
		self.els = els
		self.nodeId = 20
	end

	def compile(env)
		self.condition.compile(env)
		puti "\nmovq $1, %r8 # IfThenElse"
		puti "cmp %rcx, %r8"
		puti "jne ifBegin_" # Ce serait cool d'ajouter les numéros de lignes /colonne a l'identifiant
		puti ""

		if self.els != nil
			for st in self.els
				st.compile(env)
			end
		end
		puti "jmp "
	end

	def jit_compile(jit_string)
		self.condition.jit_compile(jit_string)

		jit_string << "\x58" #popq %rax
		jit_string << "\x48\x83\xf8\x00" #cmp $0, %rax 

		jit_string << "\x0F\x84" # "\xe9" # je ???
		pos_jne = jit_string.size
#		write_int_as_4bytes(0x12, jit_string)
		
		jit_string << "\xcc\xcc\xcc\xcc" # breakpoint

#		jit_string << "\xcc" # nop after compiling body
#		jit_string << "\xcc" # nop after compiling body
		
		jit_string << "\x90" # nop after compiling body
		jit_string << "\x90" # nop after compiling body


		for st in self.thn
			st.jit_compile(jit_string)
		end

		jit_string << "\x90" # nop after compiling body
		jit_string << "\x90" # nop after compiling body

		nb_bytes_wrote = jit_string.size - pos_jne

		puts "jne " + nb_bytes_wrote.to_s + " bytes forward"

		dump_hex_string(jit_string)

		# -2 is the size of jne
		write_int_as_4bytes(nb_bytes_wrote - 4, jit_string, pos_jne)

		dump_hex_string(jit_string)
	end

	def evaluate (env)
		if(self.condition.evaluate(env).getBooleanValue())
			for st in self.thn
				tmp = st.evaluate(env)
				if (tmp.type == :Return)
					return tmp
				end
			end
		else
			for st in self.els
				tmp = st.evaluate(env)
				if (tmp.type == :Return)
					return tmp
				end
			end
		end
		return Value.new(:Undefined)
	end

	def to_s()
		return "IfThenElse (" + self.condition.to_s() + ") "
		+ self.thn.to_s() + " "
		+ self.els.to_s()
	end
end
