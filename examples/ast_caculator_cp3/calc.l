%option noyywrap yylineno

%{
#include "ast.h"
#include "calc.tab.h"
%}

/* 此处声明模式的公共部分，用于简化匹配模式的书写。*/
/* 浮点数指数部分 */
EXP ([Ee][-+]?[0-9]+)

%%
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" { return yytext[0]; }

[0-9]+"."[0-9]*{EXP}?|"."?[0-9]+{EXP}? { yylval.d = atof(yytext); return NUMBER; }

\n          { return EOL; }
"//".*\n
[ \t]       { /* 忽略空白字符 */}
.           { yyerror("Mystery character %c\n", *yytext); }
%%