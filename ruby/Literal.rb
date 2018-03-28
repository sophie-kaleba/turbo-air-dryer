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

	def jit_compile(env, jit_string)
		case (self.token.getTokenId())
		when :Integer
			jit_string << "\x6a" + build_proper_hex(self.token.svalue.to_i) #pushq $value
		when :Identifier
			diff_rip = get_var_addr(self.token.svalue) - ($start_method_segment + jit_string.size) - 4
			jit_string <<  "\x48\x8b\x05"
			write_int_as_4bytes(diff_rip, jit_string)
			jit_string << "\x50"
		else
			raise "Not implemented yet"
		end
	end


	def to_s()
		return self.token.to_s()
	end
end
