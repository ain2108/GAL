(* This it the code generation file that takes a semantically checked AST 
	and produces the LLVM IR *)

module L = Llvm
module A = Ast (* maybe just open the ast *)

module StringMap = Map.Make(String)

exception Error of string

let translate (globals, functions) = 
	let context = L.global_context() in 
	let the_module = L.create_module context "GAL" (*this is the LLVM construct that 
													create_module contains all the functions 
													and globals*)
	
	and i32_t = L.i32_type context                 (*int type*)
	and i8_t = L.i8_type context 	
	and string_t = L.const_stringz context			(*used to implement string type*)
	(*and string_t = L.const_string context 		   (*this array is not null terminated*)
	and list_t = L.list_type context (* gotta think about this*)
	and edge_t = L.edge context*) 	(* custom types gotta think*)
	and void_t = L.void_type context in (*not sure if we need this but it's in ast *)

let ltype_of_typ = function
	  A.Int -> i32_t
	| A.String -> 
	(*| A.String -> string_t
	| A.Listtyp -> list_t
	| A.Edge -> edge_t*)
	| A.Void -> void_t in 

let global_vars = 
	let global_vars m (t, n) = 
		let init = L.const_int (ltype_of_typ t ) 0 in
		StringMap.add n (L.define_global n init the_module) m in 
		List.fold_left global_var StringMap.empty globals in

(*a single print would be able to tell which 
  built in print function we are looking at, print_int
  and print_str will both call this function print() *)
let print_t	= L.function_type i32_t [| L.pointer_type i8_t |] in 
let print_func = L.declare_function "print" print_t the_module 


(*this gives the map of all the function declarations in a stringmap 
   along with all the return types. this is stored in function_decls*)

(*
let function_decls = 
	let function_decl m fdecl = 
		let name = fdecl.A.fname	
		and formal_types = 
			Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.A.formals) in
			(*Basically above statement returns array of a list of maps of the types
			   to whatever the type is bound to in the ast*)
			let ftype = L.function_type (ltype_of_typ fdecl.A.typ) formal_types in 
				StringMap.add name (L.define_function name ftype the_module, fdecl) m in 
					List.fold_left function_decl StringMap.empty functions in

let build_function_body fdecl = 
	let (the_function, _ ) = StringMap.find fdecl.A.fname function_decls in 
		let builder = L.builder_at_end context (L.entry_block the_function) in (*defines the entry and end of block position*)
			let int_format_str = L.build_global_stringptr "%d\n" "fmt" builder in
				(*cant really figure out what fmt is*)

let local_vars = 
	let add_formal m (t,n) p = L.set_value_name n p;
	let local = L.build_alloca (ltype_of_typ t) n builder in (* creates assign instruction at position indicated by builder*)
		ignore (L.build_store p local builder);
		StringMap.add n local m in 

	let add_local m (t,n) = 
	let local_var = L.build_alloca (ltype_of_typ t) n builder in 
		StringMap.add n local_var m in

	let formals = List.fold_left2 add_formal StringMap.empty fdecl.A.formals 
		(Array.to_list (L.params the_function)) in (*L.params returns all the parameters of the function defined*)
		List.fold_left add_local formals fdecl.A.locals in 

*)





