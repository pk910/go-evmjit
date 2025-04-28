; ModuleID = './evm-c/evm_stack.c'
source_filename = "./evm-c/evm_stack.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.evm_stack = type { i8*, i64 }

@.str = private unnamed_addr constant [17 x i8] c"Stack[%d/%d]: 0x\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1

; Function Attrs: mustprogress nounwind uwtable willreturn
define dso_local noalias %struct.evm_stack* @stack_init() local_unnamed_addr #0 {
  %1 = tail call noalias dereferenceable_or_null(16) i8* @malloc(i64 noundef 16) #10
  %2 = bitcast i8* %1 to %struct.evm_stack*
  %3 = icmp eq i8* %1, null
  br i1 %3, label %11, label %4

4:                                                ; preds = %0
  %5 = tail call noalias dereferenceable_or_null(8192) i8* @malloc(i64 noundef 8192) #10
  %6 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %2, i64 0, i32 0
  store i8* %5, i8** %6, align 8, !tbaa !5
  %7 = icmp eq i8* %5, null
  br i1 %7, label %8, label %9

8:                                                ; preds = %4
  tail call void @free(i8* noundef nonnull %1) #10
  br label %11

9:                                                ; preds = %4
  %10 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %2, i64 0, i32 1
  store i64 0, i64* %10, align 8, !tbaa !11
  br label %11

11:                                               ; preds = %0, %9, %8
  %12 = phi %struct.evm_stack* [ %2, %9 ], [ null, %8 ], [ null, %0 ]
  ret %struct.evm_stack* %12
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #3

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: mustprogress nounwind uwtable willreturn
define dso_local void @stack_free(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %3 = load i8*, i8** %2, align 8, !tbaa !5
  tail call void @free(i8* noundef %3) #10
  %4 = bitcast %struct.evm_stack* %0 to i8*
  tail call void @free(i8* noundef %4) #10
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind uwtable willreturn
define dso_local i32 @stack_push(%struct.evm_stack* nocapture noundef %0, i8* nocapture noundef readonly %1) local_unnamed_addr #4 {
  %3 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %4 = load i8*, i8** %3, align 8, !tbaa !5
  %5 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %6 = load i64, i64* %5, align 8, !tbaa !11
  %7 = getelementptr inbounds i8, i8* %4, i64 %6
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %7, i8* noundef nonnull align 1 dereferenceable(32) %1, i64 32, i1 false)
  %8 = load i64, i64* %5, align 8, !tbaa !11
  %9 = add i64 %8, 32
  store i64 %9, i64* %5, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5

; Function Attrs: mustprogress nofree nosync nounwind uwtable willreturn
define dso_local i32 @stack_dupn(%struct.evm_stack* nocapture noundef %0, i32 noundef %1) local_unnamed_addr #4 {
  %3 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %4 = load i8*, i8** %3, align 8, !tbaa !5
  %5 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %6 = load i64, i64* %5, align 8, !tbaa !11
  %7 = getelementptr inbounds i8, i8* %4, i64 %6
  %8 = shl nsw i32 %1, 5
  %9 = sext i32 %8 to i64
  %10 = sub nsw i64 0, %9
  %11 = getelementptr inbounds i8, i8* %7, i64 %10
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %7, i8* noundef nonnull align 1 dereferenceable(32) %11, i64 32, i1 false)
  %12 = load i64, i64* %5, align 8, !tbaa !11
  %13 = add i64 %12, 32
  store i64 %13, i64* %5, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: mustprogress nofree nosync nounwind uwtable willreturn
