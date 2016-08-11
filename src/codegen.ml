(* Authors: Donovan Chan, Andrew Feather, Macrina Lobo, 
			Anton Nefedenkov
   Note: This code was writte on top of Prof. Edwards's 
   		 microc code. We hope this is acceptable. *)


module A = Ast
module L = Llvm
module P = Printf
module StringMap = Map.Make(String)


let translate (globals, functions) = 

	let the_funcs_map = StringMap.empty in 
	let the_funcs_map = 
		List.fold_left 
		(fun map fdecl -> StringMap.add fdecl.A.fname fdecl.A.typ map)
		the_funcs_map
		functions 
	in 

    (* Holding global string constants *)
    let glob_str_const_hash = Hashtbl.create 200 in 

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

    in let one = L.const_int i32_t 1

	in let empty_node_t = L.named_struct_type context "empty" in 
	L.struct_set_body empty_node_t (Array.of_list [L.pointer_type empty_node_t; L.pointer_type i1_t; i32_t ])  true;

 	let node_t = L.named_struct_type context "node" in 
    L.struct_set_body node_t (Array.of_list [L.pointer_type node_t; i8_p_t; i32_t ])  true;

    let e_node_t = L.named_struct_type context "enode" in 
    L.struct_set_body e_node_t (Array.of_list [L.pointer_type e_node_t; L.pointer_type edge_t; i32_t ])  true;

	let i_node_t = L.named_struct_type context "inode" in 
    L.struct_set_body i_node_t (Array.of_list [L.pointer_type i_node_t; i32_t; i32_t ])  true;

	let n_node_t = L.named_struct_type context "nnode" in 
    L.struct_set_body n_node_t (Array.of_list [L.pointer_type n_node_t; L.pointer_type e_node_t; i32_t ])  true;
    
	(* Pattern match on A.typ returning a llvm type *)
	let ltype_of_typ ltyp = match ltyp with
		| A.Int 	-> i32_t
		| A.Edge 	-> L.pointer_type edge_t
		| A.String  -> i8_p_t
		| A.EmptyListtyp -> L.pointer_type empty_node_t
		| A.SListtyp -> L.pointer_type node_t 
		| A.EListtyp -> L.pointer_type e_node_t
		| A.IListtyp -> L.pointer_type i_node_t
		| A.NListtyp -> L.pointer_type n_node_t
		| _ 	-> raise (Failure ("Type not implemented\n"))


	in let list_type_from_type ocaml_type = match ocaml_type with
		| A.Int 		-> i_node_t
		| A.String 		-> node_t 
		| A.Edge 		-> e_node_t
		| A.EListtyp	-> n_node_t
		| _ -> raise (Failure("such lists are not supported "))

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

		let ocaml_local_hash = Hashtbl.create 100 in 
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

		let _ =
			
			let rec enumerate i enumed_l = function 
					| [] -> List.rev enumed_l 
					| hd::tl -> enumerate (i + 1) ((hd, i)::enumed_l) tl 
			in 

			let add_formal (t, n) (p, _) = 
				L.set_value_name n p;
				let local = L.build_alloca (ltype_of_typ t) n builder in
				ignore (L.build_store p local builder);
				Hashtbl.add local_hash n local;
				Hashtbl.add ocaml_local_hash n t;
			in 
			
			let params = enumerate 0 [] (Array.to_list (L.params the_function))  

			in List.iter2 add_formal fdecl.A.formals params 

		in let add_local builder (t, n) =
				let local_var = L.build_alloca (ltype_of_typ t) n builder
				in Hashtbl.add local_hash n local_var 
