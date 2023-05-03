%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

%}

%%
[ \t]   /* ignoruj spacje i tabulatory */
\n   

program {return PROGRAM_NAME;}
stop {return STOP;}
uses {return USES;}
var {return VAR;}
Real {return VAR_TYPE;}

; {return SEMICOLON;}
: {return COLON;}
, {return COMMA;}
. {return DOT;}

[A-Za-z0-9]+ { yylval.string=strdup(yytext);return WORD; }

%%