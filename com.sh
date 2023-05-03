bison -d parser.y
flex skanner.y
gcc parser.tab.c lex.yy.c -lfl