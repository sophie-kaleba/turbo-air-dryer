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

	def to_s()
		return self.expression.to_s()
	end
end

