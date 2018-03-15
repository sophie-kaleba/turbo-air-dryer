class While
#	private Expression condition
#	private List<Statement> body
	attr_accessor :condition, :body, :nodeId

	def initialize(condition, body)
		self.condition = condition
		self.body = body
		self.nodeId = 21
	end

	def evaluate(env)
		while(self.condition.evaluate(env).getBooleanValue())
			for st in self.body
				tmp = st.evaluate(env)
				if (tmp.type == :Return)
					return tmp
				end
			end
		end
		return Value.new(:Undefined)
	end

	def compile(env)
		
	end

	def to_s()
		return "While ("
		+ self.condition.to_s() + ") "
		+ self.body.to_s()
	end
end
