module A = Ast
module L = Llvm
module StringMap = Map.Make(String)

let translate (globals, functions) = 

	(* Build a context and the module *)
	let context = L.global_context () in
	let the_module = L.create_module context "GAL"
	
	(* Few helper functions returning the types *)
	and i32_t = L.i32_type context
	and i8_t = L.i8_type context
	and i1_t = L.i1_type context


	(* Pattern match on A.typ returning a llvm type *)
	in let ltype_of_typ ltyp = match ltyp with
		| A.Int -> i32_t
		| _ 	-> raise (Failure ("Type not implemented\n"))

	
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

		(* Get the llvm function from the map *)
		let (the_function, _) = StringMap.find fdecl.A.fname function_decls in

				
		(* Direct the builder to the right place *)
		let builder = L.builder_at_end context (L.entry_block the_function) in
		
		(* BFotmat string needed for printing. *)
		 (*   Will put format string into %tmt in global area *)
		let int_format_string = L.build_global_stringptr "%d\n" "tmt" builder in

  
		(* We can now describe the action to be taken on ast traversal *)
		(* Going to first pattern match on the list of expressions *)
		let rec expr builder = function
			| A.Litint(i) -> L.const_int i32_t i 
			| A.Call("print_int", [e]) ->
				L.build_call printf_func 
				[| int_format_string; (expr builder e)|]
				"printf"
				builder
			| _ -> raise (Failure("expr not supported"))

		in let add_terminal builder f =
			match L.block_terminator (L.insertion_block builder) with
			| Some _ -> ()
			| None -> ignore (f builder) 

		in let rec stmt builder = function
			| A.Block(sl) -> List.fold_left stmt builder sl
			| A.Expr(e)   -> ignore (expr builder e); builder
			| A.Return(e) -> L.build_ret (expr builder e) builder; builder
			| _			  -> raise (Failure("statement not implemented"))

		in let builder = stmt builder (A.Block (List.rev fdecl.A.body)) in ()

		(* add_terminal builder (L.build_ret (L.const_int (ltype_of_typ A.Int) 0)) *)


	in List.iter build_function_body functions;
	the_module 



