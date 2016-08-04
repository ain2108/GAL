; ModuleID = 'GAL'

%node = type <{ %node*, i8* }>

@ifs = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs = private unnamed_addr constant [3 x i8] c"%s\00"
@efs = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@0 = private unnamed_addr constant [2 x i8] c"A\00"
@1 = private unnamed_addr constant [2 x i8] c"B\00"
@2 = private unnamed_addr constant [8 x i8] c"goodbye\00"
@3 = private unnamed_addr constant [2 x i8] c"C\00"
@4 = private unnamed_addr constant [2 x i8] c"B\00"
@5 = private unnamed_addr constant [2 x i8] c"A\00"
@6 = private unnamed_addr constant [2 x i8] c"A\00"
@7 = private unnamed_addr constant [16 x i8] c"AlphaAlphaAlpha\00"
@8 = private unnamed_addr constant [2 x i8] c"C\00"
@9 = private unnamed_addr constant [7 x i8] c"banana\00"
@10 = private unnamed_addr constant [5 x i8] c"alph\00"
@11 = private unnamed_addr constant [3 x i8] c"::\00"
@12 = private unnamed_addr constant [3 x i8] c"::\00"
@13 = private unnamed_addr constant [1 x i8] zeroinitializer
@ifs.1 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.2 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@ifs.4 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.5 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@14 = private unnamed_addr constant [2 x i8] c"(\00"
@15 = private unnamed_addr constant [3 x i8] c", \00"
@16 = private unnamed_addr constant [3 x i8] c", \00"
@17 = private unnamed_addr constant [2 x i8] c")\00"
@18 = private unnamed_addr constant [1 x i8] zeroinitializer
@ifs.7 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.8 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.9 = private unnamed_addr constant [4 x i8] c"%s\0A\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %e1 = alloca { i8*, i32, i8* }*
  %malloccall = tail call i8* @malloc(i32 ptrtoint ({ i8*, i32, i8* }* getelementptr ({ i8*, i32, i8* }, { i8*, i32, i8* }* null, i32 1) to i32))
  %0 = bitcast i8* %malloccall to { i8*, i32, i8* }*
  %1 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 0
  %2 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 1
  %3 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 2
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @0, i32 0, i32 0), i8** %1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @1, i32 0, i32 0), i8** %3
  store i32 2, i32* %2
  %4 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0
  store { i8*, i32, i8* }* %4, { i8*, i32, i8* }** %e1
  %hello = alloca i8*
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @2, i32 0, i32 0), i8** %hello
  %l1 = alloca %node*
  %malloccall1 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %5 = bitcast i8* %malloccall1 to %node*
  %6 = getelementptr inbounds %node, %node* %5, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @3, i32 0, i32 0), i8** %6
  %malloccall2 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %7 = bitcast i8* %malloccall2 to %node*
  %8 = getelementptr inbounds %node, %node* %7, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @4, i32 0, i32 0), i8** %8
  %9 = getelementptr inbounds %node, %node* %7, i32 0, i32 0
  store %node* %5, %node** %9
  %malloccall3 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %10 = bitcast i8* %malloccall3 to %node*
  %11 = getelementptr inbounds %node, %node* %10, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @5, i32 0, i32 0), i8** %11
  %12 = getelementptr inbounds %node, %node* %10, i32 0, i32 0
  store %node* %7, %node** %12
  store %node* %10, %node** %l1
  %l2 = alloca %node*
  %malloccall4 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %13 = bitcast i8* %malloccall4 to %node*
  %14 = getelementptr inbounds %node, %node* %13, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @6, i32 0, i32 0), i8** %14
  store %node* %13, %node** %l2
  %e2 = alloca { i8*, i32, i8* }*
  %malloccall5 = tail call i8* @malloc(i32 ptrtoint ({ i8*, i32, i8* }* getelementptr ({ i8*, i32, i8* }, { i8*, i32, i8* }* null, i32 1) to i32))
  %15 = bitcast i8* %malloccall5 to { i8*, i32, i8* }*
  %16 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %15, i32 0, i32 0
  %17 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %15, i32 0, i32 1
  %18 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %15, i32 0, i32 2
  store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @7, i32 0, i32 0), i8** %16
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @8, i32 0, i32 0), i8** %18
  store i32 3, i32* %17
  %19 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %15, i32 0
  store { i8*, i32, i8* }* %19, { i8*, i32, i8* }** %e2
  %e16 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %print_edge_result = call i32 @print_edge({ i8*, i32, i8* }* %e16)
  %build_edge_result = call { i8*, i32, i8* }* @build_edge(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @10, i32 0, i32 0), i32 10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @9, i32 0, i32 0))
  store { i8*, i32, i8* }* %build_edge_result, { i8*, i32, i8* }** %e2
  %e27 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e2
  %print_edge_result8 = call i32 @print_edge({ i8*, i32, i8* }* %e27)
  %l19 = load %node*, %node** %l1
  %20 = getelementptr inbounds %node, %node* %l19, i32 0, i32 1
  %21 = load i8*, i8** %20
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* %21)
  %l110 = load %node*, %node** %l1
  %22 = getelementptr inbounds %node, %node* %l110, i32 0, i32 0
  %23 = load %node*, %node** %22
  store %node* %23, %node** %l1
  %printf11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @11, i32 0, i32 0))
  %l112 = load %node*, %node** %l1
  %24 = getelementptr inbounds %node, %node* %l112, i32 0, i32 1
  %25 = load i8*, i8** %24
  %printf13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* %25)
  %l114 = load %node*, %node** %l1
  %26 = getelementptr inbounds %node, %node* %l114, i32 0, i32 0
  %27 = load %node*, %node** %26
  store %node* %27, %node** %l1
  %printf15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @12, i32 0, i32 0))
  %l116 = load %node*, %node** %l1
  %28 = getelementptr inbounds %node, %node* %l116, i32 0, i32 1
  %29 = load i8*, i8** %28
  %printf17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* %29)
  %printf18 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @13, i32 0, i32 0))
  ret i32 1
}

