
class Environment
	#    private Map<String,Value> map;
	#    stack is a stack of map
	attr_accessor :stack

	def initialize()
		self.stack = [Hash.new(nil)]
	end

	def put(id, val)
		self.stack[0][id] = val
	end

	def create
		self.stack.unshift(Hash.new(nil))
	end

	def pop
		self.stack.shift
	end

	def exist(id)
		for map in self.stack
			if map[id] != nil then return true end
		end
		return false
	end

	def get(id)
		for map in self.stack
			return map[id] if map[id] != nil
		end
		raise id + " is not defined"
	end
end
