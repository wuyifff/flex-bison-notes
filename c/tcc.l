%option noyywrap yylineno

%{
#include <stdio.h>   
#include <stdlib.h>
#include <string.h>
#include "tcc.tab.h"
int old_status;
void yyerror(char *s, ...);

%}

%x COMMENT

%%
	/* 下面都是正则表达式 */
int         { return INT; }
float       { return FLOAT; }
double      { return DOUBLE; }
auto        { return AUTO; }
break       { return BREAK; }
case        { return CASE; }
const       { return CONST; }
else        { return ELSE; }
for         { return FOR; }
if          { return IF; }
long        { return LONG; }
return      { return RETURN; }
short       { return SHORT; }
signed      { return SIGNED; }
char        { return CHAR; }
unsigned    { return UNSIGNED; }
	
	/* 变量 */
[a-zA-Z][a-zA-Z0-9_]*       { yylval.strval = strdup(yytext); return IDENTITY; }

	/* 整数 */
-?[0-9]+                    { yylval.intval = atoi(yytext); return INT_NUMBER; }
-?[0-9]+\.[0-9]+            { yylval.floatval = atof(yytext); return FLOAT_NUMBER; }

	/* 字符串 */
\"(\\.|\"\"|[^"\n"])*\"     { yylval.strval = strdup(yytext); return STRING; }

	/* 错误字符 */
\"(\\.|[^"\n])*$            { yyerror("Unterminated string %s", yytext); }

    /* 操作符 */
[-+&~|^/%*(),.;!]       { return yytext[0]; }
"&&"                    { return AND; }
"||"                    { return OR; }
"="                     { return ASSIGN; }

    /* 注释 */
"//".*;
"/*"                    { old_status = YY_START; BEGIN COMMENT; }
<COMMENT>"*/"           { BEGIN old_status; }

	/* 空格 */
[ \t\n]

	/* 错误处理 */
.           { yyerror("something goes wrong...\n"); }

%%
