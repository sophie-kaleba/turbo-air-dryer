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