define dso_local i32 @stack_swapn(%struct.evm_stack* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #4 {
  %3 = alloca [32 x i8], align 16
  %4 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %5 = load i8*, i8** %4, align 8, !tbaa !5
  %6 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %7 = load i64, i64* %6, align 8, !tbaa !11
  %8 = getelementptr inbounds i8, i8* %5, i64 %7
  %9 = getelementptr inbounds i8, i8* %8, i64 -32
  %10 = shl nsw i32 %1, 5
  %11 = sext i32 %10 to i64
  %12 = sub nsw i64 0, %11
  %13 = getelementptr inbounds i8, i8* %9, i64 %12
  %14 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %14)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %14, i8* noundef nonnull align 1 dereferenceable(32) %9, i64 32, i1 false)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %9, i8* noundef nonnull align 1 dereferenceable(32) %13, i64 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %13, i8* noundef nonnull align 16 dereferenceable(32) %14, i64 32, i1 false)
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %14)
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind uwtable willreturn
define dso_local i32 @stack_pop(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #6 {
  %2 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %3 = load i64, i64* %2, align 8, !tbaa !11
  %4 = add i64 %3, -32
  store i64 %4, i64* %2, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @stack_print_item(%struct.evm_stack* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #7 {
  %3 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %4 = load i8*, i8** %3, align 8, !tbaa !5
  %5 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %6 = load i64, i64* %5, align 8, !tbaa !11
  %7 = getelementptr inbounds i8, i8* %4, i64 %6
  %8 = shl nsw i32 %1, 5
  %9 = sext i32 %8 to i64
  %10 = sub nsw i64 0, %9
  %11 = getelementptr inbounds i8, i8* %7, i64 %10
  %12 = lshr i64 %6, 5
  %13 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([17 x i8], [17 x i8]* @.str, i64 0, i64 0), i32 noundef %1, i64 noundef %12)
  %14 = load i8, i8* %11, align 1, !tbaa !12
  %15 = zext i8 %14 to i32
  %16 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %15)
  %17 = getelementptr inbounds i8, i8* %11, i64 1
  %18 = load i8, i8* %17, align 1, !tbaa !12
  %19 = zext i8 %18 to i32
  %20 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %19)
  %21 = getelementptr inbounds i8, i8* %11, i64 2
  %22 = load i8, i8* %21, align 1, !tbaa !12
  %23 = zext i8 %22 to i32
  %24 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %23)
  %25 = getelementptr inbounds i8, i8* %11, i64 3
  %26 = load i8, i8* %25, align 1, !tbaa !12
  %27 = zext i8 %26 to i32
  %28 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %27)
  %29 = getelementptr inbounds i8, i8* %11, i64 4
  %30 = load i8, i8* %29, align 1, !tbaa !12
  %31 = zext i8 %30 to i32
  %32 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %31)
  %33 = getelementptr inbounds i8, i8* %11, i64 5
  %34 = load i8, i8* %33, align 1, !tbaa !12
  %35 = zext i8 %34 to i32
  %36 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %35)
  %37 = getelementptr inbounds i8, i8* %11, i64 6
  %38 = load i8, i8* %37, align 1, !tbaa !12
  %39 = zext i8 %38 to i32
  %40 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %39)
  %41 = getelementptr inbounds i8, i8* %11, i64 7
  %42 = load i8, i8* %41, align 1, !tbaa !12
  %43 = zext i8 %42 to i32
  %44 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %43)
  %45 = getelementptr inbounds i8, i8* %11, i64 8
  %46 = load i8, i8* %45, align 1, !tbaa !12
  %47 = zext i8 %46 to i32
  %48 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %47)
  %49 = getelementptr inbounds i8, i8* %11, i64 9
  %50 = load i8, i8* %49, align 1, !tbaa !12
  %51 = zext i8 %50 to i32
  %52 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %51)
  %53 = getelementptr inbounds i8, i8* %11, i64 10
  %54 = load i8, i8* %53, align 1, !tbaa !12
  %55 = zext i8 %54 to i32
  %56 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %55)
  %57 = getelementptr inbounds i8, i8* %11, i64 11
  %58 = load i8, i8* %57, align 1, !tbaa !12
  %59 = zext i8 %58 to i32
  %60 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %59)
  %61 = getelementptr inbounds i8, i8* %11, i64 12
  %62 = load i8, i8* %61, align 1, !tbaa !12
  %63 = zext i8 %62 to i32
  %64 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %63)
  %65 = getelementptr inbounds i8, i8* %11, i64 13
  %66 = load i8, i8* %65, align 1, !tbaa !12
  %67 = zext i8 %66 to i32
  %68 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %67)
  %69 = getelementptr inbounds i8, i8* %11, i64 14
  %70 = load i8, i8* %69, align 1, !tbaa !12
  %71 = zext i8 %70 to i32
  %72 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %71)
  %73 = getelementptr inbounds i8, i8* %11, i64 15
  %74 = load i8, i8* %73, align 1, !tbaa !12
  %75 = zext i8 %74 to i32
  %76 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %75)
  %77 = getelementptr inbounds i8, i8* %11, i64 16
  %78 = load i8, i8* %77, align 1, !tbaa !12
  %79 = zext i8 %78 to i32
  %80 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %79)
  %81 = getelementptr inbounds i8, i8* %11, i64 17
  %82 = load i8, i8* %81, align 1, !tbaa !12
  %83 = zext i8 %82 to i32
  %84 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %83)
  %85 = getelementptr inbounds i8, i8* %11, i64 18
  %86 = load i8, i8* %85, align 1, !tbaa !12
  %87 = zext i8 %86 to i32
  %88 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %87)
  %89 = getelementptr inbounds i8, i8* %11, i64 19
  %90 = load i8, i8* %89, align 1, !tbaa !12
  %91 = zext i8 %90 to i32
  %92 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %91)
  %93 = getelementptr inbounds i8, i8* %11, i64 20
  %94 = load i8, i8* %93, align 1, !tbaa !12
  %95 = zext i8 %94 to i32
  %96 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %95)
  %97 = getelementptr inbounds i8, i8* %11, i64 21
  %98 = load i8, i8* %97, align 1, !tbaa !12
  %99 = zext i8 %98 to i32
  %100 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %99)
  %101 = getelementptr inbounds i8, i8* %11, i64 22
  %102 = load i8, i8* %101, align 1, !tbaa !12
  %103 = zext i8 %102 to i32
  %104 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %103)
  %105 = getelementptr inbounds i8, i8* %11, i64 23
  %106 = load i8, i8* %105, align 1, !tbaa !12
  %107 = zext i8 %106 to i32
  %108 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %107)
  %109 = getelementptr inbounds i8, i8* %11, i64 24
  %110 = load i8, i8* %109, align 1, !tbaa !12
  %111 = zext i8 %110 to i32
  %112 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %111)
  %113 = getelementptr inbounds i8, i8* %11, i64 25
  %114 = load i8, i8* %113, align 1, !tbaa !12
  %115 = zext i8 %114 to i32
  %116 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %115)
  %117 = getelementptr inbounds i8, i8* %11, i64 26
  %118 = load i8, i8* %117, align 1, !tbaa !12
  %119 = zext i8 %118 to i32
  %120 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %119)
  %121 = getelementptr inbounds i8, i8* %11, i64 27
  %122 = load i8, i8* %121, align 1, !tbaa !12
  %123 = zext i8 %122 to i32
  %124 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %123)
  %125 = getelementptr inbounds i8, i8* %11, i64 28
  %126 = load i8, i8* %125, align 1, !tbaa !12
  %127 = zext i8 %126 to i32
  %128 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %127)
  %129 = getelementptr inbounds i8, i8* %11, i64 29
  %130 = load i8, i8* %129, align 1, !tbaa !12
  %131 = zext i8 %130 to i32
  %132 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %131)
  %133 = getelementptr inbounds i8, i8* %11, i64 30
  %134 = load i8, i8* %133, align 1, !tbaa !12
  %135 = zext i8 %134 to i32
  %136 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %135)
  %137 = getelementptr inbounds i8, i8* %11, i64 31
  %138 = load i8, i8* %137, align 1, !tbaa !12
  %139 = zext i8 %138 to i32
  %140 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([5 x i8], [5 x i8]* @.str.1, i64 0, i64 0), i32 noundef %139)
  %141 = tail call i32 @putchar(i32 10)
  ret i32 0
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #8

; Function Attrs: nofree nounwind
declare noundef i32 @putchar(i32 noundef) local_unnamed_addr #9

attributes #0 = { mustprogress nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { mustprogress nofree nosync nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #6 = { mustprogress nofree norecurse nosync nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { nofree nounwind }
attributes #10 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Debian clang version 14.0.6"}
!5 = !{!6, !7, i64 0}
!6 = !{!"evm_stack", !7, i64 0, !10, i64 8}
!7 = !{!"any pointer", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!"long", !8, i64 0}
!11 = !{!6, !10, i64 8}
!12 = !{!8, !8, i64 0}
