%option noyywrap
%{
#include <stdio.h>
#include <string.h>
    int chars = 0;
    int words = 0;
    int lines = 0;
%}
%%
[^ \t\n\r\f\v]+ { words++; chars += strlen(yytext);}
"\n"    { lines++;}
%%

int main(int argc, char **argv)
{
    //yylex()是flex提供的词法分析例程，默认读取stdin
    if(argc > 1) {
        if( !(yyin = fopen(argv[1], "r") ) ) {
            perror(argv[1]);
            return -1;
        }
    }      
    yylex();                                                               
    printf("look, I find %d words of %d chars and %d lines\n", words, chars, lines);
    return 0;
}