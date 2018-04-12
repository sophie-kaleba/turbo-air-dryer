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

	def funjit_compile(jit_string, env)
		self.expression.funjit_compile(jit_string, env)
		jit_string << "\x58" #pop rax
		restore_regs(jit_string)
		jit_string << "\xc3" #ret
	end

	def jit_compile(jit_string)
		self.expression.jit_compile(jit_string)
		jit_string << "\x58"
		restore_regs(jit_string)
		jit_string << "\xc3"
	end

	def to_s()
		res = "Return"
		if self.expression != nil
			res += " (" + self.expression.to_s + ")"
		end
		return res
	end
end
