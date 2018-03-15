require_relative "Value"

class Return
#    private Expression expression
	attr_accessor :expression

	def initialize(expression = nil)
		self.expression = expression
	end

	def getNodeId()
		if self.expression == nil 
			return 18 
		end
		return 19
	end

	def evaluate(env)
		res = self.expression.evaluate(env)
		return Value.new(:Return, res)
	end

	def to_s()
		res = "Return"
		if self.expression != nil
			res += " (" + self.expression.to_s + ")"
		end
		return res
	end
end
