; ModuleID = 'GAL'

@ifs = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@sfs = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@0 = private unnamed_addr constant [4 x i8] c"\22A\22\00"
@1 = private unnamed_addr constant [4 x i8] c"\22B\22\00"
@2 = private unnamed_addr constant [10 x i8] c"\22goodbye\22\00"
@ifs.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@sfs.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %e1 = alloca { i8*, i32, i8* }*
  %0 = alloca { i8*, i32, i8* }
  %1 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 0
  %2 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 1
  %3 = getelementptr inbounds { i8*, i32, i8* }, { i8*, i32, i8* }* %0, i32 0, i32 2
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @0, i32 0, i32 0), i8** %1
  store i8* getelementptr inbounds ([4 x i8], [4 x i8]* @1, i32 0, i32 0), i8** %3
  store i32 2, i32* %2
  store { i8*, i32, i8* }* %0, { i8*, i32, i8* }** %e1
  %hello = alloca i8*
  store i8* getelementptr inbounds ([10 x i8], [10 x i8]* @2, i32 0, i32 0), i8** %hello
  %b = alloca i32
  store i32 3, i32* %b
  %hello1 = load i8*, i8** %hello
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @sfs, i32 0, i32 0), i8* %hello1)
  ret i32 1
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
