calc: calc.l calc.y
	bison -d calc.y
	flex calc.l
	gcc  calc.tab.h calc.tab.c lex.yy.c -o calc