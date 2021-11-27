# Flex

## 注意

gcc 编译需要 `-lfl` 选项，这在windows里没有

解决方案是添加

```
%option noyywrap
```

到你的flex输入文件。 （这会阻止它生成一个调用`yywrap`的扫描程序，因此您不需要`yywrap`中的`libfl`。）

## 第一个程序 字数统计

```c
%option noyywrap
%{
#include <string.h>
int chars = 0;int words = 0;int lines = 0;
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
```

核心部分也可改写为：

```c
[^ \t\n\r\f\v]+ { words++; chars += strlen(yytext);}
"\n"    { lines++;}
```

## flex分析

flex程序包含三个部分，**各部分之间通过仅有%%的行来分割**。第一个部分包含声明和选项设置，第二个部分是一系列的模式和动作，第三部分则是会被拷贝到生成的词法分析器里面的C代码，它们通常是一些与动作代码相关的例程。
在声明部分，**%{和%}之间的代码会被原样照抄到生成的C文件的开头部分**。在这个例子里面，它只是用来设定了行数、单词数和字符数的变量。
在第二部分，每个模式处在一行的开头处，接着是模式匹配时所需要执行的C代码。这儿的C代码是用括住的一行或者多行语句。**（模式必须在行首出现，因为flex认为以空白开始的行都是代码而把它们照抄到生成的C程序中。)**
这个程序只有三个模式。第一个模式，[a-zA-Z]+，用来匹配一个单词。在方括号里面的字符串是一种字符类(character class)，能够匹配任意一个大小写字母，而+这个符号表示匹配一个或者多个前面的字符类，也就是一连串的字母，或者说一个单词。相关的动作更新匹配过的单词和字符的个数。**在任意一个flex的动作中，变量yytext总是被设为指向本次匹配的输入文本。**在这个例子里，我们所需要关心的是有多少个字符，因此我们可以借助这个变量来统计字符数。

![image-20211126235939155](https://i.loli.net/2021/11/26/oeWtx2GMlvXkJQb.png)

## 计算器代码

```C
/* 计算器代码 */
%option noyywrap
%{
    #include <stdio.h>
    enum yytokentype{
        NUMBER = 258,
        ADD = 259,
        SUB = 260,
        MUL = 261,
        DIV = 262,
        ABS = 263,
        EOL = 264,
    };
    int yylval;    
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
.       { printf("Mystery character %c\n", *yytext);}
%%

int main(int argc, char **argv)
{
    int tok;
    while(tok = yylex() ) {
        printf("%d", tok);
        if(tok == NUMBER)
            printf(" = %d\n", yylval);
        else printf("\n");
    }
}
```

出于测试的目的，主程序将调用yylex()，打印出记号值，并且对于Number记号，也会输出yylval。

# Bison

