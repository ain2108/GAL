(* Authors: Donovan Chan, Andrew Feather, Macrina Lobo, 
			Anton Nefedenkov
   Note: This code was writte on top of Prof. Edwards's 
   		 microc code. We hope this is acceptable. *)

open Ast;;

module StringMap = Map.Make(String);;
let m = StringMap.empty;;

(* Error messages of the exceptions *)
let dup_global_exp = " duplicate global ";;
let dup_local_exp = " duplicate local ";;
let dup_formal_exp = " duplicate formal arg ";;
let dup_func_exp = " duplicate function name ";;
let builtin_decl_exp = " cannot redefine ";;
let main_undef_exp = " main not defined ";;

(* Names of built in functions can be added below *)
let builtins_list =
	["print_int"; "print_str";
	 "length"; "source"; "dest"; "pop"];;

(* Built in decls *)
let print_int_fdcl = 
	{ typ = Int; fname = "print_int"; formals = [(Int, "a")];
	  locals = []; body = []};;

let print_str_fdcl = 
	{ typ = String; fname = "print_str"; formals = [(String, "a")];
	  locals = []; body = []};;

let length_fdcl = 
	{ typ = Int; fname = "length"; formals = [(Listtyp, "a")];
	  locals = []; body = []};;

let dest_fdcl = 
	{ typ = String; fname = "dest"; formals = [(Edge, "a")];
	  locals = []; body = []};;

let source_fdcl = 
	{ typ = String; fname = "source"; formals = [(Edge, "a")];
	  locals = []; body = []};;

(* This function needs discussion *)
let pop_fdcl = 
	{ typ = Listtyp; fname = "source"; formals = [(Listtyp, "a")];
	  locals = []; body = []};;

let builtin_fdcl_list =
	[ print_int_fdcl; print_str_fdcl; length_fdcl; dest_fdcl;
	  source_fdcl; pop_fdcl ];;


(* Static semantic checker of the program. Will return void 
   on success. Raise an exception otherwise. Checks first the
   globals, then the functions. *)


(* Reports if duplicates present duplicates. *)
let report_duplicate exception_msg list func_name =
	(* Helper that build a list of duplicates *)
	let rec helper dupls = function
		[] -> List.rev dupls; 
		| n1 :: n2 :: tl when n1 = n2 -> helper (n2::dupls) tl
		| _ :: tl -> helper dupls tl

	(* Another helper, that uniq's the duples 
		(if not already uniq) Works on sorted lists! *)
	in let rec uniq result = function
    	[] -> result
  		| hd::[] -> uniq (hd::result) []
 		| hd1::(hd2::tl as tail) -> 
  			if hd1 = hd2 then uniq result tail
        	else uniq (hd1::result) tail
	
	(* Get a list of duplicates *)	
	in let dupls = uniq [] (helper [] (List.sort compare list))
	
	(* If the list is not an empty list *)
	in if dupls <> [] then
		match func_name with 
		| "" -> 
		(exception_msg ^ (String.concat " " dupls) )
		| _ ->
		(exception_msg ^ (String.concat " " dupls) ^ " in " ^ func_name )
		
	else ""


(* Returns a list of lists of locals *)
let rec extract_locals local_vars = function
	[] -> List.rev local_vars
	| hd::tl -> extract_locals 
		(( hd.fname, (List.map snd hd.locals))::local_vars) tl
;;

(* Extracts formal arguments *)
let rec extract_formals formals = function
	[] -> List.rev formals
	| hd::tl -> extract_formals
		(( hd.fname, (List.map snd hd.formals))::formals) tl

(* Helper functions extracts good stuff from list of funcs *)
let rec func_duplicates exp_msg exception_list = function
	| [] 					-> List.rev exception_list
	| (name, var_list)::tail 	-> 
	func_duplicates 
		exp_msg
		((report_duplicate exp_msg var_list name)::exception_list) 
		tail
;;

(* Function get rid of empty string in exception list *)
let rec purify_exp_list result = function
	[] -> List.rev result
	| hd::tl when hd <> "" -> purify_exp_list (hd::result) tl
	| _::tl -> purify_exp_list result tl
