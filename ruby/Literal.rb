require_relative 'Expression'

class Literal < Expression
#	private Token token
	attr_accessor :token, :nodeId

	def initialize(token)
		self.token = token
		self.nodeId = 0
	end

	def evaluate(env)
		case (self.token.getTokenId())
		when :Integer
			return Value.new(:Integer, Integer(self.token.svalue))

		when :Identifier
			return env.get(self.token.svalue)
		when :String
			return Value.new(:String, self.token.svalue)
		else
			raise "Not implemented yet"
		end
	end

	def compile(env)
		case (self.token.getTokenId())
		when :Integer
			puti "pushq $" + self.token.svalue.to_s + " # Literal"
		when :Identifier
			label = env.get(self.token.svalue)
			puti "movq " + label + "(%rip), %rax"
			puti "pushq %rax"
			
		else
			raise "Not implemented yet"
		end
		puts
	end

	def jit_compile(env, jit_string)
		case (self.token.getTokenId())
		when :Integer
			jit_string += "\xff\x34\x25"+sprintf("%c", self.token.svalue.to_i) #pushq $value		
		else
			raise "Not implemented yet"
		end
		return jit_string
	end


	def to_s()
		return self.token.to_s()
	end
end
