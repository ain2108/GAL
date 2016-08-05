; ModuleID = 'GAL'

%node = type <{ %node*, i8*, i32 }>

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
@13 = private unnamed_addr constant [2 x i8] c"C\00"
@14 = private unnamed_addr constant [2 x i8] c"B\00"
@15 = private unnamed_addr constant [2 x i8] c"A\00"
@16 = private unnamed_addr constant [8 x i8] c"Pretzel\00"
@17 = private unnamed_addr constant [7 x i8] c"Banana\00"
@18 = private unnamed_addr constant [9 x i8] c"Lebesque\00"
@19 = private unnamed_addr constant [1 x i8] zeroinitializer
@20 = private unnamed_addr constant [1 x i8] zeroinitializer
@21 = private unnamed_addr constant [1 x i8] zeroinitializer
@ifs.1 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.2 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@ifs.4 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.5 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@22 = private unnamed_addr constant [2 x i8] c"(\00"
@23 = private unnamed_addr constant [3 x i8] c", \00"
@24 = private unnamed_addr constant [3 x i8] c", \00"
@25 = private unnamed_addr constant [2 x i8] c")\00"
@26 = private unnamed_addr constant [1 x i8] zeroinitializer
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
  %7 = getelementptr inbounds %node, %node* %5, i32 0, i32 2
  %8 = getelementptr inbounds %node, %node* %5, i32 0, i32 0
  store i32 1, i32* %7
  %malloccall2 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %9 = bitcast i8* %malloccall2 to %node*
  %10 = getelementptr inbounds %node, %node* %9, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @4, i32 0, i32 0), i8** %10
  %11 = getelementptr inbounds %node, %node* %9, i32 0, i32 0
  store %node* %5, %node** %11
  %12 = getelementptr inbounds %node, %node* %9, i32 0, i32 2
  store i32 2, i32* %12
  %malloccall3 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %13 = bitcast i8* %malloccall3 to %node*
  %14 = getelementptr inbounds %node, %node* %13, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @5, i32 0, i32 0), i8** %14
  %15 = getelementptr inbounds %node, %node* %13, i32 0, i32 0
  store %node* %9, %node** %15
  %16 = getelementptr inbounds %node, %node* %13, i32 0, i32 2
  store i32 3, i32* %16
  store %node* %13, %node** %l1
  %l2 = alloca %node*
  %malloccall4 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %17 = bitcast i8* %malloccall4 to %node*
  %18 = getelementptr inbounds %node, %node* %17, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @6, i32 0, i32 0), i8** %18
  %19 = getelementptr inbounds %node, %node* %17, i32 0, i32 2
  %20 = getelementptr inbounds %node, %node* %17, i32 0, i32 0
  store i32 1, i32* %19
  store %node* %17, %node** %l2
  %e2 = alloca { i8*, i32, i8* }*
  %malloccall5 = tail call i8* @malloc(i32 ptrtoint ({ i8*, i32, i8* }* getelementptr ({ i8*, i32, i8* }, { i8*, i32, i8* }* null, i32 1) to i32))
  %21 = bitcast i8* %malloccall5 to { i8*, i32, i8* }*
  %22 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %21, i32 0, i32 0
  %23 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %21, i32 0, i32 1
  %24 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %21, i32 0, i32 2
  store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @7, i32 0, i32 0), i8** %22
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @8, i32 0, i32 0), i8** %24
  store i32 3, i32* %23
  %25 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %21, i32 0
  store { i8*, i32, i8* }* %25, { i8*, i32, i8* }** %e2
  %e16 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %print_edge_result = call i32 @print_edge({ i8*, i32, i8* }* %e16)
  %build_edge_result = call { i8*, i32, i8* }* @build_edge(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @10, i32 0, i32 0), i32 10, i8* getelementptr inbounds ([7 x i8], [7 x i8]* @9, i32 0, i32 0))
  store { i8*, i32, i8* }* %build_edge_result, { i8*, i32, i8* }** %e2
  %e27 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e2
  %print_edge_result8 = call i32 @print_edge({ i8*, i32, i8* }* %e27)
  %l19 = load %node*, %node** %l1
  %26 = getelementptr inbounds %node, %node* %l19, i32 0, i32 1
  %27 = load i8*, i8** %26
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* %27)
  %l110 = load %node*, %node** %l1
  %28 = getelementptr inbounds %node, %node* %l110, i32 0, i32 0
  %29 = bitcast %node* %l110 to i8*
  tail call void @free(i8* %29)
  %30 = load %node*, %node** %28
  store %node* %30, %node** %l1
  %printf11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @11, i32 0, i32 0))
  %l112 = load %node*, %node** %l1
  %31 = getelementptr inbounds %node, %node* %l112, i32 0, i32 1
  %32 = load i8*, i8** %31
  %printf13 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* %32)
  %l114 = load %node*, %node** %l1
  %33 = getelementptr inbounds %node, %node* %l114, i32 0, i32 0
  %34 = bitcast %node* %l114 to i8*
  tail call void @free(i8* %34)
  %35 = load %node*, %node** %33
  store %node* %35, %node** %l1
  %printf15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @12, i32 0, i32 0))
  %l116 = load %node*, %node** %l1
  %36 = getelementptr inbounds %node, %node* %l116, i32 0, i32 1
  %37 = load i8*, i8** %36
  %printf17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* %37)
  %l3 = alloca %node*
  %malloccall18 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %38 = bitcast i8* %malloccall18 to %node*
  %39 = getelementptr inbounds %node, %node* %38, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @13, i32 0, i32 0), i8** %39
  %40 = getelementptr inbounds %node, %node* %38, i32 0, i32 2
  %41 = getelementptr inbounds %node, %node* %38, i32 0, i32 0
  store i32 1, i32* %40
  %malloccall19 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %42 = bitcast i8* %malloccall19 to %node*
  %43 = getelementptr inbounds %node, %node* %42, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @14, i32 0, i32 0), i8** %43
  %44 = getelementptr inbounds %node, %node* %42, i32 0, i32 0
  store %node* %38, %node** %44
  %45 = getelementptr inbounds %node, %node* %42, i32 0, i32 2
  store i32 2, i32* %45
  %malloccall20 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %46 = bitcast i8* %malloccall20 to %node*
  %47 = getelementptr inbounds %node, %node* %46, i32 0, i32 1
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @15, i32 0, i32 0), i8** %47
  %48 = getelementptr inbounds %node, %node* %46, i32 0, i32 0
  store %node* %42, %node** %48
  %49 = getelementptr inbounds %node, %node* %46, i32 0, i32 2
  store i32 3, i32* %49
  %malloccall21 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %50 = bitcast i8* %malloccall21 to %node*
  %51 = getelementptr inbounds %node, %node* %50, i32 0, i32 1
  store i8* getelementptr inbounds ([8 x i8], [8 x i8]* @16, i32 0, i32 0), i8** %51
  %52 = getelementptr inbounds %node, %node* %50, i32 0, i32 0
  store %node* %46, %node** %52
  %53 = getelementptr inbounds %node, %node* %50, i32 0, i32 2
  store i32 4, i32* %53
  %malloccall22 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %54 = bitcast i8* %malloccall22 to %node*
  %55 = getelementptr inbounds %node, %node* %54, i32 0, i32 1
  store i8* getelementptr inbounds ([7 x i8], [7 x i8]* @17, i32 0, i32 0), i8** %55
  %56 = getelementptr inbounds %node, %node* %54, i32 0, i32 0
  store %node* %50, %node** %56
  %57 = getelementptr inbounds %node, %node* %54, i32 0, i32 2
  store i32 5, i32* %57
  %malloccall23 = tail call i8* @malloc(i32 ptrtoint (%node* getelementptr (%node, %node* null, i32 1) to i32))
  %58 = bitcast i8* %malloccall23 to %node*
  %59 = getelementptr inbounds %node, %node* %58, i32 0, i32 1
  store i8* getelementptr inbounds ([9 x i8], [9 x i8]* @18, i32 0, i32 0), i8** %59
  %60 = getelementptr inbounds %node, %node* %58, i32 0, i32 0
  store %node* %54, %node** %60
  %61 = getelementptr inbounds %node, %node* %58, i32 0, i32 2
  store i32 6, i32* %61
  store %node* %58, %node** %l3
  %abra = alloca i32
  store i32 27, i32* %abra
  %printf24 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @19, i32 0, i32 0))
  %l325 = load %node*, %node** %l3
  %62 = getelementptr inbounds %node, %node* %l325, i32 0, i32 2
  %63 = load i32, i32* %62
  %printf26 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @ifs, i32 0, i32 0), i32 %63)
  %printf27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @20, i32 0, i32 0))
  %e228 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e2
  %64 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e228, i32 0, i32 1
  %65 = load i32, i32* %64
  %printf29 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @ifs, i32 0, i32 0), i32 %65)
  %printf30 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @21, i32 0, i32 0))
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
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @22, i32 0, i32 0))
  %e2 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %0 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e2, i32 0, i32 0
  %1 = load i8*, i8** %0
  %printf3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* %1)
  %printf4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @23, i32 0, i32 0))
  %e5 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %2 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e5, i32 0, i32 1
  %3 = load i32, i32* %2
  %printf6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @ifs.4, i32 0, i32 0), i32 %3)
  %printf7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @24, i32 0, i32 0))
  %e8 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %4 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e8, i32 0, i32 2
  %5 = load i8*, i8** %4
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* %5)
  %printf10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.5, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @25, i32 0, i32 0))
  %printf11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs.6, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @26, i32 0, i32 0))
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

declare void @free(i8*)
