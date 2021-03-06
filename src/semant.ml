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
	 "length"; "source"; "dest"; "pop"; "weight"; "print_endline"; "peek"];;

(* Built in decls *)
let print_int_fdcl = 
	{ typ = Int; fname = "print_int"; formals = [(Int, "a")];
	  locals = []; body = []};;

let print_str_fdcl = 
	{ typ = String; fname = "print_str"; formals = [(String, "a")];
	  locals = []; body = []};;

let slength_fdcl = 
	{ typ = Int; fname = "slength"; formals = [(SListtyp, "a")];
	  locals = []; body = []};;

let elength_fdcl = 
	{ typ = Int; fname = "elength"; formals = [(EListtyp, "a")];
	  locals = []; body = []};;

let ilength_fdcl = 
	{ typ = Int; fname = "ilength"; formals = [(IListtyp, "a")];
	  locals = []; body = []};;

let nlength_fdcl = 
	{ typ = Int; fname = "nlength"; formals = [(NListtyp, "a")];
	  locals = []; body = []};;

let dest_fdcl = 
	{ typ = String; fname = "dest"; formals = [(Edge, "a")];
	  locals = []; body = []};;

let source_fdcl = 
	{ typ = String; fname = "source"; formals = [(Edge, "a")];
	  locals = []; body = []};;

let weight_fdcl = 
	{ typ = Int; fname = "weight"; formals = [(Edge, "a")];
	  locals = []; body = []};;

let print_endline_fdcl = 
	{ typ = Int; fname = "print_endline"; formals = [];
	  locals = []; body = []};;

(* This function needs discussion *)
let spop_fdcl = 
	{ typ = SListtyp; fname = "spop"; formals = [(SListtyp, "a")];
	  locals = []; body = []};;

let ipop_fdcl = 
	{ typ = IListtyp; fname = "ipop"; formals = [(IListtyp, "a")];
	  locals = []; body = []};;

let epop_fdcl = 
	{ typ = EListtyp; fname = "epop"; formals = [(EListtyp, "a")];
	  locals = []; body = []};;

let npop_fdcl = 
	{ typ = NListtyp; fname = "npop"; formals = [(NListtyp, "a")];
	  locals = []; body = []};;

let speek_fdcl = 
	{ typ = String; fname = "speek"; formals = [(SListtyp, "a")];
	  locals = []; body = []};;

let ipeek_fdcl = 
	{ typ = Int; fname = "ipeek"; formals = [(IListtyp, "a")];
	  locals = []; body = []};;

let epeek_fdcl = 
	{ typ = Edge; fname = "epeek"; formals = [(EListtyp, "a")];
	  locals = []; body = []};;

let npeek_fdcl = 
	{ typ = EListtyp; fname = "npeek"; formals = [(NListtyp, "a")];
	  locals = []; body = []};;

let snext_fdcl = 
	{ typ = SListtyp; fname = "snext"; formals = [(SListtyp, "a")];
	  locals = []; body = []};;

let enext_fdcl = 
	{ typ = EListtyp; fname = "enext"; formals = [(EListtyp, "a")];
	  locals = []; body = []};;

let inext_fdcl = 
	{ typ = IListtyp; fname = "inext"; formals = [(IListtyp, "a")];
	  locals = []; body = []};;

let nnext_fdcl = 
	{ typ = NListtyp; fname = "nnext"; formals = [(NListtyp, "a")];
	  locals = []; body = []};;

let sadd_fdcl = 
	{ typ = SListtyp; fname = "sadd"; formals = [(String, "b"); (SListtyp, "a")];
	  locals = []; body = []};;

let eadd_fdcl = 
	{ typ = EListtyp; fname = "eadd"; formals = [(Edge, "b"); (EListtyp, "a")];
	  locals = []; body = []};;

let iadd_fdcl = 
	{ typ = IListtyp; fname = "iadd"; formals = [(Int, "b"); (IListtyp, "a")];
	  locals = []; body = []};;

let nadd_fdcl = 
	{ typ = NListtyp; fname = "nadd"; formals = [(EListtyp, "b"); (NListtyp, "a")];
	  locals = []; body = []};;

let str_comp_fdcl = 
	{ typ = Int; fname = "streq"; formals = [(String, "a"); (String, "b")];
	  locals = []; body = []};;


