require_relative 'TokenType'

class ValuedToken < TokenType
	#    private final int tokenId;
	attr_accessor :tokenId

	def initialize(tokenId)
		self.tokenId = tokenId
	end

	def getTokenId()
		return self.tokenId
	end

	def getTokenString()
		return ""
	end
end

VALUEDTOKEN_HASH = {
	Identifier: 129,
	Integer:   130,
	Float:     131,
	String:    132,
	Character: 133
}
