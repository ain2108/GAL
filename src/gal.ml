type action = Ast | LLVM_IR | Compile;;

module P = Printf;;

let _ = (*
  let action = if Array.length Sys.argv > 1 then
      List.assoc Sys.argv.(1)
        [("-a", Ast); ("-l", LLVM_IR); ("-c", Compile) ]
    else *)
      Compile 
    in

  (* Standard Library Functions *)
  let stdlib_file               = "stdlib_code.gal" in 
  let stdlib_in                 = open_in stdlib_file in 
  let stdlib_lexbuf             = Lexing.from_channel stdlib_in in 
  let (std_globs, std_funcs)    = Parser.program Scanner.token stdlib_lexbuf in 

  (* The input program *)
  let lexbuf                    = Lexing.from_channel stdin in
  let (globs, funcs)            = Parser.program Scanner.token lexbuf in
  
  let ast = (std_globs @ globs, std_funcs @ funcs) in 

  (* P.fprintf stderr "%s" "ast built\n"; *)
  let exp_list = Semant.check ast in
  if exp_list <> [] then
  	raise (Failure ("\n" ^ (String.concat "\n" exp_list)))

  else
    (* P.fprintf stderr "%s" "ast checked\n"; *)
    let m = Codegen.translate ast in
    Llvm_analysis.assert_valid_module m; 
    print_string (Llvm.string_of_llmodule m);
    (* P.fprintf stderr "%s" "code generated\n"; *)








