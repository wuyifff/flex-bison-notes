%option noyywrap
%{
#include <string.h>
    int chars = 0;
    int words = 0;
    int lines = 0;
%}
%%
[a-zA-Z]+   {words++; chars += strlen(yytext); }
\n          {chars++; lines++;}
.           {chars++; }
%%

int main(int argc, char **argv)
{
    //yylex()是flex提供的词法分析例程，默认读取stdin      
    yylex();                                                               
    printf("look, I find %d words of %d chars and %d lines\n", words, chars, lines);
    return 0;
}