let builtin_fdcl_list =
	[ print_int_fdcl; print_str_fdcl; slength_fdcl; dest_fdcl;
	  source_fdcl; spop_fdcl; weight_fdcl; print_endline_fdcl;
	  speek_fdcl; ipeek_fdcl; epeek_fdcl; snext_fdcl; elength_fdcl;
	  enext_fdcl; inext_fdcl; ilength_fdcl; nnext_fdcl; npeek_fdcl;
	  nlength_fdcl; sadd_fdcl; eadd_fdcl; iadd_fdcl; nadd_fdcl;
	  str_comp_fdcl; ipop_fdcl; epop_fdcl; npop_fdcl ];;


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
let string_of_typ asttype = match asttype with 
	| Int -> " int "
	| String -> " string "
	| SListtyp -> " slist "
	| Edge -> " edge "
	| Void -> " (bad expression) "	
	| EListtyp -> " elist "	
  	| NListtyp -> " nlist "
  	| IListtyp -> " ilist "

(* Function checks bunch of fun stuff in the function structure *)
let check_func exp_list globs_map func_decl funcs_map =

	(* Function returns the type of the identifier *)
	let get_type_of_id exp_list vars_map id = 
		(* StringMap.iter 
			(fun name typname -> (print_string (name ^ "\n")) )
			vars_map;  *)
		try (StringMap.find id vars_map, exp_list) 
		with Not_found -> 
			(Void, (" in " ^ func_decl.fname ^ " var: " ^
					" unknown identifier " ^ id)::exp_list)

	(* Helper will return a list of exceptions *)
	in let rec get_expression_type vars_map exp_list = function
		| Litstr(_) -> (String, exp_list)
		| Litint(_) -> (Int, exp_list)
		| Id(name)  -> get_type_of_id exp_list vars_map name
		| Binop(e1, op, e2) (* as e *) -> 
			let (v1, exp_list) = get_expression_type vars_map exp_list e1 in
			let (v2, exp_list) = get_expression_type vars_map exp_list e2 
			in (match op with 
				(* Integer operators *)
				| Add | Sub | Mult | Div | Equal | Less | Leq 
				| Greater | Geq | And | Or | Neq 
					when (v1 = Int && v2 = Int) -> (Int, exp_list)
				(* List operators *)
				(* | Eadd | Esub when v1 = Listtyp && v2 = Listtyp -> (Listtyp, exp_list) *)
				| _ -> (Void, ( " in " ^ func_decl.fname ^ " expr: " ^
								" illegal binary op ")::exp_list) )
		| Unop(op, e1) -> get_expression_type vars_map exp_list e1
		| Noexpr -> (Void, exp_list) (* Need to check how Noexp is used *)
		| Assign(var, e) (* as ex *) -> 
				(* print_string (" assignment to " ^ var ^ "\n"); *)
			let (lt, exp_list) = get_type_of_id exp_list vars_map var in
			let (rt, exp_list) = get_expression_type vars_map exp_list e
				in if (lt <> rt && rt <> EmptyListtyp) || rt = Void then 
				(Void,(" in " ^ func_decl.fname ^ " expr: " ^
					   " illegal assignment to variable " ^ var)::exp_list) 
				else (rt, exp_list) 
		| Edgedcl(e1, e2, e3) -> 
			let (v1, exp_list) = get_expression_type vars_map exp_list e1 in
			let (v2, exp_list) = get_expression_type vars_map exp_list e2 in 
			let (v3, exp_list) = get_expression_type vars_map exp_list e3 in
				if v1 = String && v3 = String && v2 = Int then
					(Edge, exp_list)
				else 
					(Void, ( " in " ^ func_decl.fname ^ " edge: " ^
								" bad types ")::exp_list)
		| Listdcl(elist) -> 
			(* Get the type of the first element of the list *)
			let get_elmt_type decl_list = match decl_list with 
			| [] -> Nothing
			| hd::tl -> 
				let (v1, exp_list) = get_expression_type vars_map exp_list hd in
				v1
			in 

			(* Get the type of the list *)
			let get_list_type elmt_type = match elmt_type with 
				| Nothing 	-> EmptyListtyp 
				| Edge 		-> EListtyp
				| String 	-> SListtyp
				| Int 		-> IListtyp 
				| EListtyp  -> NListtyp 
				| _ 		-> raise (Failure("in list decl process")) 

			in

			let rec check_list exp_list = function
			[] -> List.rev exp_list
			| hd::[] ->
				let (v1, exp_list) = get_expression_type vars_map exp_list hd in  
				check_list exp_list []
			| hd1::(hd2::tl as tail) ->
				let (v1, exp_list) = get_expression_type vars_map exp_list hd1 in
				let (v2, exp_list) = get_expression_type vars_map exp_list hd2 in 
				if v1 <> v2 then 
					check_list 
					((" in " ^ func_decl.fname ^ " list: " ^
								" bad types of expressions ")::exp_list)
					[]
				else
					check_list exp_list tail
			in 

			let list_exp_list = check_list [] elist
			in if list_exp_list <> [] then
				(Void, (exp_list @ list_exp_list))
			else
				let elmt_type = get_elmt_type elist in 
				let list_typ  = get_list_type elmt_type in 
				(list_typ, exp_list)


		(* CARE HERE, NOT FINISHED AT ALL *)
		| Call(fname, actuals) -> 
			try let fd = StringMap.find fname funcs_map
			in if List.length actuals <> List.length fd.formals then
				(Void, (
					" in " ^ func_decl.fname ^ " fcall: " ^
					fd.fname ^ " expects " ^ 
					(string_of_int (List.length fd.formals)) ^ 
					 " arguments " )::exp_list)
			else 
				(* Helper comparing actuals to formals *)
				let rec check_actuals formals exp_list = function 
					[] -> List.rev exp_list
					| actual_name::tla -> match formals with
						| []       -> raise (Failure(" bad. contact me "))
						| hdf::tlf -> 
							let (actual_typ, exp_list) = get_expression_type
							vars_map exp_list actual_name in
							let (formal_typ, _) = hdf in 
							if formal_typ = actual_typ then
								check_actuals tlf exp_list tla
							else
								(" in " ^ func_decl.fname ^
							 	" fcall:  wrong argument type in " ^ 
								fname ^ " call ")::exp_list
				
				in let exp_list = check_actuals 
					(fd.formals)
					exp_list
					actuals
				in (fd.typ, exp_list)

			with Not_found -> 
				(Void, (" in " ^ func_decl.fname ^ " fcall:" ^
						" function " ^ fname ^ " not defined ")::exp_list)

		| _ -> (Void, exp_list) 