define { i8*, i32, i8* }* @build_edge(i8* %src, i32 %w, i8* %dst) {
entry:
  %src1 = alloca i8*
  store i8* %src, i8** %src1
  %w2 = alloca i32
  store i32 %w, i32* %w2
  %dst3 = alloca i8*
  store i8* %dst, i8** %dst3
  %e1 = alloca { i8*, i32, i8* }*
  %src4 = load i8*, i8** %src1
  %w5 = load i32, i32* %w2
  %dst6 = load i8*, i8** %dst3
  %malloccall = tail call i8* @malloc(i32 ptrtoint ({ i8*, i32, i8* }* getelementptr ({ i8*, i32, i8* }, { i8*, i32, i8* }* null, i32 1) to i32))
  %0 = bitcast i8* %malloccall to { i8*, i32, i8* }*
  %1 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 0
  %2 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 1
  %3 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 2
  store i8* %src4, i8** %1
  store i8* %dst6, i8** %3
  store i32 %w5, i32* %2
  %4 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0
  store { i8*, i32, i8* }* %4, { i8*, i32, i8* }** %e1
  %e17 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  ret { i8*, i32, i8* }* %e17
}

define i32 @print_edge({ i8*, i32, i8* }* %e) {
entry:
  %e1 = alloca { i8*, i32, i8* }*
  store { i8*, i32, i8* }* %e, { i8*, i32, i8* }** %e1
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @14, i32 0, i32 0))
  %e2 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %0 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e2, i32 0, i32 0
  %1 = load i8*, i8** %0
  %printf3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* %1)
  %printf4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @15, i32 0, i32 0))
  %e5 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %2 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e5, i32 0, i32 1
  %3 = load i32, i32* %2
  %printf6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @ifs.4, i32 0, i32 0), i32 %3)
  %printf7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @16, i32 0, i32 0))
  %e8 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %4 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e8, i32 0, i32 2
  %5 = load i8*, i8** %4
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* %5)
  %printf10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @17, i32 0, i32 0))
  %printf11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs.6, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @18, i32 0, i32 0))
  ret i32 0
}

define i32 @sum(i32 %a, i32 %b) {
entry:
  %a1 = alloca i32
  store i32 %a, i32* %a1
  %b2 = alloca i32
  store i32 %b, i32* %b2
  %a3 = load i32, i32* %a1
  %b4 = load i32, i32* %b2
  %tmp = add i32 %a3, %b4
  ret i32 %tmp
}

declare noalias i8* @malloc(i32)
