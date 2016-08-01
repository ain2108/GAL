module A = Ast
module L = Llvm
module StringMap = Map.Make(String)

let translate (globals, functions) = 

	(* Build a context and the module *)
	let context = L.global_context () in
	let the_module = L.create_module context "GAL"
	
	(* Few helper functions returning the types *)
	and i32_t = L.i32_type context 		(* Integer *)
	and i8_t = L.i8_type context   		(* Char   *)
	and i1_t = L.i1_type context  		(* Needed for predicates *)
    
    in let i8_p_t = L.pointer_type i8_t 	(* Pointer *)
	in let edge_t = L.struct_type context  (* Edge type *)
				(Array.of_list [i8_p_t; i32_t; i8_p_t])
 

	(* Pattern match on A.typ returning a llvm type *)
	in let ltype_of_typ ltyp = match ltyp with
		| A.Int 	-> i32_t
		| A.Edge 	-> edge_t
		| A.String  -> i8_p_t
		| _ 	-> raise (Failure ("Type not implemented\n"))

	
	(* Global variables *)
	in let global_vars =
		let global_var m (t, n) =
			(* Initialize the global variable to 000...000 *)
			let init = L.const_int (ltype_of_typ t) 0
		(* Bind the gloabal to its name and its lglobal *)
		in StringMap.add n (L.define_global n init the_module) m 
	in List.fold_left global_var StringMap.empty globals

	(************ In built functions below ***********)
	
	(* Function llvm type *)
	in let printf_t = L.var_arg_function_type i32_t [| L.pointer_type i8_t |]
	(* Function declaration *)
	in let printf_func = L.declare_function "printf" printf_t the_module 



    (* Builds a user defined function *)
	in let function_decls = 
		let function_decl map fdecl = (
			(* Get the types of the formals in a list *)
			let formal_types =
				Array.of_list 
				(List.map (fun (t, _) -> ltype_of_typ t) fdecl.A.formals)

			(* Get the llvm function type with known return and formals types *)
			in let ftype = 
				L.function_type
				(ltype_of_typ fdecl.A.typ)
				formal_types

			(* Bind the name of the function to (llvm function, ast function) *)
			in StringMap.add fdecl.A.fname 
			(L.define_function fdecl.A.fname ftype the_module, fdecl)
			map)
		(* Populate the map by folding the list of functions *)
		in List.fold_left function_decl StringMap.empty functions
(* 
 	in let b = ()
 	in b
 *)
	(* Builds the function body in the module *)
	in let build_function_body fdecl = 

		let local_hash = Hashtbl.create 100 in 

		(* Get the llvm function from the map *)
		let (the_function, _) = StringMap.find fdecl.A.fname function_decls in

				
		(* Direct the builder to the right place *)
		let builder = L.builder_at_end context (L.entry_block the_function) in
		
		(* BFotmat string needed for printing. *)
		 (*   Will put format string into %tmt in global area *)
		let int_format_string = L.build_global_stringptr "%d\n" "ifs" builder in
		let string_format_string = L.build_global_stringptr "%s\n" "sfs" builder in

		let local_vars =
			let add_formal (t, n) p = 
				L.set_value_name n p;
				let local = L.build_alloca (ltype_of_typ t) n builder in
				ignore (L.build_store p local builder);
				Hashtbl.add local_hash n local in                                      
			List.iter2 add_formal fdecl.A.formals (Array.to_list (L.params the_function)) 

		in let add_local builder (t, n) =
				let local_var = L.build_alloca (ltype_of_typ t) n builder
				in Hashtbl.add local_hash n local_var 
		
		in let lookup name = 
			try Hashtbl.find local_hash name 
			with Not_found -> StringMap.find name global_vars 


		(* We can now describe the action to be taken on ast traversal *)
		(* Going to first pattern match on the list of expressions *)
		in let rec expr builder = function
			| A.Litint(i) -> L.const_int i32_t i 
			| A.Litstr(str) -> 
				let s = L.build_global_stringptr str "" builder in
				let zero = L.const_int i32_t 0 in
				L.build_in_bounds_gep s [|zero|] "" builder
			| A.Edgedcl(src, w, dst) -> 
				let src_p = expr builder (A.Litstr(src))
				and w =  expr builder (A.Litint(w))
				and dst_p = expr builder (A.Litstr(dst))
				in let alloc = L.build_alloca edge_t (src ^ "e") builder in
				ignore (L.build_store src_p 
					(L.build_gep alloc (Array.of_list [L.const_int i32_t 0]) "" builder) builder);
				ignore (L.build_store w 
					(L.build_gep alloc (Array.of_list [L.const_int i32_t 1]) "" builder) builder);
				ignore (L.build_store dst_p 
					(L.build_gep alloc (Array.of_list [L.const_int i32_t 2]) "" builder) builder);
				(L.build_gep alloc (Array.of_list [L.const_int i32_t 0]) "" builder)
			| A.Id(name) 	-> L.build_load (lookup name) name builder
			| A.Assign(name, e) -> let e' = expr builder e in
				ignore (L.build_store e' (lookup name) builder); e'
				(* Calling builtins below *)
			| A.Call("print_int", [e]) ->
				L.build_call printf_func 
				[| int_format_string; (expr builder e)|]
				"printf"
				builder
			| A.Call("print_str", [e]) ->
				L.build_call printf_func
				[| string_format_string; (expr builder e)|]
				"printf"
				builder
			| A.Call(fname, actuals) ->
				let (fdef, fdecl) = StringMap.find fname function_decls in 
				let actuals = List.rev (List.map (expr builder) (List.rev actuals)) in 
				let result = fname ^ "_result" in 
				L.build_call fdef (Array.of_list actuals) result builder
			| A.Binop(e1, op, e2) ->
				let v1 = expr builder e1 and v2 = expr builder e2 in 
				(match op with
					A.Add -> L.build_add
					| _   -> raise (Failure("operator not supported")))
				v1 v2 "tmp" builder
			| _ -> raise (Failure("expr not supported"))


		in let add_terminal builder f =
			match L.block_terminator (L.insertion_block builder) with
			| Some _ -> ()
			| None -> ignore (f builder) 

		in let rec stmt builder = function
			| A.Localdecl(t, n) -> ignore (add_local builder (t, n)); builder
			| A.Block(sl) 		-> List.fold_left stmt builder sl
			| A.Expr(e)   		-> ignore (expr builder e); builder
			| A.Return(e) 		-> L.build_ret (expr builder e) builder; builder
			| _			  		-> raise (Failure("statement not implemented"))

		in let builder = stmt builder (A.Block (List.rev fdecl.A.body)) in ()

		(* add_terminal builder (L.build_ret (L.const_int (ltype_of_typ A.Int) 0)) *)


	in List.iter build_function_body functions;
	the_module 



