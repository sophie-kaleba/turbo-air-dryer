require_relative "Memory.rb"
require_relative "Libcaca.rb"

class Var
#	private Token variable
#	private Expression init
	attr_accessor :variable, :init

	def initialize(variable, init)
		self.variable = variable
		self.init = init
	end

	def getNodeId()
		if self.init == nil 
		       return 16 
		end
		return 17
	end

	def evaluate(env)
		if(self.init == nil)
			raise "Not implemented yet"
		else
			env.put(self.variable.svalue, self.init.evaluate(env))
			return Value.new(:Undefined)
		end
	end

	def compile(env)
		if(self.init == nil)
			raise "Not implemented yet"
		end

		# On compile d'abord l'expression qui suis le =
		self.init.compile(env)

		label = self.variable.svalue + self.variable.line.to_s + self.variable.column.to_s 
		puti ".data"
		puts label + ": # Var"
		puti ".quad 0"
		puti ".text"

		puti "# On récupère ce qu'il y avait après le égal et on le met"
		puti "popq %rbx"
		puti "lea " + label + ", %rax"
		puti "movq %rbx, (%rax)\n"

		env.put(self.variable.svalue, label)

		puts
		return
	end

	def jit_compile(env, jit_string)
		if(self.init == nil)
			raise "Not implemented yet"
		end

		self.init.jit_compile(env, jit_string)

		var_name = self.variable.svalue
		new_var_addr = new_var(var_name)
		jit_string << "\x58" #popq %rax
		jit_string << "\x48\x89\x05" #mov %rax, ???(%rip)
		diff_rip = new_var_addr - ($start_method_segment + jit_string.size)
		puts diff_rip.to_s(16)
		jit_string << build_proper_hex(diff_rip & 255)
		jit_string << build_proper_hex((diff_rip >> 8) & 255)
		jit_string << build_proper_hex((diff_rip >> 16) & 255)
		jit_string << build_proper_hex((diff_rip >> 24) & 255)

	end
	

def to_s()
	return "Var " + self.variable.to_s()
	+ ( (self.init == nil) ? "" : " = " + self.init.to_s() )
	end
	end
