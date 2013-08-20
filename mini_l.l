/*
 * Description: Identify Tokens in a Source File
 *
 */
                 #define _POSIX_SOURCE 1
                 #define YY_NO_UNPUT
                 #include <string.h> 
                 #include "tok.h"

digit            [0-9]
alpha            [a-zA-Z]
ident            ({alpha}({alpha}|{digit}|"_")*({alpha}|{digit}))|{alpha}
num_ident        ({digit})+({alpha}|{digit}|"_")*({alpha}|"_")+({alpha}|{digit}|"_")*
und_ident        "_"({alpha}|{digit}|"_")*
bad_ident        {num_ident}|{und_ident}
ident_und        {ident}"_"
whitespace       [ \t]+
comment          "--"+.*"\n"
number           {digit}*
                 int num_lines=0;
                 int curr_chars=0;

%%
{comment}        { /* Do Nothing */ }

"program"        { curr_chars=0;
                   return T_PROG; }

"beginprogram"   { curr_chars=0; 
                   return T_BPROG; }

"endprogram"     { curr_chars=0; 
                   return T_EPROG; }

"integer"        { curr_chars+=7; 
                   return T_INT; }

"array"          { curr_chars+=5; 
                   return T_ARR; }

"of"             { curr_chars+=2; 
                   return T_OF; }

"if"             { curr_chars+=2; 
                   return T_IF; }

"then"           { curr_chars+=4; 
                   return T_THEN; }

"endif"          { curr_chars+=5; 
                   return T_EIF; }

"else"           { curr_chars+=4; 
                   return T_ELSE; }

"while"          { curr_chars+=5;
                   return T_WHILE; }

"loop"           { curr_chars+=4; 
                   return T_LOOP; }

"endloop"        { curr_chars+=7; 
                   return T_ELOOP; }

"read"           { curr_chars+=4; 
                   return T_READ; }

"write"          { curr_chars+=5; 
                   return T_WRITE; }

"and"            { curr_chars+=3; 
                   return T_AND; }

"or"             { curr_chars+=2; 
                   return T_OR; }

"not"            { curr_chars+=3; 
                   return T_NOT; }

"true"           { curr_chars+=4; 
                   return T_TRUE; }

"false"          { curr_chars+=5; 
                   return T_FALSE; }

"+"              { curr_chars+=1; 
                   return T_ADD; }

"*"              { curr_chars+=1; 
                   return T_MULT; }

"/"              { curr_chars+=1; 
                   return T_DIV; }

":="             { curr_chars+=2; 
                   return T_ASSIGN; }

"="              { curr_chars+=1; 
                   return T_EQ; }

"<>"             { curr_chars+=2; 
                   return T_NEQ; }

"<"              { curr_chars+=1; 
                   return T_LT; }

">"              { curr_chars+=1; 
                   return T_GT; }

"<="             { curr_chars+=2; 
                   return T_LTE; }

">="             { curr_chars+=2; 
                   return T_GTE; }

"("              { curr_chars+=7; 
                   return T_LPAR; }

")"              { curr_chars+=1; 
                   return T_RPAR; }

","              { curr_chars+=1; 
                   return T_COMMA; }

";"              { curr_chars+=1; 
                   return T_SEMI; }

":"              { curr_chars+=1; 
                   return T_COLON; }

"-"              { curr_chars+=1; 
                   return T_SUB; }

{ident}          { curr_chars+=strlen(yytext); 
                   yylval.str_val=yytext; 
                   return T_ID; }

{bad_ident}      printf("Error at line %i, column 0: identifier \"%s\" must begin with a letter\n",num_lines+1, yytext);

{ident_und}      printf("Error at line %i, column 0: identifier \"%s\" cannot end with an underscore\n", num_lines+1, yytext);

{number}         { curr_chars+=strlen(yytext);
                   yylval.int_val=atoi(yytext);
                   return T_NUM; }

{whitespace}     curr_chars+=strlen(yytext);

"\n"             ++num_lines; curr_chars=0;

.                printf("Error at line %i column %i: unrecognized symbol \"%c\"\n",num_lines+1, curr_chars+1, yytext[0]);


%%

/* int main() {
  yylex();
  return 0;
} */