;;

(* List of built ins is the implicit argument here*)
let rec check_builtins_defs exp_list expmsg funcs = function
	[] -> List.rev exp_list
	| hd::tl -> 
		if (List.mem hd funcs) then 
			let exp = expmsg ^ hd in
			check_builtins_defs (exp::exp_list) expmsg funcs tl
		else 
			check_builtins_defs exp_list expmsg funcs tl
;;

(* Helper function to print types *)
let string_of_typ = function
	| Int -> " int "
	| String -> " string "
	| Listtyp -> " list "
	| Edge -> " edge "
	| Void -> " (bad expression) "		
  

(* Function checks bunch of fun stuff in the function structure *)
let check_func exp_list globs_map func_decl funcs_map =

	(* Function returns the type of the identifier *)
	let get_type_of_id exp_list vars_map id = 
		StringMap.iter 
			(fun name typname -> (print_string (name ^ "\n")) )
			vars_map; 
		try (StringMap.find id vars_map, exp_list) 
		with Not_found -> 
			(Void, (" unknown identifier " ^ id ^ " in " ^ func_decl.fname)::exp_list)

	(* Helper will return a list of exceptions *)
	in let rec get_expression_type vars_map exp_list = function
		| Litstr(_) -> (String, exp_list)
		| Litint(_) -> (Int, exp_list)
		| Boolit(_) -> (Int, exp_list) (* KIV, just like in parser *)
		| Id(name)  -> get_type_of_id exp_list vars_map name
		| Binop(e1, op, e2) (* as e *) -> 
			let (v1, exp_list) = get_expression_type vars_map exp_list e1 in
			let (v2, exp_list) = get_expression_type vars_map exp_list e2 
			in (match op with 
				(* Integer operators *)
				| Add | Sub | Mult | Div | Equal | Less | Leq 
				| Greater | Geq | And | Or 
					when (v1 = Int && v2 = Int) -> (Int, exp_list)
				(* List operators *)
				| Eadd | Esub when v1 = Listtyp && v2 = Listtyp -> (Listtyp, exp_list)
				| _ -> (Void, (" illegal binary op in " ^ func_decl.fname)::exp_list) )
		| Unop(op, e1) -> get_expression_type vars_map exp_list e1
		| Noexpr -> (Void, exp_list) (* Need to check how Noexp is used *)
		| Assign(var, e) (* as ex *) -> 
			let (lt, exp_list) = get_type_of_id exp_list vars_map var in
			let (rt, exp_list) = get_expression_type vars_map exp_list e
				in if lt <> rt || rt = Void then 
				(Void,(" illegal assignment to variable " ^ var ^ " in " ^ func_decl.fname)::exp_list) 
				else (rt, exp_list) 
		| Edgedcl(_, _, _) -> (Edge, exp_list)
		| Listdcl(_) -> (Listtyp, exp_list)
		(* CARE HERE, NOT FINISHED AT ALL *)
		| Call(fname, actuals) -> 
			try let fd = StringMap.find fname funcs_map
			in if List.length actuals <> List.length fd.formals then
				(Void, (
					" " ^ fd.fname ^ " expects " ^ 
					(string_of_int (List.length fd.formals)) ^ 
					 " arguments in " ^ func_decl.fname)::exp_list)
			else 
				(* Helper comparing actuals to formals *)
				let rec check_actuals formals exp_list = function 
					[] -> List.rev exp_list
					| actual_name::tla -> 
						(* Warning in case formals is [], but then actuals
							is also [], so prev line should fire *)
						let (hdf::tlf) = formals in
						let (actual_typ, exp_list) = get_expression_type
							 vars_map exp_list actual_name in
						let (formal_typ, _) = hdf in 
						if formal_typ = actual_typ then
							check_actuals tlf exp_list tla
						else
							(" wrong argument type in " ^ 
								fname ^ " call ")::exp_list
				
				in let exp_list = check_actuals 
					(fd.formals)
					exp_list
					actuals
				in (fd.typ, exp_list)

			with Not_found -> 
				(Void, (" function " ^ fname ^ " not defined ")::exp_list)

		| _ -> (Void, exp_list) 

	(* in get_expression_type globs_map exp_list (Litstr("hello"))
 *)
