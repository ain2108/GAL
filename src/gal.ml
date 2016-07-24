open Semant;; 

type action = Ast | LLVM_IR | Compile;;

let _ = (*
  let action = if Array.length Sys.argv > 1 then
      List.assoc Sys.argv.(1)
        [("-a", Ast); ("-l", LLVM_IR); ("-c", Compile) ]
    else *)
      Compile in

  let lexbuf = Lexing.from_channel stdin in
  let ast = Parser.program Scanner.token lexbuf in
  check ast;

