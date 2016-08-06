(*Ocamllex scanner for GAL*)
(* Authors: Donovan Chan, Andrew Feather, Macrina Lobo, 
			Anton Nefedenkov
   Note: This code was writte on top of Prof. Edwards's 
   		 microc code. We hope this is acceptable. *)

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
| "node"   { LISTT}
| "edge"   { EDGE }      
| "int"    { INT }
| "string" { STRING }
| ['0'-'9']+ as lxm { LITINT(int_of_string lxm) }
| ['a'-'z' 'A'-'Z']['a'-'z' 'A'-'Z' '0'-'9' '_']* as lxm { ID(lxm) }
| '"' (([' '-'!' '#'-'[' ']'-'~']*) as s ) '"' { LITSTR(s) }		(* * or + we have no idea*)
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }
