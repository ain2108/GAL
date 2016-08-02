; ModuleID = 'GAL'

@ifs = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs = private unnamed_addr constant [3 x i8] c"%s\00"
@efs = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@0 = private unnamed_addr constant [2 x i8] c"A\00"
@1 = private unnamed_addr constant [2 x i8] c"B\00"
@2 = private unnamed_addr constant [8 x i8] c"goodbye\00"
@3 = private unnamed_addr constant [16 x i8] c"AlphaAlphaAlpha\00"
@4 = private unnamed_addr constant [2 x i8] c"C\00"
@5 = private unnamed_addr constant [6 x i8] c"hello\00"
@ifs.1 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.2 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.3 = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@6 = private unnamed_addr constant [2 x i8] c"(\00"
@7 = private unnamed_addr constant [3 x i8] c", \00"
@8 = private unnamed_addr constant [3 x i8] c", \00"
@9 = private unnamed_addr constant [2 x i8] c")\00"
@10 = private unnamed_addr constant [1 x i8] zeroinitializer
@ifs.4 = private unnamed_addr constant [3 x i8] c"%d\00"
@sfs.5 = private unnamed_addr constant [3 x i8] c"%s\00"
@efs.6 = private unnamed_addr constant [4 x i8] c"%s\0A\00"

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
  %e2 = alloca { i8*, i32, i8* }*
  %malloccall1 = tail call i8* @malloc(i32 ptrtoint ({ i8*, i32, i8* }* getelementptr ({ i8*, i32, i8* }, { i8*, i32, i8* }* null, i32 1) to i32))
  %5 = bitcast i8* %malloccall1 to { i8*, i32, i8* }*
  %6 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %5, i32 0, i32 0
  %7 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %5, i32 0, i32 1
  %8 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %5, i32 0, i32 2
  store i8* getelementptr inbounds ([16 x i8], [16 x i8]* @3, i32 0, i32 0), i8** %6
  store i8* getelementptr inbounds ([2 x i8], [2 x i8]* @4, i32 0, i32 0), i8** %8
  store i32 3, i32* %7
  %9 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %5, i32 0
  store { i8*, i32, i8* }* %9, { i8*, i32, i8* }** %e2
  %e12 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %print_edge_result = call i32 @print_edge({ i8*, i32, i8* }* %e12)
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([6 x i8], [6 x i8]* @5, i32 0, i32 0))
  %b = alloca i32
  store i32 3, i32* %b
  ret i32 1
}

define i32 @print_edge({ i8*, i32, i8* }* %e) {
entry:
  %e1 = alloca { i8*, i32, i8* }*
  store { i8*, i32, i8* }* %e, { i8*, i32, i8* }** %e1
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.2, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @6, i32 0, i32 0))
  %e2 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %0 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e2, i32 0, i32 0
  %1 = load i8*, i8** %0
  %printf3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.2, i32 0, i32 0), i8* %1)
  %printf4 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.2, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @7, i32 0, i32 0))
  %e5 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %2 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e5, i32 0, i32 1
  %3 = load i32, i32* %2
  %printf6 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @ifs.1, i32 0, i32 0), i32 %3)
  %printf7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.2, i32 0, i32 0), i8* getelementptr inbounds ([3 x i8], [3 x i8]* @8, i32 0, i32 0))
  %e8 = load { i8*, i32, i8* }*, { i8*, i32, i8* }** %e1
  %4 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %e8, i32 0, i32 2
  %5 = load i8*, i8** %4
  %printf9 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.2, i32 0, i32 0), i8* %5)
  %printf10 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @sfs.2, i32 0, i32 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @9, i32 0, i32 0))
  %printf11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @efs.3, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @10, i32 0, i32 0))
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
