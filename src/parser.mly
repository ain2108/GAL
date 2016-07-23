%{
    open Ast
%}

%token SEMI LPAREN RPAREN LSQBRACE RSQBRACE LBRACE RBRACE BAR COLON LISTSEP COMMA
%token EPLUS EMINUS PLUS MINUS TIMES DIVIDE ASSIGN NOT 
%token EQ LT LEQ GT GEQ AND OR 
%token RETURN IF ELSE FOR INT STRING EDGE LISTT DEFINE WHILE
%token <int> LITINT
%token <string> ID
%token <string> LITSTR
%token EOF


%right ASSIGN
%left OR
%left AND
%left EQ 
%left LT GT LEQ GEQ
%left PLUS MINUS EPLUS EMINUS
%left TIMES DIVIDE
%right NOT  

%start program
%type <Ast.program> program 

%%

program: decls EOF { $1 } 

decls: /*nothing */ {[],[]}
	| decls vdecl { ($2 :: fst $1), snd $1 }
	| decls fdecl { fst $1, ($2 :: snd $1) } 

/* If you look at the functions declaration, you can see that declarations of
   locals must preced the statements in micro c. After my modification to expr,
   body contains some Localdecl's, which can be removed from $9 and added to $8
   in ocaml code below  */
fdecl:
	DEFINE typ ID LPAREN formals_opts RPAREN LBRACE vdecl_list stmt_list RBRACE
	{ { typ = $2; fname = $3; formals = $5;
		locals = List.rev $8; body = List.rev $9}}
        
formals_opts: /*nothing*/ 	{[]}
	| formal_list 			{ List.rev $1 }

formal_list: typ ID 		{ [($1,$2)] }
	| formal_list COMMA typ ID 	{ ($3,$4) :: $1 }

typ:      
	INT 		{ Int }
	| STRING 	{ String }
	| LISTT 	{ Listtyp }
	| EDGE 		{ Edge }

vdecl_list: /*nothin*/  { [] } 
    | vdecl_list vdecl  { $2 :: $1 }

vdecl: typ ID SEMI { ($1, $2) }

stmt_list:
          /*nothing*/	        { [] }
	| stmt_list stmt 	{ $2 :: $1 }
                        
                    /*DOESNT ALLOW RETURN of Nothing*/
stmt:
          expr SEMI					{ Expr $1 }
 	| RETURN expr SEMI				{ Return $2  }         
	| LBRACE stmt_list RBRACE 		{ Block(List.rev $2) } 
	| IF LPAREN expr RPAREN stmt ELSE stmt { If($3, $5, $7) }
	| FOR LPAREN expr_opt SEMI expr SEMI expr_opt RPAREN stmt { For($3,$5,$7,$9) }
	| WHILE LPAREN expr RPAREN stmt 	{ While($3, $5) }


list_list: /*nothing*/ { [] }
	| listdecl { List.rev $1 }

listdecl:
	  expr  				{ [$1] }
	| listdecl LISTSEP expr { $3 :: $1 } 


expr:
          typ ID                        { Localdecl($1, $2)}
        | LITINT			{ Litint($1) }
	| ID				{ Id($1) }
	| LITSTR			{ Litstr($1) }
	| BAR LITSTR COMMA LITINT COMMA LITSTR BAR 	{ Edgedcl($2,$4,$6) }
	| LSQBRACE list_list RSQBRACE 			{ Listdcl($2) }
	| expr PLUS   expr { Binop($1, Add,   $3) }
        | expr MINUS  expr { Binop($1, Sub,   $3) }
 	| expr TIMES  expr { Binop($1, Mult,  $3) }
        | expr DIVIDE expr { Binop($1, Div,   $3) }
        | expr EPLUS expr  { Binop($1, Eadd,  $3) }
        | expr EMINUS expr { Binop($1, Esub,  $3) }
        | expr EQ     expr { Binop($1, Equal, $3) }
        | expr LT     expr { Binop($1, Less,  $3) }
        | expr LEQ    expr { Binop($1, Leq,   $3) }
        | expr GT     expr { Binop($1, Greater, $3) }
        | expr GEQ    expr { Binop($1, Geq,   $3) }
        | expr AND    expr { Binop($1, And,   $3) }
        | expr OR     expr { Binop($1, Or,    $3) }
        | NOT expr         { Unop(Not, $2) }
        | ID ASSIGN expr   { Assign($1, $3) }
        | LPAREN expr RPAREN { $2 }
        | ID LPAREN actuals_opt RPAREN  { Call($1, $3)}

expr_opt: /*nothing*/ { Noexpr }
	| expr 			  { $1 }

actuals_opt: /*nothing*/ { [] }
	| actuals_list { List.rev $1 }

actuals_list:
	  expr    				  { [$1] }
	| actuals_list COMMA expr { $3 :: $1 }

