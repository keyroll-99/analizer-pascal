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
    line_count++;
}

int add_var(){
    var_count++;
    line_count++;
}

int add_function(){
    functions_count++;
    line_count++;
}

int add_procedures(){
    procedures_count++;
    line_count++;
}

int add_if(){
    if_count++;
    line_count++;
}

int add_while(){
    while_count++;
    line_count++;
}

int add_repeat(){
    repeat_count++;
    line_count++;
}

int add_line(){
    line_count++;
}

%}
 
%union 
{
        int number;
        char *string;
}

%token PROGRAM_NAME STOP SEMICOLON USES VAR  COLON COMMA DOT COMMENT FUNCTION PROCEDURE IF THEN ELSE BEGIN_BLOCK END REPEAT UNTIL WHILE OPEN_BRACKETS CLOSE_BRACKETS
%token REAL_TYPE STRING_TYPE INTEGER_TYPE BOOLEAN_TYPE PLUS MINUS ASTERISK SLASH ASSIGNMENT EQUALITY_OPERATOR RELATIONAL_OPERATOR OR AND DO CONTINUE BREAK APOSTROPHE STR

%token <string> WORD;

%% 

program : 
    /* empty */
    | program_heading SEMICOLON blocks
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
    uses_block variable_block function_or_procedure_block main_block
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

function_argument_list:
    /* empty */
    | function_argument_declaration SEMICOLON function_argument_list
    | function_argument_declaration

function_argument_declaration:
    argument_name COLON types {add_line();}

argument_name:
    WORD COMMA var_name_list 
    |WORD 
    ;

var_list:
    var_declaration SEMICOLON var_list
    | var_declaration SEMICOLON
    ;

var_declaration:
    var_name_list COLON types {add_var();}
    ;

var_name_list:
    WORD COMMA var_name_list 
    |WORD 
    ;

function_or_procedure_block: 
    /* empty */
    |function_or_procedure_declaration SEMICOLON function_or_procedure_block
    ;

function_or_procedure_declaration:
    function_declaration {add_function();}
    | procedure_declaration {add_procedures();}

function_declaration:
    FUNCTION WORD OPEN_BRACKETS function_argument_list CLOSE_BRACKETS COLON types SEMICOLON function_var block
    ;

procedure_declaration:
    PROCEDURE WORD OPEN_BRACKETS function_argument_list CLOSE_BRACKETS SEMICOLON function_var block SEMICOLON
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
    assignment_state {add_line();}
    | procedure_call_state {add_line();}
    | if_statement {add_if();}
    | while_statement {add_while();}
    | repeat_statement {add_repeat();}
    ;

assignment_state:
    | WORD ASSIGNMENT WORD
    | WORD ASSIGNMENT operation
    | WORD ASSIGNMENT STR
    ;

operation: 
    WORD RELATIONAL_OPERATOR WORD
    | WORD PLUS WORD
    | WORD MINUS WORD
    | WORD ASTERISK WORD
    | WORD SLASH WORD
    | WORD RELATIONAL_OPERATOR combinante_operation
    | combinante_operation RELATIONAL_OPERATOR WORD
    | combinante_operation RELATIONAL_OPERATOR combinante_operation
    | WORD PLUS combinante_operation
    | combinante_operation PLUS WORD
    | combinante_operation PLUS combinante_operation
    | WORD MINUS combinante_operation
    | combinante_operation MINUS WORD
    | combinante_operation MINUS combinante_operation
    | WORD ASTERISK combinante_operation
    | combinante_operation ASTERISK WORD
    | combinante_operation ASTERISK combinante_operation
    | WORD SLASH combinante_operation
    | combinante_operation SLASH WORD
    | combinante_operation SLASH combinante_operation
    ;
 
combinante_operation:
    OPEN_BRACKETS operation CLOSE_BRACKETS

procedure_call_state:
    WORD OPEN_BRACKETS procedure_argument CLOSE_BRACKETS
    ;

procedure_argument:
    /* empty */
    | WORD COMMA procedure_argument
    | STR COMMA procedure_argument
    | expresion COMMA procedure_argument
    | expresion
    | STR
    | WORD
    

if_statement: 
    IF OPEN_BRACKETS expresion CLOSE_BRACKETS THEN code_block {add_line();}
    | IF OPEN_BRACKETS expresion CLOSE_BRACKETS THEN code_block ELSE code_block {add_line();}
    ;

while_statement:
    WHILE expresion DO BEGIN_BLOCK code_block END SEMICOLON

repeat_statement:
    REPEAT code_block UNTIL expresion SEMICOLON
    ;

expresion:
    | simple_expresion AND expresion
    | simple_expresion OR expresion
    | simple_expresion
    ;

simple_expresion:
    operation
    | WORD EQUALITY_OPERATOR WORD
    ;



main_block:
    BEGIN_BLOCK code_block END DOT {add_line(); add_line(); return 0;}
    ;

%% 
 
main()
{
 yyparse();
 printf("\nprogram_name %s\n", program_name);
 printf("Uses count %d\n", uses_count);
 printf("Var count %d\n", var_count);
 printf("If count %d\n", if_count);
 printf("While count %d\n", while_count);
 printf("Reapt count %d\n", repeat_count);
 printf("Line count %d\n", line_count);
 printf("Procedure count %d\n", procedures_count);
 printf("Function count %d\n", functions_count);
}
 
int yyerror(char *s)
{
    printf("ERROR: %s\n", s);
}
