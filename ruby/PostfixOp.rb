require_relative 'Expression'

class PostfixOp < Expression
	#	private Token token;
	#	private Expression expression;
	attr_accessor :token, :expression, :nodeId

	def initialize(token, expression)
		self.token = token;
		self.expression = expression;
		self.nodeId = 2
	end

	def evaluate(env)
		case (self.token.getTokenId())
		when :Increment
			if self.expression.token.getTokenId() == :Identifier
				id = self.expression.token.svalue
				val = env.get(id)
				env.put(id, Value.new(:Integer, val.getIntValue() + 1))
				return val;
			else
				raise "Not implemented yet"
			end
		when :Decrement
			if (self.expression.token.getTokenId() == :Identifier)
			   id = self.expression.token.svalue
			   val = env.get(id);
			   env.put(id, Value.new(:Integer, val.getIntValue() - 1))
			   return val;
			else
				raise "Not implemented yet"
			end
		else
			raise "Not implemented yet"
		end
	end

	def to_s()
		return "PostfixOp " + self.token.to_s()
		+ " (" + self.expression.to_s() + ")";
	end
end
