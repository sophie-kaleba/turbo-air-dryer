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

	def jit_compile(jit_string)
		if self.expression.token.getTokenId() != :Identifier
			raise "Operation " + self.token.type.to_s + " can't apply to type: "+self.expression.token.svalue
		end

		case (self.token.getTokenId())
		when :Increment
			var_name = self.expression.token.svalue.to_s

			jit_string <<  "\x48\x8b\x05" #movq ???(%rip), %rax
			write_diff_to(jit_string, var_name)

			jit_string << "\x48\xc7\xc3\x01\x00\x00\x00" #movq $1, %rbx

			jit_string << "\x48\x01\xc3" # addq %rax, %rbx

			jit_string <<  "\x48\x8d\x05" # lea (???(%rip)), %rax
			write_diff_to(jit_string, var_name)

			jit_string << "\x48\x89\x18" #movq %rbx, (%rax)

			jit_string << "\x53" #pushq %rbx

		end
	end

	def to_s()
		return "PostfixOp " + self.token.to_s()
		+ " (" + self.expression.to_s() + ")";
	end
end







