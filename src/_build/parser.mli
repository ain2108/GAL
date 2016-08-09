type token =
  | SEMI
  | LPAREN
  | RPAREN
  | LSQBRACE
  | RSQBRACE
  | LBRACE
  | RBRACE
  | BAR
  | COLON
  | LISTSEP
  | COMMA
  | EPLUS
  | EMINUS
  | PLUS
  | MINUS
  | TIMES
  | DIVIDE
  | ASSIGN
  | NOT
  | EQ
  | LT
  | LEQ
  | GT
  | GEQ
  | AND
  | OR
  | RETURN
  | IF
  | ELSE
  | FOR
  | INT
  | STRING
  | EDGE
  | SLISTT
  | NLISTT
  | ELISTT
  | ILISTT
  | DEFINE
  | WHILE
  | LITINT of (int)
  | ID of (string)
  | LITSTR of (string)
  | EOF

val program :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.program