(* 
		in let add_local_list builder ltype n = 
				let local_var = L.build_alloca (ltype) n builder
				in Hashtbl.add local_hash n local_var *)

		in let lookup name = 
			try Hashtbl.find local_hash name 
			with Not_found -> StringMap.find name global_vars

		in let rec get_node_type expr = match expr with
			| A.Litint(_) -> i_node_t
			| A.Litstr(_) -> node_t
			| A.Listdcl(somelist) -> 
				if somelist = [] then 
					raise (Failure("empty list decl"))
				else 
					let hd::_ = somelist in get_node_type hd  
			| A.Binop(e1, _, _) -> get_node_type e1
			| A.Edgedcl(_) 	-> e_node_t
			| A.Id(name) 	-> 
				let ocaml_type = (Hashtbl.find ocaml_local_hash name)
				in  list_type_from_type ocaml_type
			| A.Call("iadd", _) | A.Call("inext", _) ->
				i_node_t
			| A.Call("eadd", _) | A.Call("enext", _) ->
				e_node_t
			| A.Call("sadd", _) | A.Call("snext", _) ->
				node_t
			| A.Call("nadd", _) | A.Call("nnext", _) ->
				n_node_t
			| A.Call("ilength", _) | A.Call("slength", _) | A.Call("nlength", _) | A.Call("elength", _) ->
				i_node_t
			| A.Call(fname, _) ->
				let ftype = StringMap.find fname the_funcs_map in 
				ltype_of_typ ftype
				(* try let fdecl = List.find 
				(fun fdecl -> if fdecl.A.fname = fname then true else false)
				functions 
				in (ltype_of_typ fdecl.A.typ) with Not_found -> in  *)
			| _ -> raise (Failure(" type not supported in list "))


		(* We can now describe the action to be taken on ast traversal *)
		(* Going to first pattern match on the list of expressions *)
		in let rec expr builder e = 

			(* Helper to add element to the list *)
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

			in match e with 
			| A.Litint(i) -> L.const_int i32_t i 
			| A.Litstr(str) -> 
				let s = L.build_global_stringptr str str builder in
				let zero = L.const_int i32_t 0 in
				let lvalue = L.build_in_bounds_gep s [|zero|] str builder in
				let lv_str = L.string_of_llvalue s in 
				(* P.fprintf stderr "%s\n" lv_str; *)

				Hashtbl.add glob_str_const_hash lvalue str;
				s
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

				if (elist = []) then
					L.const_pointer_null (L.pointer_type empty_node_t)
					(* raise (Failure("empty list assignment")) *)
				else 
					let (hd::tl) = elist in 
					let good_node_t = get_node_type hd in 
					let head_node = build_node (good_node_t) hd in
					let head_node_len_p = L.build_struct_gep head_node 2 "" builder in 
					let head_node_next_p =  L.build_struct_gep head_node 0 "" builder in 
					ignore (L.build_store (L.undef (L.pointer_type good_node_t)) head_node_next_p builder); 
					ignore (L.build_store (expr builder (A.Litint(1))) head_node_len_p builder);

					let rec build_list the_head len = function 
						| [] -> the_head
						| hd::tl ->(
							let len = len + 1 in 
							let new_node = build_node good_node_t hd in 
							let new_head = add_element the_head new_node in 
							let new_head_len_p = L.build_struct_gep new_head 2 "" builder in
							ignore (L.build_store (expr builder (A.Litint(len))) new_head_len_p builder);
							build_list new_head (len) tl)
					
					in (build_list head_node 1 tl) 

			| A.Id(name) -> L.build_load (lookup name) name builder
			| A.Assign(name, e) -> 
				let loc_var = lookup name in 
				let e' = (expr builder e) in

				(* Cant add it like this. Need a different comparison. And need to remove
					old var form the hash map  *)
				if ((L.pointer_type empty_node_t) = (L.type_of e')) then 
					(

					(* This is the ocaml type of the variable *)
					let list_type = Hashtbl.find ocaml_local_hash name in 
					
					(* Cant get to the right type for store instruction, so this: *)
					let get_llvm_node_type ocaml_type = match ocaml_type with 
						| A.SListtyp -> node_t
						| A.IListtyp -> i_node_t
						| A.NListtyp -> n_node_t 
						| A.EListtyp -> e_node_t
						| _          -> raise (Failure("list type not supported"))
					in

					let llvm_node_t = get_llvm_node_type list_type in
					let dummy_node = L.build_malloc llvm_node_t ("") builder in  
					let dummy_node_len_p = L.build_struct_gep dummy_node 2 "" builder in 
					ignore (L.build_store (expr builder (A.Litint(0))) dummy_node_len_p builder);
					ignore (L.build_store dummy_node loc_var builder); 
					e' )
				else  
					(ignore (L.build_store e' (lookup name) builder); e')
			
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
			| A.Call("spop", [e]) ->
				let head_node_p = (expr builder e) in 
				let head_node_next_node_pointer = L.build_struct_gep head_node_p 0 "" builder in 
				ignore (L.build_free head_node_p builder);
				L.build_load head_node_next_node_pointer "" builder
			| A.Call("speek", [e]) | A.Call("ipeek", [e]) | A.Call("epeek", [e]) | A.Call("npeek", [e])-> 
				let head_node_p = (expr builder e) in 
				(* Trying to make the crash graceful here 565jhfdshjgq2 *)
				if  head_node_p = (L.const_pointer_null (L.type_of head_node_p)) then 
					raise (Failure("nothing to peek at, sorry"))
				else
				let head_node_payload_pointer = L.build_struct_gep head_node_p 1 "" builder in 
				L.build_load head_node_payload_pointer "" builder
			| A.Call("snext", [e]) | A.Call("enext", [e]) | A.Call("inext", [e]) | A.Call("nnext", [e])->
				let head_node_next_p = L.build_struct_gep (expr builder e) 0 "" builder in 
				L.build_load head_node_next_p "" builder
			| A.Call("slength", [e]) | A.Call("elength", [e]) | A.Call("ilength", [e]) | A.Call("nlength", [e]) ->
				let head_node = expr builder e in 
				if (L.pointer_type empty_node_t) = (L.type_of head_node) then
					L.const_int i32_t 0 
				else 

					let head_node_len_p =  L.build_struct_gep (head_node) 2 "" builder in 
					L.build_load head_node_len_p  "" builder

			| A.Call("sadd", [elmt; the_list]) | A.Call("iadd", [elmt; the_list]) 
			| A.Call("nadd", [elmt; the_list]) | A.Call("eadd", [elmt; the_list]) -> 

				(* Build the new node *)
				(* let elmt = (expr builder the_list) in *)
				let the_head = (expr builder the_list) in 
				let good_node_t = get_node_type elmt in 
				let new_node = build_node (good_node_t) elmt in

				(* To accomodate for calls that take an empty list in (?) *)
				if (L.pointer_type empty_node_t) = (L.type_of the_head) then 
					let new_node_len_p = L.build_struct_gep new_node 2 "" builder in
					ignore (L.build_store (L.const_int i32_t 1) new_node_len_p builder);
					new_node
				else 

					(* If the length is 0, we should detect this in advance  *)
					let head_node_len_p =  L.build_struct_gep the_head 2 "" builder in 
					let llength_val = L.build_load head_node_len_p  "" builder in 

					if (L.is_null llength_val) then 
						let new_node_len_p = L.build_struct_gep new_node 2 "" builder in
						ignore (L.build_store (L.const_int i32_t 1) new_node_len_p builder);
						new_node

					else 
 
						(* Get the lenght of the list *)
						let old_length = L.build_load (L.build_struct_gep the_head 2 "" builder) "" builder in
						let new_length = L.build_add old_length one "" builder in 
				
						(* Store the lenght of the list *)
						let new_node_len_p = L.build_struct_gep new_node 2 "" builder in 
						ignore (L.build_store new_length new_node_len_p builder);

						(* Attach the new head to the old head *) 
						add_element the_head new_node 
			| A.Call("streq", [s1;s2]) ->
				let v1 = (expr builder s1) and v2 = expr builder s2 in 
				let v1value = L.build_load (L.build_load  (L.global_initializer v1)  "" builder) "" builder in 
				let v2value = L.build_load (L.build_load  (L.global_initializer v2)  "" builder) "" builder in 

				let str = L.string_of_lltype (L.type_of v2value) in 

				let result = (L.build_icmp L.Icmp.Eq v1value v2value "" builder) in 
				let result = L.build_not result "" builder in 
				let result = L.build_intcast result i32_t "" builder in 
				result
			(*
 *)
			| A.Call(fname, actuals) ->
			
				(* Will clean up later *)
				let bitcast_actuals (actual, _) = 
					let lvalue = expr builder actual in 
					lvalue
				in 

				let rec enumerate i enumed_l = function 
					| [] -> List.rev enumed_l 
					| hd::tl -> enumerate (i + 1) ((hd, i)::enumed_l) tl 
				in 

				let actuals = (enumerate 0 [] actuals) in  
				let (fdef, _) = StringMap.find fname function_decls in 
				let actuals = List.rev (List.map bitcast_actuals (List.rev actuals)) in 
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
					| A.Neq 	-> L.build_icmp L.Icmp.Ne
	  				| A.Less    -> L.build_icmp L.Icmp.Slt
	  				| A.Leq     -> L.build_icmp L.Icmp.Sle
	  				| A.Greater -> L.build_icmp L.Icmp.Sgt
	  				| A.Geq     -> L.build_icmp L.Icmp.Sge)
				v1 v2 "tmp" builder  in value 
			| A.Unop(op, e) ->
				let e' = expr builder e in 
				(match op with 
					| A.Not -> L.build_not) e' "tmp" builder
			| _ -> raise (Failure("expr not supported"))


		in let add_terminal builder f =
			match L.block_terminator (L.insertion_block builder) with
			| Some _ -> ()
			| None -> ignore (f builder) 

		in let rec stmt builder = function
			| A.Localdecl(t, n) -> (Hashtbl.add ocaml_local_hash n t; ignore (add_local builder (t, n)); builder)
			| A.Block(sl) 		-> List.fold_left stmt builder sl
			| A.Expr(e)   		-> ignore (expr builder e); builder
			| A.Return(e) 		-> ignore (L.build_ret (expr builder e) builder); builder
		 	| A.If(p, then_stmt, else_stmt) ->	
				(* Get the boolean *)
				let bool_val = (expr builder p)

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



