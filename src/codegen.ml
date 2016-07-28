(* just writing codegen for hello world *)

module L = Llvm
module A = Ast

module StringMap = Map.Make(String)

exception Error of string

let translate (globals, functions) =
	let context = L.global_context () in 
	let the_module = L.create_module context "GAL"
	and i32_t = L.i32_type context 
	and i8_t = L.i8_type context in 

let ltype_of_typ = function
	  A.Int -> i32_t 
	| _ -> raise (Error "not implemented") 
in

let global_vars = 
	let global_var map (typ, name) = 
		let init = L.const_int (ltype_of_typ typ ) 0 in
		StringMap.add name (L.define_global name init the_module) map in 
			List.fold_left global_var StringMap.empty globals in

let print_t = L.var_arg_function_type i32_t [| L.pointer_type i8_t |] in     (*we are only printing integers for now this returns the function type*)
let print_func = L.declare_function "printf" print_t the_module in (*this is the LLVM function, do not change printf to anything else*)

let function_decls = (*this function returns a map of functions declarations*)
	let function_decl map fdecl =
		let name = fdecl.A.fname and
			formal_types =
		 Array.of_list (List.map (fun (typ,_)-> ltype_of_typ typ) fdecl.A.formals)
		in let ftype = L.function_type (ltype_of_typ fdecl.A.typ) formal_types in
		StringMap.add name (L.define_function name ftype the_module, fdecl) map in
		(*define function creates the entry basic block for the function*)
			List.fold_left function_decl StringMap.empty functions in 

let build_function_body fdecl = 
	let (the_function, _ ) = StringMap.find fdecl.A.fname function_decls in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let int_format_str = L.build_global_stringptr  "%d\n" "formatstring" builder in

let rec expr builder = function
	  A.Litint(i) -> L.const_int i32_t i
	| A.Call("print_int", [expr]) -> 
		L.build_call print_func [| int_format_str ; (expr builder e) |]
	    "printf" builder 
	| _ -> raise (Error "NOT SUPPORTED EXPR") in

let rec stmt builder = function
      A.Block sl -> List.fold_left stmt builder sl
    | A.Expr e -> ignore (expr builder e); builder 
    | A.Return e -> ignore(L.build_ret (expr builder e) builder); builder 
    | _ -> raise (Error "NOT SUPPORTED STMT") in 

ignore (List.iter build_function_body functions);
the_module