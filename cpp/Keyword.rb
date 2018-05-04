class Keyword < TokenType
	attr_accessor :tokenId, :tokenString

	def initialize (tokenId, tokenString)
		self.tokenId     = tokenId;
		self.tokenString = tokenString;
	end
end

KEYWORD_HASH = {
	Function: 65,
	Return: 66,
	Var: 67,
	If: 68,
	Else: 69,
	While: 70,
	For: 71,
	Break: 72,
	Case: 73,
	Catch: 74,
	Continue: 75,
	Debugger: 76,
	Default: 77,
	Delete: 78,
	Do: 79,
	False: 80,
	Finally: 81,
	In: 82,
	InstanceOf: 83,
	New: 84,
	Null: 85,
	Switch: 86,
	This: 87,
	Throw: 88,
	True: 89,
	Try: 90,
	TypeOf: 91,
	Void: 92,
	With: 93
}

KEYWORD_HASH_DEBUG = {
	Function: "function",
	Return: "return",
	Var: "var",
	If: "if",
	Else: "else",
	While: "while",
	For: "for",
	Break: "break",
	Case: "case",
	Catch: "catch",
	Continue: "continue",
	Debugger: "debugger",
	Default: "default",
	Delete: "delete",
	Do: "do",
	False: "false",
	Finally: "finally",
	In: "in",
	InstanceOf: "instanceof",
	New: "new",
	Null: "null",
	Switch: "switch",
	This: "this",
	Throw: "throw",
	True: "true",
	Try: "try",
	TypeOf: "typeof",
	Void: "void",
	With: "with"
}
