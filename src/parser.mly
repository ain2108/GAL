/* OCamlyacc parser for GAL */

%{
	open Ast
%}

%token SEMI LPAREN RPAREN LSQBRACE RSQBRACE LBRAC RBRACE BAR COLON LISTSEP COMMA
%token EPLUS EMINUS PLUS MINUS TIMES DIVIDE ASSIGN NOT 
%token EQ LT LEQ GT GEQ AND OR 
%token RETURN IF ELSE FOR INT STRING EDGE LIST DEFINE
%token <int> LITINT
%token <string> ID
%token <string> LITSTR
%token EOF

%nonassoc ELSE
%right ASSIGN
%left OR
%left AND
%left EQ 
%left LT GT LEQ GEQ
%left PLUS MINUS EPLUS EMINUS
%left TIMES DIVIDE
%right NOT NEG /*what does this do?*/