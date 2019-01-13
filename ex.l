%{
	#include "y.tab.h"
	#include <string.h>
	#include <iostream>
	#include <stdio.h>

	
	
	int lineNo = 1;
	int colNo = 1;
%}

%%
"PROGRAM"			{colNo+=7; return TOKEN_PROGRAM;}
"VAR"				{colNo+=3; return TOKEN_VAR;}
"BEGIN"				{colNo+=5; return TOKEN_BEGIN;}
"END"				{colNo+=3; return TOKEN_END;}
":"				{colNo++; return TOKEN_COLON;}
"INTEGER"			{colNo+=7; return TOKEN_INTEGER;}
","				{colNo++; return TOKEN_COMMA;}
":="				{colNo+=2; return TOKEN_COLEQ;}
"+"				{colNo++; return TOKEN_PLUS; }
"-"				{colNo++; return TOKEN_MINUS; }
"*"				{colNo++; return TOKEN_MUL; }
"DIV"				{colNo+=3; return TOKEN_DIV; }
0|[1-9][0-9]*			{colNo+=strlen(yytext) ; yylloc.first_line=lineNo ; yylloc.first_column=colNo ; yylval.val=atoi(yytext) ; return TOKEN_INT;}
"("				{colNo++; return TOKEN_LBRACKET; }
")"				{colNo++; return TOKEN_RBRACKET; }
"READ"				{colNo+=4; return TOKEN_READ;}
"WRITE"				{colNo+=5; return TOKEN_WRITE;}
"FOR"				{colNo+3; return TOKEN_FOR;}
"DO"			        {colNo+=2; return TOKEN_DO;}
"TO"			        {colNo+=2; return TOKEN_TO;}
";"				{colNo++; return TOKEN_SEMICOLON; }
[a-z][a-z0-9]*          	{colNo+=strlen(yytext) ; yylloc.first_line=lineNo ; yylloc.first_column=colNo; yylval.sir=new char[strlen(yytext)+1] ; strcpy(yylval.sir,yytext) ; return TOKEN_ID;}
\.				{colNo++; return '.';}
" "				{}
\t				{}
\n				{colNo=1;lineNo++;}
.				{return TOKEN_ERROR;}
%%


