#include <unordered_map>
#include <string>

#include "Keyword.hpp"

const std:unordered_map<int, std::string> KEYWORD_HASH = {
	{Function,	 "function"},
	{Return,	 "return"},
	{Var,		 "var"},
	{If,		 "if"},
	{Else,		 "else"},
	{While,		 "while"},
	{For,		 "for"},
	{Break,		 "break"},
	{Case,		 "case"},
	{Catch,		 "catch"},
	{Continue,	 "continue"},
	{Debugger,	 "debugger"},
	{Default,	 "default"},
	{Delete,	 "delete"},
	{Do,		 "do"},
	{False,		 "false"},
	{Finally,	 "finally"},
	{In,		 "in"},
	{InstanceOf,	 "instanceof"},
	{New,		 "new"},
	{Null,		 "null"},
	{Switch,	 "switch"},
	{This,		 "this"},
	{Throw,		 "throw"},
	{True,		 "true"},
	{Try,		 "try"},
	{TypeOf,	 "typeof"},
	{Void,		 "void"},
	{With,		 "with"},
}
