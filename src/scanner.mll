(*Ocamllex scanner for GAL*)

{ open Parser }

rule token = parse
  [' ' '\t' '\r' '\n'] { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| '('      { LPAREN }
| ')'      { RPAREN }
| '['	   { LSQBRACE }
| ']'      { RSQBRACE }
| '{'      { LBRACE }
| '}'      { RBRACE }
| '|'      { BAR }
| ':'      { COLON }
| ';'      { SEMI }
| ','      { COMMA }
| "+."     { EPLUS }
| "-."     { EMINUS }
| '+'      { PLUS }
| '-'      { MINUS }
| '*'      { TIMES }
| '/'      { DIVIDE }
| '='      { ASSIGN }
| "::"     { LISTSEP }
| "=="     { EQ }
| '<'      { LT }
| "<="     { LEQ }
| '>'      { GT }
| ">="     { GEQ }
| "&&"     { AND }
| "||"     { OR }
| "!"      { NOT }
| "while"  { WHILE }
| "if"     { IF }
| "else"   { ELSE }
| "for"    { FOR }
| "return" { RETURN }
| "def"	   { DEFINE }
| "list"   { LISTT }
| "edge"   { EDGE }      
| "int"    { INT }
| "string" { STRING }
| ['0'-'9']+ as lxm { LITINT(int_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| '"'['a'-'z' 'A'-'Z' '0'-'9' '_']*'"' as lxm { LITSTR(lxm) }		(* * or + we have no idea*)
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }
