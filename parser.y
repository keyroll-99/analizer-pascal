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

int set_program_name(char name[100]){
    strcpy(program_name, name);
}

int add_uses(){
    uses_count++;
}

int add_var(){
    var_count++;
}

%}
 
%union 
{
        int number;
        char *string;
}

%token PROGRAM_NAME STOP SEMICOLON USES VAR VAR_TYPE COLON COMMA DOT

%token <string> WORD;

%% 

program : 
    /* empty */
    | program_heading SEMICOLON blocks stop_block
    ;

program_heading:
    PROGRAM_NAME WORD {set_program_name($2);}
    ;

blocks:
    uses_block variable_block
    ;

uses_block:
    /* empty */
    | uses_list

uses_list:
    uses_declaration SEMICOLON uses_list
    | uses_declaration SEMICOLON

uses_declaration:
    USES WORD {add_uses();}

variable_block:
    /* empty */
    | VAR var_list

var_list:
    var_delcaration SEMICOLON var_list
    | var_delcaration

var_delcaration:
    var_name_list COLON VAR_TYPE

var_name_list:
    WORD COMMA var_name_list {add_var();}
    | WORD {add_var();}

stop_block:
    DOT {return 0;}

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
