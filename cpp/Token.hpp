#pragma once
#include "string"

class Token {

public:
	int type;
	int line;
	int column;
	void * value;
	std::string svalue;

	Token(int type, int line, int column, void * value);
	int get_token_id();
	std::string to_string();
};
