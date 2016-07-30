; ModuleID = 'GAL'

@ifs = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@sfs = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@0 = private unnamed_addr constant [16 x i8] c"\22goodbye world\22\00"

declare i32 @printf(i8*, ...)

define i32 @main() {
entry:
  %printf = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @ifs, i32 0, i32 0), i32 1)
  %printf1 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @sfs, i32 0, i32 0), i8* getelementptr inbounds ([16 x i8], [16 x i8]* @0, i32 0, i32 0))
  ret i32 1
}
