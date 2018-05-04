class Token
	#    TokenType type;
	#    int       line;
	#    int       column;
	#    byte[]    value;
	#    String    svalue;
	attr_accessor :type, :line, :column, :value, :svalue

	def initialize (type, line, column, value)
		if type == nil
			puts "token nil"
		end
		self.type = type
		self.line = line
		self.column = column
		self.value = value
		self.svalue = value
	end

	def getTokenId()
		return self.type
	end

	def to_s()
		# Let us hope what is in value can be shown as a proper String
		return self.type.to_s()
		+ " " + self.line
		+ " " + self.column
		+ " \"" + self.svalue + "\"";
	end
end
