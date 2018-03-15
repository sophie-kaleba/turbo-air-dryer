class Value
	:Undefined
	:Integer
	:Boolean

	:Function
	:String
	:Float

#	private Type type;
#	private Object obj;

	attr_accessor :type, :obj

#	undefined = Value.new(:Undefined, nil)

	def initialize (type, val = nil)
		self.type = type
		self.obj = val
	end

	def getBooleanValue
		return self.obj if (self.type == :Boolean)

		raise self.to_s() + " is not a boolean"
	end

	def getIntValue
		return self.obj	if (self.type == :Integer)

		raise self.to_s() + " is not an integer"
	end

	def getStringValue
		return self.obj	if (self.type == :String)

		raise self.to_s() + " is not an integer"
	end

	def to_s
		case self.type
		when :String
			return self.type.to_s + " \"" + self.obj.to_s + "\""
		else
			return self.type.to_s + " " + self.obj.to_s
		end
	end

end
