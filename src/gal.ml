open Semant;; 

type action = Ast | LLVM_IR | Compile;;

let _ = (*
  let action = if Array.length Sys.argv > 1 then
      List.assoc Sys.argv.(1)
        [("-a", Ast); ("-l", LLVM_IR); ("-c", Compile) ]
    else *)
      Compile 
    in

  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Scanner.token lexbuf in 
  let exp_list = Semant.check ast in
  if exp_list <> [] then
  	raise (Failure ("\n" ^ (String.concat "\n" exp_list)))

  else let m = Codegen.translate ast in
    (* Llvm_analysis.assert_valid_module m;  *)
    print_string (Llvm.string_of_llmodule m)
    (* print_string ("compilation succesful!\n")  *)







