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

	def jit_compile(env, jit_string)
		self.condition.jit_compile(env, jit_string)

		jit_string << "\x49\xc7\xc2\x01\x00\x00\x00" # movq $1, %r10
		jit_string << "\x49\x39\xca" # cmp %rcx, %r10

		jit_string << "\x0F\x85" # "\xe9" # jne ???
		pos_jne = jit_string.size
#		write_int_as_4bytes(0x12, jit_string)
		
		jit_string << "\xcc\xcc\xcc\xcc" # breakpoint

#		jit_string << "\xcc"

		for st in self.thn

			st.jit_compile(env, jit_string)
		end

		nb_bytes_wrote = jit_string.size - pos_jne

		puts "jne " + nb_bytes_wrote.to_s + " bytes forward"

		# -2 is the size of jne
		write_int_as_4bytes(nb_bytes_wrote - 2, jit_string, pos_jne)
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
