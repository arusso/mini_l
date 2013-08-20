%{ /* C Declarations */
  #include <stdio.h>

  int yyerror(char *s);
  int yylex(void);

%}

  /* Bison Declarations */
%union{
    int      int_val;
    char*    str_val;
};
 
  %start nt_program
 
  /* Value Tokens */
  %token <int_val>  T_NUM
  %token <str_val>  T_ID

  /* Program Keywords */
  %token T_BPROG T_EPROG

  /* Types */
  %token T_INT T_ARR T_OF

  /* Loops and If/Else */
  %token T_IF T_THEN T_ELSE T_EIF
  %token T_WHILE T_LOOP T_ELOOP

  /* Read/Write */
  %token T_READ T_WRITE

  /* Binary Operators, True/False */
  %token T_AND T_OR T_NOT
  %token T_TRUE T_FALSE
  
  /* Integer Operators */
  %token T_ADD T_SUB T_MULT T_DIV
  
  /* Comparative/Assignment Operators */
  %token T_ASSIGN T_EQ T_NEQ
  %token T_GTE T_LTE T_LT T_GT

  %token T_LPAR T_RPAR T_COMMA T_COLON
  %token T_SEMI

  %left MINUS PLUS
  %left DIV MULT

%%

/* Grammer Rules */
nt_program:  

  prog ident semi nt_blk endprog   
  { printf("nt_program -> prog ident semi nt_blk endprog\n") }
;

nt_blk:

  nt_dec_loop begprog nt_stmt_loop
  { printf("nt_blk -> nt_dec_loop begprog nt_stmt_loop\n") }
;

nt_dec:

  nt_id_loop int
  { printf("nt_dec -> nt_id_loop int\n") }
|
  nt_id_loop array lpar num rpar of int
  { printf("nt_dec -> nt_id_loop array lpar num rpar of int\n") }
;

nt_dec_loop:                       
  
  nt_dec semi nt_dec_loop 
  { printf("nt_dec_loop -> nt_dec semi nt_dec_loop\n") }
|
  nt_dec semi
  { printf("nt_dec_loop -> nt_dec semi\n") }
;

nt_stmt:
  
  nt_var assign nt_exp             
    { printf("nt_stmt -> nt_var assign nt_exp\n") }
|
  if nt_bool_exp then nt_stmt_loop nt_stmt_else_branch endif  
    { printf("nt_stmt -> if nt_bool_exp then nt_stmt_loop nt_stmt_else_branch endif\n") }
|
  while nt_bool_exp loop nt_stmt_loop endloop   
  { printf("nt_stmt -> while nt_bool_exp loop nt_stmt_loop endloop\n") }
|
  read nt_var_loop
  { printf("nt_stmt -> T_READ nt_var_loop\n") }
| 
  write nt_var_loop
  { printf("nt_stmt -> T_WRITE nt_var_loop\n") }
;

nt_stmt_loop:
  
  nt_stmt semi nt_stmt_loop 
  { printf( "nt_stmt_loop -> nt_stmt semi nt_stmt_loop\n") }
|
  nt_stmt semi 
  { printf("nt_stmt_loop -> nt_stmt semi\n") }
;

nt_stmt_else_branch:
  /* Epsilon */ 
  { printf("nt_stmt_else_branch ->\n") }
|
  else nt_stmt_loop 
  { printf("nt_stmt_else_branch -> else nt_stmt_loop\n") }
;

nt_id_loop:
  
  ident comma nt_id_loop 
  { printf("nt_id_loop -> ident comma nt_id_loop\n") }
|
  ident colon 
  { printf("nt_id_loop -> ident colon\n") }
;

nt_bool_exp:

  nt_rel_exp nt_rel_exp_loop 
  { printf("nt_bool_exp -> nt_rel_exp nt_rel_exp_loop\n") }
;

nt_rel_exp:
  nt_not_or_no_not nt_exp nt_comp nt_exp 
  { printf("nt_rel_exp -> nt_not_or_no_not nt_exp nt_comp nt_exp\n") }
|
  nt_not_or_no_not true 
  { printf("nt_rel_exp -> nt_not_or_no_not true\n") }
|
  nt_not_or_no_not false 
  { printf("nt_rel_exp -> nt_not_or_no_not false\n") }
;

nt_not_or_no_not:

  /* Epsilon */ 
  { printf("nt_not_or_no_not ->\n") }
|
  not 
  { printf("nt_not_or_no_not -> not\n") }
;

nt_rel_exp_loop:

  /* Epsilon */ 
  { printf("nt_rel_exp_loop ->\n") }
|
  or nt_rel_exp nt_rel_exp_loop 
  { printf("nt_rel_exp_loop -> or nt_rel_exp nt_rel_exp_loop\n") }
|
  and nt_rel_exp nt_rel_exp_loop 
  { printf("nt_rel_exp_loop -> and nt_rel_exp nt_rel_exp_loop\n"); }
;

nt_comp:

  eq 
  { printf("nt_comp -> eq\n"); }
|
  neq 
  { printf("nt_comp -> neq\n"); }
|
  lt 
  { printf("nt_comp -> lt\n"); }
