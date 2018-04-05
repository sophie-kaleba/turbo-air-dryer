require_relative 'Expression'
require_relative "Libcaca.rb"
require_relative "Memory.rb"

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

	def fjit_compile(env, jit_string)

	end

	def jit_compile(jit_string)
		case (self.token.getTokenId())
		when :Integer
			jit_string << "\x68" #pushq $value
			write_int_as_4bytes(self.token.svalue.to_i, jit_string)
#			jit_string << "\x6a" #pushq $value
#			jit_string << build_proper_hex(self.token.svalue.to_i)

		when :Identifier
			jit_string <<  "\x48\x8b\x05" #movq ???(%rip), %rax
			write_diff_to(jit_string, self.token.svalue)

			jit_string << "\x50" #pushq %rax (take the value of the var)
		else
			raise "Not implemented yet"
		end
	end


	def to_s()
		return self.token.to_s()
	end
end
