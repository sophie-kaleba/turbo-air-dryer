require_relative 'Sign'
require_relative 'While'
require_relative 'Keyword'
require_relative 'Return'
require_relative 'PrefixOp'
require_relative 'BinaryOp'
require_relative 'Function'
require_relative 'IfThenElse'
require_relative 'PostfixOp'
require_relative 'ValuedToken'
require_relative 'ExpressionStmt'
require_relative 'Token'
require_relative 'Var'
require_relative 'Call'
require_relative 'Literal'

class Unserializer
	#	InputStream input
	#	Map<Integer,TokenType> tokenTable
	attr_accessor :input, :tokenTable

	def initialize(input)
		self.input = input

		# Initialise our tokentype table
		self.tokenTable = SIGN_HASH.invert
		self.tokenTable.merge!(KEYWORD_HASH.invert)
		self.tokenTable.merge!(VALUEDTOKEN_HASH.invert)
	end

	def read8()
		res = self.input.read(1)
		if (res == nil)
			raise "End of file"
		end
		return res.ord
	end

	def read16()
		fst = self.read8()
		snd = self.read8()
		return fst << 8 | snd
	end

	def read32()
		fst = self.read16()
		snd = self.read16()
		return fst << 16 | snd
	end

	# Read one token
	# The TokenType of the result might be null if we read an unknown
	# token type
	def readToken()
		tmp = self.read8()
		type = self.tokenTable[tmp]
		line       = self.read16()
		col        = self.read16()
		len        = self.read16()

		value = self.input.read(len)

		raise "Ruby is not safe with IO" if value.length != len

		return Token.new(type, line, col, value)
	end

	# Is it easy to share the readXList methods?
	def  readTokenList()
		len = self.read32()
		toks = Array.new
		while(len > 0)
			len -= 1
			toks.push(readToken())
		end
		return toks
	end

	def readExpression(nodeId = nil)
		#	Token tok
		#	List<Token> toks
		#	Expression expr1, expr2, expr3
		#	List<Expression> exprs
		#	List<Statement>  stmts

		case(nodeId)
		when 0
			tok = self.readToken()
			return Literal.new(tok)
		when 1
			tok = self.readToken()
			expr1 = self.readExpression()
			return PrefixOp.new(tok, expr1)
		when 2
			tok = self.readToken()
			expr1 = self.readExpression()
			return PostfixOp.new(tok, expr1)
		when 3
			tok = self.readToken()
			expr1 = self.readExpression()
			expr2 = self.readExpression()
			return BinaryOp.new(tok, expr1, expr2)
		when 4
			expr1 = self.readExpression()
			exprs = self.readExpressionList()
			return Call.new(expr1, exprs)
		when 5
			tok = self.readToken()
			toks = self.readTokenList()
			stmts = self.readStatementList()
			return Function.new(tok, toks, stmts)
		when 6
			toks = self.readTokenList()
			stmts = self.readStatementList()
			return Function.new(nil, toks, stmts)
		when 7
			expr1 = self.readExpression()
			expr2 = self.readExpression()
			expr3 = self.readExpression()
			return Ternary.new(expr1, expr2, expr3)
		when nil
			nodeId = self.read8()
			return readExpression(nodeId)
		end
		raise "Unknown node Id: " + nodeId.to_s
	end

	def readExpressionList()
		len = self.read32()
		exprs = Array.new
		while(len > 0)
			len -= 1
			exprs.push(readExpression())
		end
		return exprs
	end

	def readStatement()
		#		int nodeId = self.read8()
		#		Token tok
		#		Expression expr
		#		List<Statement>  body1,body2
		#		Statement res
		nodeId = self.read8()
		#		tok
		#		expr
		body1 = Array.new
		body2 = Array.new
		#		res

		case(nodeId)
		when 16
			tok = self.readToken()
			res = Var.new(tok)
		when 17
			tok = self.readToken()
			expr = self.readExpression()
			res = Var.new(tok, expr)
		when 18
			res = Return.new()
		when 19
			expr = self.readExpression()
			res = Return.new(expr)
		when 20
			expr = self.readExpression()
			body1 = self.readStatementList()
			body2 = self.readStatementList()
			res = IfThenElse.new(expr, body1, body2)
		when 21
			expr = self.readExpression()
			body1 = self.readStatementList()
			res = While.new(expr, body1)
		else
			# Otherwise, it should be an expression
			expr = self.readExpression(nodeId)
			res = ExpressionStmt.new(expr)
		end

		return res
	end

	def readStatementList()
		len = self.read32()
		stmts = Array.new
		while(len > 0)
			len -= 1
			stmts.push(readStatement())
		end
		return stmts
	end

end

#unserializer =  Unserializer.new(STDIN)
#body = unserializer.readStatementList()
#for st in body
#	puts st.to_s()
#end