|
  gt 
  { printf("nt_comp -> gt\n"); }
|
  lte 
  { printf("nt_comp -> lte\n"); }
|
  gte 
  { printf("nt_comp -> gte\n"); }
;

nt_exp:

  sub nt_term nt_term_loop 
  { printf("nt_exp -> sub nt_term nt_term_loop\n"); }
;

nt_term:

  nt_factor nt_factor_loop 
  { printf("nt_term -> nt_factor nt_factor_loop\n"); }
;

nt_term_loop:

  /* Epsilon */ 
  { printf("nt_term_loop ->\n"); }
|
  add nt_term nt_term_loop { printf("nt_term_loop -> add nt_term nt_term_loop\n"); }
|
  sub nt_term nt_term_loop { printf("nt_term_loop -> sub nt_term nt_term_loop\n"); }
;  

nt_factor:
  
  nt_var 
  { printf("nt_factor -> nt_var\n"); }
|
  num 
  { printf("nt_factor -> num\n"); }
|
  lpar nt_exp rpar { printf("nt_factor -> lpar nt_exp rpar\n"); }
;

nt_factor_loop:

  /* Epsilon */ { printf("nt_factor_loop ->\n"); }
|
  mult nt_factor { printf("nt_factor_loop -> mult nt_factor\n"); }
|
  div nt_factor { printf("nt_factor_loop -> div nt_factor\n"); }
;

nt_var:
  
  ident { printf("nt_var -> ident\n"); }
|
  ident lpar nt_exp rpar { printf("nt_var -> ident lpar nt_exp rpar\n"); }
;

nt_var_loop:

  nt_var comma nt_var_loop { printf("nt_var_loop -> nt_var comma nt_var_loop\n"); }
|
  nt_var { printf("nt_var_loop -> nt_var\n"); }

;

/* Section to make terminals print */
prog:
  T_PROG { printf("program -> T_PROG\n"); }
;

ident:
  T_ID { printf("ident -> T_ID (%s)\n", $1); }
;  

lpar:
  T_LPAR { printf("lpar -> T_LPAR\n"); }
;

rpar:
  T_RPAR { printf("rpar -> T_RPAR\n"); }
;

comma:
  T_COMMA { printf("comma -> T_COMMA\n"); }
;

colon:
  T_COLON { printf("colon -> T_COLON\n"); }
;

semi:
  T_SEMI { printf("semi -> T_SEMI\n"); }
;

endprog:
  T_EPROG { printf("endprog -> T_EPROG\n"); }
;

begprog:
  T_BPROG { printf("begprog -> T_BPROG\n"); }
;

int:
  T_INT { printf("int -> T_INT\n"); }
;

num:
  T_NUM { printf("num -> T_NUM (%i)\n", $1); }
;

array:
  T_ARR { printf("array -> T_ARR\n"); }
;

of:
  T_OF { printf("of -> T_OF\n"); }
;

assign:
  T_ASSIGN { printf("assign -> T_ASSIGN\n"); }
;

if:
  T_IF { printf("if -> T_IF\n"); }
;

then:
  T_THEN { printf("then -> T_THEN\n"); }
;

else:
  T_ELSE { printf("else -> T_ELSE\n"); }

endif:
  T_ENDIF { printf("endif -> T_ENDIF\n"); }
;

while:
  T_WHILE { printf("while -> T_WHILE\n"); }
;

loop:
  T_LOOP { printf("loop -> T_LOOP\n"); }
;

endloop:
  T_ELOOP { printf("endloop -> T_ELOOP\n"); }
;

read:
  T_READ { printf("read -> T_READ\n"); }
;

write:
  T_WRITE { printf("write -> T_WRITE\n"); }
;

true:
  T_TRUE { printf("true -> T_TRUE\n"); }
;

false:
  T_FALSE { printf("false -> T_FALSE\n"); }
;

not:
  T_NOT { printf("not -> T_NOT\n"); }
;

or:
  T_OR { printf("or -> T_OR\n"); }
;

and:
  T_AND { printf("and -> T_AND\n"); }
;

eq:
  T_EQ { printf("eq -> T_EQ\n"); }
;

neq:
  T_NEQ { printf("neq -> T_NEQ\n"); }
;

lt:
  T_LT { printf("lt -> T_LT\n"); }
;

gt:
  T_GT { printf("gt -> T_GT\n"); }
;

lte:
  T_LTE { printf("lte -> T_LTE\n"); }
;

gte:
  T_GTE { printf("gte -> T_GTE\n"); }
;

add:
  T_ADD { printf("add -> T_ADD\n"); }
;

mult:
  T_MULT { printf("mult -> T_MULT\n"); }
;

sub:
  T_SUB { printf("sub -> T_SUB\n"); }
;

div:
  T_DIV { printf("div -> T_DIV\n"); }
;


%%

  /* Additional C Code */

int yyerror(char *s) {
  extern int num_lines;	/* defined and maintained in lex.c */
  extern char *yytext;	/* defined and maintained in lex.c */
  
  printf("ERROR: %s at symbol \"%s\" on line %i\n", s, yytext, num_lines);
  return 1;
}

int yyparse();

int main() {
  yyparse();
  return 0;
}
