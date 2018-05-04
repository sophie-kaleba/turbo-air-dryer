require_relative "Memory.rb"
require_relative "Libcaca.rb"

class Var
#	private Token variable
#	private Expression init
	attr_accessor :variable, :init

	def initialize(variable, init=nil)
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

	def jit_compile(jit_string)
		if(self.init == nil) # var x;
			var_name = self.variable.svalue
			new_var(var_name)
			return

		end
		# var x = something;

		self.init.jit_compile(jit_string) #after the =
		var_name = self.variable.svalue
		new_var(var_name)

		jit_string << "\x58" #popq %rax

		jit_string << "\x48\x89\x05" #mov %rax, ???(%rip)
		write_diff_to(jit_string, var_name)
	end
	

def to_s()
	return "Var " + self.variable.to_s()
	+ ( (self.init == nil) ? "" : " = " + self.init.to_s() )
	end
	end
