module A = Ast
module L = Llvm
module P = Printf
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
	in let i32_p_t = L.pointer_type i32_t
	in let edge_t = L.struct_type context  (* Edge type *)
				(Array.of_list [i8_p_t; i32_t; i8_p_t])
 
	in let zero = L.const_int i32_t 0 
    in let one = L.const_int i32_t 1
	in let inc_i32 c = L.const_add c one  

 	in let node_t = L.named_struct_type context "node" in 
    L.struct_set_body node_t (Array.of_list [L.pointer_type node_t; i8_p_t; i32_t ])  true;

    

    let Some(node_t) = L.type_by_name the_module "node" in 
    
	(* Pattern match on A.typ returning a llvm type *)
	let ltype_of_typ ltyp = match ltyp with
		| A.Int 	-> i32_t
		| A.Edge 	-> L.pointer_type edge_t
		| A.String  -> i8_p_t
		| A.Listtyp(_) -> 
					L.pointer_type node_t
		| _ 	-> raise (Failure ("Type not implemented\n"))

 	in let get_node_type expr = match expr with
		| A.Litint(num) -> L.struct_type context
			(Array.of_list [L.pointer_type node_t; i32_p_t]) 
		| A.Litstr(str) -> L.struct_type context
			(Array.of_list [L.pointer_type node_t; i8_p_t]) 
		| _ -> raise (Failure(" type not supported in list "))
 
	(* Create the edge declaration *)
	in let codegen_edgedecl =
	ignore (L.struct_set_body (L.named_struct_type context "edge") 
	(Array.of_list [i8_p_t; i32_t; i8_p_t]) false)

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

	(* Builds the function body in the module *)
	in let build_function_body fdecl = 

		let local_hash = Hashtbl.create 100 in 

		(* Get the llvm function from the map *)
		let (the_function, _) = StringMap.find fdecl.A.fname function_decls in

				
		(* Direct the builder to the right place *)
		let builder = L.builder_at_end context (L.entry_block the_function) in
		
		(* BFotmat string needed for printing. *)
		 (*   Will put format string into %tmt in global area *)
		let int_format_string = L.build_global_stringptr "%d" "ifs" builder in
		let string_format_string = L.build_global_stringptr "%s" "sfs" builder in
		let endline_format_string = L.build_global_stringptr "%s\n" "efs" builder in

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

		 (* Gets a boolean i1_t value from any i_type *)
        in let bool_of_int int_val = L.build_is_null int_val "banana" builder
			


		(* We can now describe the action to be taken on ast traversal *)
		(* Going to first pattern match on the list of expressions *)
		in let rec expr builder = function
			| A.Litint(i) -> L.const_int i32_t i 
			| A.Litstr(str) -> 
				let s = L.build_global_stringptr str "" builder in
				let zero = L.const_int i32_t 0 in
				L.build_in_bounds_gep s [|zero|] "" builder
			| A.Edgedcl(src, w, dst) -> 
				let src_p = expr builder src
				and w =  expr builder w
				and dst_p = expr builder dst
				in let alloc = L.build_malloc edge_t ("") builder

				in let src_field_pointer = 
					L.build_struct_gep alloc 0 "" builder
				and weight_field_pointer =
					L.build_struct_gep alloc 1 "" builder
				and dst_field_pointer = 
					L.build_struct_gep alloc 2 "" builder

				in 
					ignore (L.build_store src_p src_field_pointer builder);
					ignore (L.build_store dst_p dst_field_pointer builder);
					ignore (L.build_store w weight_field_pointer builder);
				L.build_in_bounds_gep alloc [|(L.const_int i32_t 0)|] "" builder  
			
			| A.Listdcl(elist) -> 
				let elist = List.rev elist in 
				let add_element head_p new_node_p =
					let new_node_next_field_pointer =
						L.build_struct_gep new_node_p 0 "" builder in 
					ignore (L.build_store head_p 
					new_node_next_field_pointer builder);
					new_node_p

				in let add_payload node_p payload_p =
					let node_payload_pointer =
						L.build_struct_gep node_p 1 "" builder in 
					ignore (L.build_store payload_p 
					node_payload_pointer builder);
					node_p

				in let build_node node_type payload =
					let alloc = L.build_malloc node_type ("") builder in
					let payload_p = expr builder payload in 
					add_payload alloc payload_p 

				in if (elist = []) then
					L.const_pointer_null (L.pointer_type node_t)
					(* raise (Failure("empty list assignment")) *)
				else 
					let (hd::tl) = elist in 
					(* let node_t = get_node_type hd in  *)
					let head_node = build_node node_t hd in
					let head_node_len_p = L.build_struct_gep head_node 2 "" builder in 
					let head_node_next_p =  L.build_struct_gep head_node 0 "" builder in 
					ignore (L.build_store (L.undef (L.pointer_type node_t)) head_node_next_p builder); 
					ignore (L.build_store (expr builder (A.Litint(1))) head_node_len_p builder);

					let rec build_list the_head len = function 
						| [] -> the_head
						| hd::tl ->(
							let len = len + 1 in 
							let new_node = build_node node_t hd in 
							let new_head = add_element the_head new_node in 
							let new_head_len_p = L.build_struct_gep new_head 2 "" builder in
							ignore (L.build_store (expr builder (A.Litint(len))) new_head_len_p builder);
							build_list new_head (len) tl)
					
					in build_list head_node 1 tl

			| A.Id(name) -> L.build_load (lookup name) name builder
			| A.Assign(name, e) -> 
				let e' = (expr builder e) in
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
			| A.Call("print_endline", []) ->
				L.build_call printf_func
				[| endline_format_string; (expr builder (A.Litstr("")))|]
				"printf"
				builder
			| A.Call("source", [e]) -> 
				let src_field_pointer = L.build_struct_gep (expr builder e) 0 "" builder 
				in L.build_load src_field_pointer "" builder  
			| A.Call("weight", [e]) ->
				let weight_field_pointer = L.build_struct_gep (expr builder e) 1 "" builder 
				in L.build_load weight_field_pointer "" builder
			| A.Call("dest", [e]) -> 
				let dest_field_pointer = L.build_struct_gep (expr builder e) 2 "" builder 
				in L.build_load dest_field_pointer "" builder 
			| A.Call("pop", [e]) ->
				let head_node_p = (expr builder e) in 
				let head_node_next_node_pointer = L.build_struct_gep head_node_p 0 "" builder in 
				ignore (L.build_free head_node_p builder);
				L.build_load head_node_next_node_pointer "" builder
			| A.Call("peek", [e]) -> 
				let head_node_p = (expr builder e) in 
				(* Trying to make the crash graceful here 565jhfdshjgq2 *)
				if  head_node_p = (L.const_pointer_null (L.type_of head_node_p)) then 
					raise (Failure("nothing to peek at, sorry"))
				else
				let head_node_payload_pointer = L.build_struct_gep head_node_p 1 "" builder in 
				L.build_load head_node_payload_pointer "" builder
			| A.Call("next", [e]) ->
				let head_node_next_p = L.build_struct_gep (expr builder e) 0 "" builder in 
				L.build_load head_node_next_p "" builder
			| A.Call("length", [e]) ->
				let head_node_len_p =  L.build_struct_gep (expr builder e) 2 "" builder in 
				L.build_load head_node_len_p  "" builder
				
		(*		P.fprintf stderr "%s" "no seg 1 n";
				let head_node_p = (expr builder e) in
				P.fprintf stderr "%s" "no seg 1 n";
				let head_node_next_p =  L.build_struct_gep head_node_p 0 "" builder in 
				let length = 0 in  

				let rec walker length current_node = 
					if not (L.is_undef current_node) then 
	 			        let length = length + 1 in 
				        ignore (P.fprintf stderr "%s" "no seg 2 n");
				        let current_node_next_p = L.build_struct_gep current_node 0 "" builder in
				        let next_node = (L.build_load current_node_next_p  "" builder) in   
						walker length next_node
					else 
						length

				in let next_node = L.build_load head_node_next_p  "" builder
				in L.const_int i32_t (walker length next_node)  *)
				(* L.const_int i32_t 10 *)

			| A.Call(fname, actuals) ->
				let (fdef, fdecl) = StringMap.find fname function_decls in 
				let actuals = List.rev (List.map (expr builder) (List.rev actuals)) in 
				let result = fname ^ "_result" in 
				L.build_call fdef (Array.of_list actuals) result builder
			| A.Binop(e1, op, e2) ->
				let v1 = expr builder e1 and v2 = expr builder e2 in 
				let value = 
				(match op with
					  A.Add 	-> L.build_add
					| A.Sub 	-> L.build_sub
					| A.Mult	-> L.build_mul
					| A.Div 	-> L.build_sdiv
					| A.And 	-> L.build_and
					| A.Or 		-> L.build_or 
					| A.Equal   -> L.build_icmp L.Icmp.Eq
	  				| A.Less    -> L.build_icmp L.Icmp.Slt
	  				| A.Leq     -> L.build_icmp L.Icmp.Sle
	  				| A.Greater -> L.build_icmp L.Icmp.Sgt
	  				| A.Geq     -> L.build_icmp L.Icmp.Sge
					| _   -> raise (Failure("operator not supported")))
				v1 v2 "tmp" builder  in value (* 
				L.build_intcast value i32_t "" builder  *)
			| A.Unop(op, e) ->
				let e' = expr builder e in 
				if (L.is_null e') then 
					L.const_int i32_t 1
				else 
					L.const_int i32_t 0
			| _ -> raise (Failure("expr not supported"))


		in let add_terminal builder f =
			match L.block_terminator (L.insertion_block builder) with
			| Some _ -> ()
			| None -> ignore (f builder) 

		in let rec stmt builder = function
			| A.Localdecl(t, n) -> ignore (add_local builder (t, n)); builder
			| A.Block(sl) 		-> List.fold_left stmt builder sl
			| A.Expr(e)   		-> ignore (expr builder e); builder
			| A.Return(e) 		-> ignore (L.build_ret (expr builder e) builder); builder
		 	| A.If(p, then_stmt, else_stmt) ->	
				(* Get the boolean *)
				let bool_val = (* bool_of_int  *)(expr builder p)

				(* Add the basic block *)
				in let merge_bb 	= L.append_block context "merge" the_function
				in let then_bb 	   	= L.append_block context "then" the_function 
				in let else_bb		= L.append_block context "else" the_function 
				
				(* Write the statements into their respective blocks, build conditional branch*)
				in
					add_terminal (stmt (L.builder_at_end context then_bb) then_stmt) (L.build_br merge_bb);
					add_terminal (stmt (L.builder_at_end context else_bb) else_stmt) (L.build_br merge_bb);
					ignore (L.build_cond_br bool_val then_bb else_bb builder);
				
				(* Return the builder *)
				L.builder_at_end context merge_bb
			| A.While(predicate, body) ->

				let pred_bb = L.append_block context "while" the_function in
	  			ignore (L.build_br pred_bb builder);

	  			let body_bb = L.append_block context "while_body" the_function in
	  			add_terminal (stmt (L.builder_at_end context body_bb) body)
	    		(L.build_br pred_bb);

	  			let pred_builder = L.builder_at_end context pred_bb in
	  			let bool_val =  (* bool_of_int *) (expr pred_builder predicate) in 

	  			let merge_bb = L.append_block context "merge" the_function in
	  			ignore (L.build_cond_br bool_val body_bb merge_bb pred_builder);
	  			L.builder_at_end context merge_bb				

			| _			  		-> raise (Failure("statement not implemented"))

		in let builder = stmt builder (A.Block (List.rev fdecl.A.body)) in 

		add_terminal builder (L.build_ret (L.const_int (ltype_of_typ A.Int) 0))


	in List.iter build_function_body functions;
	the_module 



