# This Makefile belongs to Prof. Stephen Edwards. Taken directly from microc
# We havve altered the file to suit our needs.
# Make sure ocamlbuild can find opam-managed packages: first run
#
# eval `opam config env`

# More detailed: build using ocamlc/ocamlopt + ocamlfind to locate LLVM

OBJS = parser.cmo scanner.cmo semant.cmo gal.cmo 

gal: scanner.ml parser.ml
	ocamlc -c ast.ml 
	ocamlc -c parser.mli
	ocamlc -c scanner.ml parser.ml
	ocamlc -c semant.ml
	ocamlc -c gal.ml
	ocamlc $(OBJS) -o gal

scanner.ml: scanner.mll
	ocamllex scanner.mll

parser.ml: parser.mly
	ocamlyacc parser.mly

# "make clean" removes all generated files

.PHONY : clean
clean :
	rm -f gal scanner.ml parser.ml parser.mli *.cmo *.cmi

