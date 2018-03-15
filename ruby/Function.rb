class Function < Expression
	#    private Token name
	#    private List<Token> parameters
	#    private List<Statement> body
	attr_accessor :name, :parameters, :body

	def initialize(name, parameters, body)
		self.name = name
		self.parameters = parameters
		self.body = body
	end

	def getNodeId()
		return 5 if self.name == nil
		return 6
	end

	def evaluate(env)
		if env.exist(self.name.svalue)
			raise self.name.svalue + " is already defined!"
		end
		env.put(self.name.svalue, self)
		return Value.new(:Undefined)
	end

	def to_s()
		return "Function " + self.name.to_s() + " "
		+ self.parameters.to_s() + " "
		+ self.body.to_s()
	end
end
