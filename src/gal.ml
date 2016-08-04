open Semant;; 

type action = Ast | LLVM_IR | Compile;;

module P = Printf;;

let _ = (*
  let action = if Array.length Sys.argv > 1 then
      List.assoc Sys.argv.(1)
        [("-a", Ast); ("-l", LLVM_IR); ("-c", Compile) ]
    else *)
      Compile 
    in

  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Scanner.token lexbuf in
  P.fprintf stderr "%s" "ast built\n";
  let exp_list = Semant.check ast in
  if exp_list <> [] then
  	raise (Failure ("\n" ^ (String.concat "\n" exp_list)))

  else
    P.fprintf stderr "%s" "ast checked\n";
    let m = Codegen.translate ast in
    (*    Llvm_analysis.assert_valid_module m; *)  
    print_string (Llvm.string_of_llmodule m);
    P.fprintf stderr "%s" "code generated\n";








