%{
#include "parser.tab.h"
#include <stdlib.h>
#include <string.h>

%}

open_brackets "\("
close_brackets "\)"
add_symbol "+"
minus_symbol "-"
asterisk_symbol "*"
slash_symbol "/"
equal_symol "="
not_equal_symbol "<>"
less_equal_symbol "<="
more_equal_symbol ">="
less_symbol \<
more_symbol \>


%%

{less_symbol}     { return RELATIONAL_OPERATOR; }
{more_symbol}     { return RELATIONAL_OPERATOR; }
{open_brackets} {return OPEN_BRACKETS;}
{close_brackets} {return CLOSE_BRACKETS;}
{add_symbol} {return PLUS;}
{minus_symbol} {return MINUS;}
{asterisk_symbol} {return ASTERISK;}
{slash_symbol} {return SLASH;}
{equal_symol}     { return EQUALITY_OPERATOR; }


[ \t]   /* ignoruj spacje i tabulatory */
\n   

; {return SEMICOLON;}
: {return COLON;}
, {return COMMA;}
. {return DOT;}


:= {return ASSIGNMENT;}


{not_equal_symbol}    { return RELATIONAL_OPERATOR; }
{less_equal_symbol}    { return RELATIONAL_OPERATOR; }
{more_equal_symbol}    { return RELATIONAL_OPERATOR; }





program {return PROGRAM_NAME;}
stop {return STOP;}
uses {return USES;}
var {return VAR;}
Real {return REAL_TYPE;}
String {return STRING_TYPE;}
Integer {return INTEGER_TYPE;}
Boolean {return BOOLEAN_TYPE;}
function {return FUNCTION;}
procedure {return PROCEDURE;}
if {return IF;}
then {return THEN;}
else {return ELSE;}
begin {return BEGIN_BLOCK;}
end {return END;}
repeat {return REPEAT;}
until {return UNTIL;}
while {return WHILE;}
or {return OR;}
and {return AND;}




[A-Za-z0-9]+ { yylval.string=strdup(yytext);return WORD; }

%%