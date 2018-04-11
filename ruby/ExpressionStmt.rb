class ExpressionStmt
	#    private Expression expression;
	attr_accessor :expression

	def initialize (expression)
		self.expression = expression
	end

	def getNodeId()
		return self.expression.nodeId
	end

	def evaluate(expr)
		return self.expression.evaluate(expr)
	end

	def compile(expr)
		return self.expression.compile(expr)
	end

	def funjit_compile(env, jit_string) 
		self.expression.funjit_compile(env, jit_string)
		jit_string << "\x58" #at every ;, pop the result in rax
	end

	def jit_compile(jit_string)
		self.expression.jit_compile(jit_string)
		jit_string << "\x58" #at every ;, pop the result in rax
	end

	def to_s()
		return self.expression.to_s()
	end
end

