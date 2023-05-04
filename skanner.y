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
apostrophe "'"
comment \(\*.*\*\)$
str '.*'

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
{apostrophe} {return APOSTROPHE;}
{str} {return STR;}
[ \t]   /* ignoruj spacje i tabulatory */
\n

{comment} {}/* ignorujemy komenrzarze */

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
do {return DO;}
else {return ELSE;}
begin {return BEGIN_BLOCK;}
end {return END;}
repeat {return REPEAT;}
until {return UNTIL;}
while {return WHILE;}
or {return OR;}
and {return AND;}
continue {return CONTINUE;}
break {return BREAK;}




[A-Za-z0-9]* { yylval.string=strdup(yytext);return WORD; }
%%