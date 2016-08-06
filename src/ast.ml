(* Authors: Donovan Chan, Andrew Feather, Macrina Lobo, 
			Anton Nefedenkov
   Note: This code was writte on top of Prof. Edwards's 
   		 microc code. We hope this is acceptable. *)

type op = Add | Sub | Mult | Div | Equal | 
	  Less | Leq | Greater | Geq | And | Or |
	  Eadd | Esub 

(* List and Edge here are different from below *)
type uop = Not

type typ = Int | String | Listtyp | Edge | Void

type bind = typ * string 

type expr = Litint of int 
	  | Litstr of string
	  | Id of string
	  | Binop of expr * op * expr
	  | Assign of string * expr
	  | Boolit of int    (* KIV *)
	  | Noexpr
	  | Unop of uop * expr
	  | Call of string * expr list 
	  | Edgedcl of expr * expr * expr
	  | Listdcl of expr list
	  (*  Localdecl of typ * string  *)
(* Added to support local decls *)
(*MIGHT HAVE ISSUES HERE, alternative expr list*)

type stmt = 
		  | Localdecl of typ * string
		  |	Block of stmt list
		  | Expr of expr
		  | If of expr * stmt * stmt  (*MIGHT NOT NEED ELSE ALL THE TIME*)
		  | For of expr * expr * expr * stmt
		  | While of expr * stmt
		  | Return of expr
                  

type func_decl = { 
		
	typ 	: typ;
	fname 	: string;
	formals : bind list;
	locals  : bind list;
	body 	: stmt list;
}

type program = bind list * func_decl list
