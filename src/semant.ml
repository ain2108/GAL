(* Authors: Donovan Chan, Andrew Feather, Macrina Lobo, 
			Anton Nefedenkov
   Note: This code was writte on top of Prof. Edwards's 
   		 microc code. We hope this is acceptable. *)

open Ast;;

module StringMap = Map.Make(String);;

let dup_global_exp = " duplicate global ";;

(* Static semantic checker of the program. Will return void 
   on success. Raise an exception otherwise. Checks first the
   globals, then the functions. *)


(* Reports if duplicates present duplicates. *)
let report_duplicate exception_msg list =
	(* Helper that build a list of duplicates *)
	let rec helper dupls = function
		[] -> List.rev dupls; 
		| n1 :: n2 :: tl when n1 = n2 -> helper (n2::dupls) tl
		| _ :: tl -> helper dupls tl

	(* Another helper, that uniq's the duples 
		(if not already uniq) Works on sorted lists! *)
	in let rec uniq result = function
    	[] -> List.rev result
  		| hd::[] -> uniq (hd::result) []
 		| hd1::(hd2::tl as tail) -> 
  			if hd1 = hd2 then uniq result tail
        	else uniq (hd1::result) tail
	
	(* Get a list of duplicates *)	
	in let dupls = uniq [] (helper [] (List.sort compare list))
	
	(* If the list is not an empty list *)
	in if dupls <> [] then 
		raise (Failure(exception_msg ^ (String.concat " " dupls)))
	else ();;



 	

	(* Construct appropriate error msg *)
(*	in dup_err_msg exp_msg duplicates str = match duplicates with
		| [] -> str
		| hd :: tl -> 
*)




	
let check (globals, funcs) = 

	(* Check duplicate globals *)
	report_duplicate dup_global_exp (List.map snd globals );
	 


;;











