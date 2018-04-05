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

	def jit_compile(jit_string)
		self.expression.jit_compile(jit_string)
		jit_string << "\x58\x4c\x89\xcb\x4c\x89\xc5\x48\x89\xfc\xc3" #this part restores rbx, rbp and rsp
	end

	def to_s()
		res = "Return"
		if self.expression != nil
			res += " (" + self.expression.to_s + ")"
		end
		return res
	end
end