(* In short, helper walks through the ast checking all kind of things *)
	in let rec helper vars_map exp_list = function
		| [] -> List.rev exp_list
		|  hd::tl -> (match hd with 
			| Localdecl(typname, name) ->
					print_string ("locvar " ^ name ^ " added \n"); 
					helper (StringMap.add name typname vars_map) exp_list tl
			| Expr(e) -> 
					print_string " checking expression ";
					let (typname, exp_list) = get_expression_type vars_map exp_list e in
					helper vars_map exp_list tl
			| If(p, s1, s2) -> 
					let (ptype, exp_list) = get_expression_type vars_map exp_list p in
						if ptype <> Int then
							helper vars_map
							((" predicate in if of type " ^ string_of_typ ptype ^ 
							 " in function " ^ func_decl.fname)
							::(helper vars_map (helper vars_map exp_list [s1]) [s2]))
							tl
						else
							helper vars_map
							(helper vars_map (helper vars_map exp_list [s1]) [s2])
							tl

			| Return(e) -> let (rettyp, exp_list) = get_expression_type vars_map exp_list e
					in if rettyp = func_decl.typ then 
							helper vars_map exp_list tl
					else (func_decl.fname ^ " expected to return type " ^ 
							(string_of_typ func_decl.typ) ^ " but expression is of type " ^
							(string_of_typ rettyp))::exp_list
			| _ -> helper vars_map exp_list [] (* Placeholder *)

		)

	in let globs_forms_map = List.fold_left 
		(fun m (typname, name) -> StringMap.add name typname m)
 		globs_map
 		func_decl.formals 

 	in helper globs_forms_map exp_list (List.rev func_decl.body)
 

let rec check_functions exp_list globs_map funcs_map = function
	| [] -> List.rev exp_list
	| hd::tl -> check_functions
			(check_func exp_list globs_map hd funcs_map)
			globs_map
			funcs_map
			tl

(* The thing that does all the checks *)
let check (globals, funcs) = 

	(* Check duplicate globals *)
	let global_dup_exp = 
		report_duplicate dup_global_exp (List.map snd globals) ""
	
	(* Check the local variables *)
	in let exp = global_dup_exp::
	((func_duplicates dup_local_exp [] 
						(extract_locals [] funcs)))

	(* Check the formal arguments *)
	in let exp = func_duplicates 
		dup_formal_exp 
		exp
		(extract_formals [] funcs)

	(* Check for func name duplicates *)
	in let exp = (report_duplicate 
		dup_func_exp 
		(List.map (fun n -> n.fname) funcs) 
		"")::exp 

	(* Check if built ins were redefined *)
	in let exp = (check_builtins_defs
		exp
		builtin_decl_exp
		(List.map (fun n -> n.fname) funcs)
		builtins_list)
	
	(* Add builtins to the map *)
	in let builtin_decls = List.fold_left
		(fun m fd -> StringMap.add fd.fname fd m)
		StringMap.empty
		builtin_fdcl_list

	(* Add user declared functions to the map *)
	in let fdecl_map = List.fold_left
		(fun m fd -> StringMap.add fd.fname fd m)
		builtin_decls
		funcs

	(* Check if main was properly declared *)
	in let exp = 
			try ignore (StringMap.find "main" fdecl_map); exp 
			with Not_found -> main_undef_exp :: exp 

	(* Get a map of globals for future use in symbol table
		composition for each function *)
	in let globs_map = List.fold_left 
		(fun m (typname, name) -> StringMap.add name typname m)
 		StringMap.empty
 		globals

 	in let exp = check_functions exp globs_map fdecl_map funcs


	(* Get rid of elements containing empty sstring *)
	in purify_exp_list [] exp


	(*in exp::List.map (report_duplicate dup_local_exp) 
		(extract_locals [] funcs) *)

;;











