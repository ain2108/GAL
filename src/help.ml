open Ast

(* I hope this function is not too broken, still needs testing
	works for if conditionals, do not know about for loops.  
	What it does is it goes through the body of the function 
	extracting all local variables, returnning a list of locals *)

let rec get_vardecls vars = function
	| [] -> List.rev vars
	| hd::tl -> (match hd with
		| Expr(Localdecl(typname, name)) -> 
			(* print_string " Expr"; *)
			get_vardecls ((typname, name)::vars) tl
		| Block(slist) -> (* print_string " Block"; *)
						  (match slist with
			| [] -> get_vardecls vars tl
			| hd1::tl1 ->
				get_vardecls
					(get_vardecls (get_vardecls vars [hd1]) tl1)
					tl1)
		| If(e, s1, s2) -> 
			(* print_string " If"; *)
			get_vardecls (get_vardecls (get_vardecls vars [s1]) [s2]) tl
		| For(_, _, _, s) -> 
			get_vardecls (get_vardecls vars [s]) tl
		| While(e, s) -> 
			get_vardecls (get_vardecls vars [s]) tl
		| _ -> get_vardecls vars tl )

;;