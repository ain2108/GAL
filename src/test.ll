; ModuleID = 'GAL'

@ifs = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@sfs = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@0 = private unnamed_addr constant [16 x i8] c"\22goodbye world\22\00"
@ifs.1 = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@sfs.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %a = alloca i32
  store i32 1, i32* %a
  %b = alloca i32
  store i32 3, i32* %b
  %b1 = load i32, i32* %b
  %a2 = load i32, i32* %a
  %sum_result = call i32 @sum(i32 %a2, i32 %b1)
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ifs, i32 0, i32 0), i32 %sum_result)
  %printf3 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @0, i32 0, i32 0))
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
