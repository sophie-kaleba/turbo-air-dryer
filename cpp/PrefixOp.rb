require_relative 'Value'
require_relative 'Expression'

class PrefixOp < Expression
#	private Token token
#	private Expression expression
	attr_accessor :token, :expression, :nodeId

	def initialize(token, expression)
		self.token = token
		self.expression = expression
		self.nodeId = 1
	end

	def compile(env)
		rg = self.expression.compile(env)

		puti "popq %rax"

		case self.token.getTokenId()
		when :Minus
			puti "neg %rax"
		when :Plus
		else
			raise "Not yet Implemented"
		end
		puti "pushq %rax"

	end

	def evaluate(env)
		rg = self.expression.evaluate(env)

		case self.token.getTokenId()
		when :Minus
			return Value.new(:Integer, -rg.getIntValue())
		when :Plus
			return Value.new(:Integer, rg.getIntValue())
		else
			raise "Not implemented yet"
		end
	end


	def to_s()
		return "PrefixOp " + self.token.to_s()
		+ " (" + self.expression.to_s() + ")"
	end
end
