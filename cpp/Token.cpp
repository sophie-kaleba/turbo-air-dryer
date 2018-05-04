#include "Token.hpp"
#include <stdio.h>

Token::Token(int type, int line, int column, void * value) {

		if (type == 0) 
			fprintf(stderr,"null token\n");

		type = type;
		line = line;
		column = column;
		value = value;
		svalue = (char *) value;
}


int Token::get_token_id() {
	return type;
}

std::string Token::to_string(){
	/* Let us hope what is in value can be shown as a proper String */
	std::string s = "";
	s += std::to_string(type) +" "+ std::to_string(line) +" "+ std::to_string(column)+ " " + svalue;
	return s;
}
	