(* In short, helper walks through the ast checking all kind of things *)
	in let rec helper vars_map exp_list = function
		| [] -> List.rev exp_list
		|  hd::tl -> (match hd with 
			| Localdecl(typname, name) ->
					(* print_string ("locvar " ^ name ^ " added \n"); *)
					helper (StringMap.add name typname vars_map) exp_list tl
			| Expr(e) -> 
					(* print_string " checking expression "; *)
					let (typname, exp_list) = get_expression_type vars_map exp_list e in
					helper vars_map exp_list tl
			| If(p, s1, s2) -> 
					let (ptype, exp_list) = get_expression_type vars_map exp_list p in
						if ptype <> Int then
							
							helper vars_map
							(( " in " ^ func_decl.fname ^ 
							   " if: predicate of type " ^ string_of_typ ptype )
							::(helper vars_map (helper vars_map exp_list [s1]) [s2]))
							tl
						else
							helper vars_map
							(helper vars_map (helper vars_map exp_list [s1]) [s2])
							tl
			| For(e1, e2, e3, s) -> 
					let (e1_typ, exp_list) = get_expression_type vars_map exp_list e1 in
					let (e2_typ, exp_list) = get_expression_type vars_map exp_list e2 in
					let (e3_typ, exp_list) = get_expression_type vars_map exp_list e3 in
					if e1_typ = e3_typ && e2_typ = Int then
						helper vars_map (helper vars_map exp_list [s]) tl
					else
						helper vars_map 
						((" in " ^ func_decl.fname ^ 
						 " for loop: bad types of expressions. Type * Int * Type expected. ")
						::exp_list)
						tl
			| While(cond, loop) ->
					let (cond_typ, exp_list) = get_expression_type vars_map exp_list cond in 
					if cond_typ = Int then 
						helper vars_map (helper vars_map exp_list [loop]) tl
					else
						helper vars_map
						((" in " ^ func_decl.fname ^ 
						 " while loop: bad type of conditional expression ")
						::exp_list)
						tl

			| Block(sl) -> (match sl with
					| [Return(_) as s] -> 
						helper vars_map (helper vars_map exp_list [s]) tl 
					| Return(_)::_ -> 
						helper vars_map 
						((" in " ^ func_decl.fname ^ " ret: nothing can come after return" ^
						" in a given block")::exp_list)
						tl
					| Block(sl)::ss -> 
						helper vars_map
						(helper vars_map exp_list (sl @ ss))
						tl
					| s::sl as stl-> helper vars_map
						(helper vars_map exp_list stl)
						tl
					| [] -> helper vars_map exp_list tl 
					
				)

			(* Make sure that tl is an empty list at this point, otherwise throgw exception *)
			| Return(e) -> let (rettyp, exp_list) = get_expression_type vars_map exp_list e
					in if rettyp = func_decl.typ then 
							helper vars_map exp_list tl
					else (func_decl.fname ^ " ret: expected return type " ^ 
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
