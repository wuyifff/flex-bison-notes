bison -d tcc.y
flex tcc.l
gcc lex.yy.c tcc.tab.c -o test
.\test.exe
