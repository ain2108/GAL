# This Makefile belongs to Prof. Stephen Edwards. Taken directly from microc
# We havve altered the file to suit our needs.
# Make sure ocamlbuild can find opam-managed packages: first run
#
# eval `opam config env`


.PHONY : microc.native

gal.native :
	ocamlbuild -use-ocamlfind -pkgs str,llvm,llvm.analysis -cflags -w,+a-4 \
		gal.native





# More detailed: build using ocamlc/ocamlopt + ocamlfind to locate LLVM

OBJS = ast.cmo help.cmo parser.cmo scanner.cmo semant.cmo gal.cmo codegen.cmo 

andrew: scanner.ml parser.ml
	ocamlc -c ast.ml 
	ocamlc -c help.ml
	ocamlc -c parser.mli
	ocamlc -c scanner.ml parser.ml
	ocamlc -c semant.ml
	ocamlc -I /usr/local/opt/llvm/include -c codegen.ml
	ocamlc -c gal.ml
	ocamlc $(OBJS) -I /usr/local/opt/llvm/include -o gal

scanner.ml: scanner.mll
	ocamllex scanner.mll

parser.ml: parser.mly
	ocamlyacc parser.mly

# "make clean" removes all generated files

.PHONY : clean
clean :
	rm -f gal scanner.ml gal.native parser.ml parser.mli *.cmo *.cmi

