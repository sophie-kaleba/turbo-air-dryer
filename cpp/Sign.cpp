#include <unordered_map>
#include <string>

#include "Sign.hpp"

const std:unordered_map<int, std::string> SIGN_HASH = {
	{shift_right_unsigned_assignment,	">>>="},
	{shift_right_unsigned,			 ">>>"},
	{strict_equal,				 "==="},
	{strict_not_equal,			 "!=="},
	{shift_left_assignment,			 "<<="},
	{shift_right_assignment,		 ">>="},
	{equal,					 "=="},
	{less_or_equal,				 "<="},
	{greater_or_equal,			 ">="},
	{not_equal,				 "!="},
	{increment,				 "++"},
	{decrement,				 "--"},
	{exponentiation,			 "**"},
	{shift_left,				 "<<"},
	{shift_right,				 ">>"},
	{logical_and,				 "&&"},
	{logical_xor,				 "^^"},
	{logical_or,				 "||"},
	{plus_assignment,			 "+="},
	{minus_assignment,			 "-="},
	{mul_assignment,			 "*="},
	{div_assignment,			 "/="},
	{mod_assignment,			 "%="},
	{and_assignment,			 "&="},
	{xor_assignment,			 "^="},
	{or_assignment,				 "|="},
	{not_assignment,			 "~="},
	{colon,					 ":"},
	{comma,					 ","},
	{semicolon,				 ";"},
	{full_stop,				 "."},
	{plus,					 "+"},
	{minus,					 "-"},
	{asterisk,				 "*"},
	{slash,					 "/"},
	{open_parenthesis,			 "("},
	{close_parenthesis,			 ")"},
	{open_bracket,				 "["},
	{close_bracket,				 "]"},
	{open_brace,				 "{"},
	{close_brace,				 "}"},
	{assignment,				 "="},
	{less_than,				 "<"},
	{greater_than,				 ">"},
	{ampersand,				 "&"},
	{pipe,					 "|"},
	{caret,					 "^"},
	{exclamation_mark,			 "!"},
	{question_mark,				 "?"},
	{percent,				 "%"},
	{tilde,					 "~"}
}

