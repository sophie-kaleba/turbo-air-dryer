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

	def funjit_compile(jit_string, env)
		case (self.token.getTokenId())
		when :Integer
			jit_string << "\x68" #pushq value
			write_int_as_4bytes(self.token.svalue.to_i, jit_string)
		when :Identifier
			if env[self.token.svalue] != nil
				jit_string << "\x48\x8B\x85" #movq ??(%rbp), rax
				write_int_as_4bytes(env[self.token.svalue], jit_string)

				jit_string << "\x50" #pushq %rax (take the value of the var)
			elsif $var_table[self.token.svalue] != nil
				jit_string <<  "\x48\x8b\x05" #movq ???(%rip), %rax
				# On récupère la dernière adresse de memory manager
				current_addr = c_get_var_addr

				var_addr = $var_table[self.token.svalue]
				diff_rip = var_addr - (current_addr + jit_string.size) - 4 - 2
				write_int_as_4bytes(diff_rip, jit_string)

				jit_string << "\x50" #pushq %rax (take the value of the var)
			else
				raise "Variable \"#{self.token.svalue}\" not declared on line #{self.token.line}"
			end
		else
			raise "Not implemented yet : #{self.token.getTokenId()}"
		end
	end

	def jit_compile(jit_string)
		case (self.token.getTokenId())
		when :Integer
			jit_string << "\x68" #pushq $value
			write_int_as_4bytes(self.token.svalue.to_i, jit_string)

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
