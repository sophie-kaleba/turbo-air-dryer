class Ternary < Expression
#	private Expression condition
#	private Expression thn
#	private Expression els
	attr_accessor: :condition :thn :els :nodeId

	def initialize(condition, thn, els)
		self.condition = condition
		self.thn = thn
		self.els = els
		self.nodeId = 7
	end

	def evaluate(env)
		raise "Not implemented yet"
	end


	def to_s()
		return "Ternary "
		+ " (" + self.condition.to_s()
		+ ", " + self.thn.to_s()
		+ ", " + self.els.to_s() + ")"
	end
end
