%{
#include <stdio.h>
#include <string.h>
int yyerror(); 

char program_name[100] = "";
int line_count = 1;
int var_count = 0;
int if_count = 0;
int while_count = 0;
int repeat_count = 0;
int uses_count = 0;
int functions_count = 0;
int procedures_count = 0;

int set_program_name(char name[100]){
    strcpy(program_name, name);
}

int add_uses(){
    uses_count++;
}

int add_var(){
    var_count++;
}

int add_function(){
    functions_count++;
}

int add_procedures(){
    procedures_count++;
}

%}
 
%union 
{
        int number;
        char *string;
}

%token PROGRAM_NAME STOP SEMICOLON USES VAR  COLON COMMA DOT COMMENT FUNCTION PROCEDURE IF THEN ELSE BEGIN_BLOCK END REPEAT UNTIL WHILE OPEN_BRACKETS CLOSE_BRACKETS
%token REAL_TYPE STRING_TYPE INTEGER_TYPE BOOLEAN_TYPE PLUS MINUS ASTERISK SLASH ASSIGNMENT EQUALITY_OPERATOR RELATIONAL_OPERATOR OR AND

%token <string> WORD;

%% 

program : 
    /* empty */
    | program_heading SEMICOLON blocks stop_block
    ;

types : 
    REAL_TYPE
    | STRING_TYPE
    | INTEGER_TYPE
    | BOOLEAN_TYPE

program_heading:
    PROGRAM_NAME WORD {set_program_name($2);}
    ;

blocks:
    uses_block variable_block function_or_procedure_block
    ;

uses_block:
    /* empty */
    | uses_list
    ;

uses_list:
    uses_declaration SEMICOLON uses_list
    | uses_declaration SEMICOLON
    ;

uses_declaration:
    USES WORD {add_uses();}
    ;

variable_block:
    /* empty */
    | VAR var_list
    ;

function_var:
    /*empty */
    | var_list
    ;

var_list:
    var_delcaration SEMICOLON var_list
    | var_delcaration
    ;

var_delcaration:
    var_name_list COLON types
    | WORD COLON types EQUALITY_OPERATOR WORD SEMICOLON
    ;

var_name_list:
    WORD COMMA var_name_list {add_var();}
    | WORD {add_var();}
    ;

function_or_procedure_block: 
    /* empty */
    |function_or_procedure_declaration SEMICOLON function_or_procedure_block
    ;

function_or_procedure_declaration:
    function_declaration {add_function();}
    | procedure_declaration {add_procedures();}

function_declaration:
    FUNCTION WORD OPEN_BRACKETS function_var CLOSE_BRACKETS COLON types SEMICOLON variable_block block
    ;

procedure_declaration:
    PROCEDURE WORD OPEN_BRACKETS function_var CLOSE_BRACKETS SEMICOLON variable_block block SEMICOLON
    ;

block: 
    BEGIN_BLOCK code_block END
    ;

code_block:
    /* empty */
    | state_list SEMICOLON code_block
    | state_list 
    ;

state_list:
    assignment_state
    | procedure_call_state
    | if_statement
    ;

assignment_state:
    WORD ASSIGNMENT WORD
    ;

procedure_call_state:
    WORD OPEN_BRACKETS CLOSE_BRACKETS
    ;

if_statement: 
    IF OPEN_BRACKETS expresion CLOSE_BRACKETS THEN code_block
    | IF OPEN_BRACKETS expresion CLOSE_BRACKETS THEN code_block ELSE code_block
    ;

expresion:
    | simple_expresion AND expresion
    | simple_expresion OR expresion
    | simple_expresion
    ;

simple_expresion:
    WORD RELATIONAL_OPERATOR WORD
    | WORD EQUALITY_OPERATOR WORD
    ;


stop_block:
    DOT {return 0;}
    ;
%% 
 
main()
{
 yyparse();
 printf("\nprogram_name %s\n", program_name);
 printf("Uses count %d\n", uses_count);
 printf("Var count %d\n", var_count);
}
 
int yyerror(char *s)
{
    printf("ERROR: %s\n", s);
}
