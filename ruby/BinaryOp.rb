require_relative 'Value'
require_relative 'Expression'

# Expression
class BinaryOp < Expression
	#	private Token token
	#	private Expression expression1
	#	private Expression expression2
	attr_accessor :token, :expression1, :expression2, :nodeId

	def initialize (token, expression1, expression2)
		self.token = token
		self.expression1 = expression1
		self.expression2 = expression2
		self.nodeId = 3
	end

	def compile(env)
		rg = self.expression1.compile(env)
		rd = self.expression2.compile(env)
		puts # Retour a la ligne pour faire zoli
		puti "popq %rbx # BinaryOp"
		puti "popq %rax"
		case self.token.getTokenId()
		when :Plus
			puti "addq %rbx, %rax"
		when :Minus
			puti "subq %rbx, %rax"
		when :Asterisk
			puti "imulq %rbx"
		when :Slash
			puti "xorq %rdx, %rdx"
			puti "idivq %rbx"
		when :Percent
			puti "xorq %rdx, %rdx"
			puti "idivq %rbx"
			puti "pushq %rdx"
			return # don't want to push %rax
		when :Assignment
			puti "movq %rbx, (%rax)"
			return # don't want to push %rax because "ça casse tout"
		when :Equal
			puti "cmp %rbx, %rax"
			puti "sete %cl"
			return # don't want to push %rax
		when :LessThan
			puti "cmp %rbx, %rax"
			puti "setb %cl"
			return # don't want to push %rax
		when :LessOrEqual
			puti "cmp %rbx, %rax"
			puti "setbe %cl"
			return # don't want to push %rax
		when :GreaterThan
			puti "cmp %rbx, %rax"
			puti "seta %cl"
			return # don't want to push %rax
		when :GreaterOrEqual
			puti "cmp %rbx, %rax"
			puti "setae %cl"
			return # don't want to push %rax
		when :NotEqual
			puti "cmp %rbx, %rax"
			puti "setl %cl"
			return # don't want to push %rax
		when :PlusAssignment
			puti "addq %rbx, (%rax)"
			return # don't want to push %rax
		when :MinusAssignment
			puti "subq %rbx, (%rax)"
			return # don't want to push %rax
		else
			raise "Not yet Implemented"
		end

		puti "pushq %rax"
	end

	def jit_compile(env, jit_string)
		case self.token.getTokenId()
		when :Plus
			self.expression1.jit_compile(env, jit_string)
			self.expression2.jit_compile(env, jit_string)
			jit_string << "\x5b" #popq %rbx
			jit_string << "\x58" #popq %rax

			jit_string << "\x48\x01\xd8" #addq %rbx, %rax

			jit_string << "\x50" #pushq %rax
		when :Minus
			self.expression1.jit_compile(env, jit_string)
			self.expression2.jit_compile(env, jit_string)
			jit_string << "\x5b" #popq %rbx
			jit_string << "\x58" #popq %rax

			jit_string << "\x48\x29\xd8" #subq %rbx, %rax

			jit_string << "\x50" #pushq %rax
		when :Slash
			self.expression1.jit_compile(env, jit_string)
			self.expression2.jit_compile(env, jit_string)
			jit_string << "\x5b" #popq %rbx
			jit_string << "\x58" #popq %rax

			jit_string << "\x48\x31\xd2" # xorq rdx, rdx
			jit_string << "\x48\xf7\xfb" # idivq %rbx

			jit_string << "\x50" #pushq %rax

		when :Assignment
			if self.expression1.token.getTokenId() != :Identifier
				raise "Cannot assign to this type:"+self.expression1.token.svalue
			end
				
			self.expression2.jit_compile(env, jit_string)

			jit_string <<  "\x48\x8d\x05" # lea (???(%rip)), %rax

			write_diff_to(jit_string, self.expression1.token.svalue)

			jit_string << "\x5b" #popq %rbx <= expression 2
			jit_string << "\x48\x89\x18" #movq %rbx, (%rax)
			
			jit_string << "\x53" #pushq %rbx
		when :PlusAssignment
			if self.expression1.token.getTokenId() != :Identifier
				raise "Cannot assign to this type:"+self.expression1.token.svalue
			end

			var_name = self.expression1.token.svalue

			self.expression2.jit_compile(env, jit_string)

			jit_string <<  "\x48\x8b\x05" #movq ???(%rip), %rax
			write_diff_to(jit_string, var_name)

			jit_string << "\x5b" #popq %rbx <= expression 2

			jit_string << "\x48\x01\xc3" # addq %rax, %rbx

			jit_string <<  "\x48\x8d\x05" # lea (???(%rip)), %rax
			write_diff_to(jit_string, var_name)

			jit_string << "\x48\x89\x18" #movq %rbx, (%rax)

			jit_string << "\x53" #pushq %rbx
		when :MinusAssignment
			if self.expression1.token.getTokenId() != :Identifier
				raise "Cannot assign to this type:"+self.expression1.token.svalue
			end

			var_name = self.expression1.token.svalue

			self.expression2.jit_compile(env, jit_string)


			jit_string <<  "\x48\x8b\x05" #movq ???(%rip), %rax
			write_diff_to(jit_string, var_name)

			jit_string << "\x5b" #popq %rbx <= expression 2

			jit_string << "\x48\x29\xd8" # addq %rax, %rbx
			jit_string << "\x48\x89\xc3" # movq %rax, %rbx

			jit_string <<  "\x48\x8d\x05" # lea (???(%rip)), %rax
			write_diff_to(jit_string, var_name)

			jit_string << "\x48\x89\x18" #movq %rbx, (%rax)

			jit_string << "\x53" #pushq %rbx
		when :Equal
			self.expression1.jit_compile(env, jit_string)
			self.expression2.jit_compile(env, jit_string)
			jit_string << "\x5b" #popq %rbx
			jit_string << "\x58" #popq %rax

			jit_string << "\x48\x39\xd8" # cmp %rbx, %rax
			jit_string << "\x0f\x94\xc0" # sete %al
			jit_string << "\x48\x0f\xbe\xc0" #movsqb %al, %rax
			jit_string << "\x50" #pushq %rax
			
		else
			raise "Not yet Implemented: " + self.token.getTokenId().to_s 
		end

	end


	def evaluate(env)
		rg = self.expression1.evaluate(env)
		rd = self.expression2.evaluate(env)

		case self.token.getTokenId()
		when :LessThan
			return Value.new(:Boolean, rg.getIntValue() < rd.getIntValue())
		when :GreaterThan
			return Value.new(:Boolean, rg.getIntValue() > rd.getIntValue())
		when :Equal
			return Value.new(:Boolean, rg.getIntValue() == rd.getIntValue())
		when :LessOrEqual
			return Value.new(:Boolean, rg.getIntValue() <= rd.getIntValue())
		when :GreaterOrEqual
			return Value.new(:Boolean, rg.getIntValue() >= rd.getIntValue())
		when :NotEqual
			return Value.new(:Boolean, rg.getIntValue() != rd.getIntValue())
		when :Plus
			return Value.new(:Integer, rg.getIntValue() + rd.getIntValue())
		when :Minus
			return Value.new(:Integer, rg.getIntValue() - rd.getIntValue())
		when :Asterisk
			return Value.new(:Integer, rg.getIntValue() * rd.getIntValue())
		when :Slash
			return Value.new(:Integer, rg.getIntValue() / rd.getIntValue())
		when :Minus
			return Value.new(:Integer, rg.getIntValue() % rd.getIntValue())
		when :Caret
			return Value.new(:Integer, rg.getIntValue() ^  rd.getIntValue())
		when :Pipe
			return Value.new(:Integer, rg.getIntValue() |  rd.getIntValue())
		when :Caret
			return Value.new(:Integer, rg.getIntValue() &  rd.getIntValue())
		when :LogicalAnd
			return Value.new(:Boolean, rg.getBooleanValue() &&  rd.getBooleanValue())
		when :LogicalXor
			return Value.new(:Boolean, rg.getBooleanValue() ^ rd.getBooleanValue())
		when :LogicalOr
			return Value.new(:Boolean, rg.getBooleanValue() ||  rd.getBooleanValue())

		when :Assignment
			env.put(self.expression1.token.svalue, rd)
			return rd # Pourquoi on renvoie pas la vraie valeur
		when :PlusAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() + rd.getIntValue())
			env.put(name,  res)
			return res
		when :MinusAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() - rd.getIntValue())
			env.put(name,  res)
			return res
		when :MulAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() * rd.getIntValue())
			env.put(name,  res)
			return res
		when :DivAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() / rd.getIntValue())
			env.put(name,  res)
			return res
		when :ModAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() % rd.getIntValue())
			env.put(name,  res)
			return res
		when :AndAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() & rd.getIntValue())
			env.put(name,  res)
			return res
		when :XorAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() ^ rd.getIntValue())
			env.put(name,  res)
			return res
		when :OrAssignment
			name = self.expression1.token.svalue
			res = Value.new(:Integer, env.get(name).getIntValue() | rd.getIntValue())
			env.put(name,  res)
			return res

		else
			raise self.token.getTokenId().to_s + " not yet implemented"
		end
	end

	def to_s()
		return "BinaryOp " + self.token.to_s()
		+ " (" + self.expression1.to_s()
		+ ", " + self.expression2.to_s() + ")"
	end
end
