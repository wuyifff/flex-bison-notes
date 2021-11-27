/* 计算器代码 */
%option noyywrap
%{
    #include "calc.tab.h"
%}

%%
"+"     { return ADD; }
"-"     { return SUB; }
"*"     { return MUL; }
"/"     { return DIV; }
"|"     { return ABS; }
[0-9]+  { yylval = atoi(yytext); return NUMBER; }
\n      { return EOL; }
[ \t]    { }
.       { yyerror("Mystery character: !");}
"("     { return OP; }
")"     { return CP; }
"//".* { }
%%

/* int main(int argc, char **argv)
{
    int tok;
    while(tok = yylex() ) {
        printf("%d", tok);
        if(tok == NUMBER)
            printf(" = %d\n", yylval);
        else printf("\n");
    }
} */