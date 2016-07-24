open Ast

let rec get_vardecls vars = function
	| [] -> List.rev vars
	| hd::tl -> (match hd with
		| Expr(Localdecl(typname, name)) -> get_vardecls ((typname, name)::vars) tl
		| _ -> get_vardecls vars tl)


;;