(* Authors: Donovan Chan, Andrew Feather, Macrina Lobo, 
			Anton Nefedenkov
   Note: This code was writte on top of Prof. Edwards's 
   		 microc code. We hope this is acceptable. *)

open Ast;;

module StringMap = Map.Make(String);;

let dup_global_exp = " duplicate global ";;
let dup_local_exp = " duplicate local ";;
let dup_formal_exp = " duplicate formal arg ";;

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




(* The thing that does all the checks *)
let check (globals, funcs) = 

	(* Check duplicate globals *)
	let global_dup_exp = 
		report_duplicate dup_global_exp (List.map snd globals) ""
	
	(* Check the local variables *)
	in let exp = global_dup_exp::
	(List.rev (func_duplicates dup_local_exp [] 
						(extract_locals [] funcs)))
	(* Get rid of elements containing empty sstring *)
	in purify_exp_list [] exp


	(*in exp::List.map (report_duplicate dup_local_exp) 
		(extract_locals [] funcs) *)

;;











