; ModuleID = './tmp/combined.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.evm_stack = type { i8*, i64 }

@.str = private unnamed_addr constant [17 x i8] c"Stack[%d/%d]: 0x\00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@const_push32_1 = local_unnamed_addr constant [32 x i8] c"\AB\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF\FF"
@const_push32_2 = local_unnamed_addr constant [32 x i8] c"\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA\CA"
@const_zero32 = local_unnamed_addr constant [32 x i8] zeroinitializer
@const_data1 = local_unnamed_addr constant [6 x i8] c"333333"
@const_data2 = local_unnamed_addr constant [8 x i8] c"\11\11\11\11\11\11\11\11"

; Function Attrs: mustprogress nounwind uwtable willreturn
define dso_local noalias %struct.evm_stack* @stack_init() local_unnamed_addr #0 {
  %1 = tail call noalias dereferenceable_or_null(16) i8* @malloc(i64 noundef 16) #13
  %2 = bitcast i8* %1 to %struct.evm_stack*
  %3 = icmp eq i8* %1, null
  br i1 %3, label %11, label %4

4:                                                ; preds = %0
  %5 = tail call noalias dereferenceable_or_null(8192) i8* @malloc(i64 noundef 8192) #13
  %6 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %2, i64 0, i32 0
  store i8* %5, i8** %6, align 8, !tbaa !5
  %7 = icmp eq i8* %5, null
  br i1 %7, label %8, label %9

8:                                                ; preds = %4
  tail call void @free(i8* noundef nonnull %1) #13
  br label %11

9:                                                ; preds = %4
  %10 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %2, i64 0, i32 1
  store i64 0, i64* %10, align 8, !tbaa !11
  br label %11

11:                                               ; preds = %9, %8, %0
  %12 = phi %struct.evm_stack* [ %2, %9 ], [ null, %8 ], [ null, %0 ]
  ret %struct.evm_stack* %12
}

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #1

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #2

; Function Attrs: mustprogress nounwind uwtable willreturn
define dso_local void @stack_free(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #0 {
  %2 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %3 = load i8*, i8** %2, align 8, !tbaa !5
  tail call void @free(i8* noundef %3) #13
  %4 = bitcast %struct.evm_stack* %0 to i8*
  tail call void @free(i8* noundef %4) #13
  ret void
}

; Function Attrs: mustprogress nofree nosync nounwind uwtable willreturn
define dso_local i32 @stack_push(%struct.evm_stack* nocapture noundef %0, i8* nocapture noundef readonly %1) local_unnamed_addr #3 {
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
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #4

; Function Attrs: mustprogress nofree nosync nounwind uwtable willreturn
define dso_local i32 @stack_dupn(%struct.evm_stack* nocapture noundef %0, i32 noundef %1) local_unnamed_addr #3 {
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
define dso_local i32 @stack_swapn(%struct.evm_stack* nocapture noundef readonly %0, i32 noundef %1) local_unnamed_addr #3 {
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

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #5

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #5

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

; Function Attrs: mustprogress nofree norecurse nosync nounwind uwtable willreturn
define dso_local i32 @math_add(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #6 {
  %2 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %3 = load i8*, i8** %2, align 8, !tbaa !5
  %4 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %5 = load i64, i64* %4, align 8, !tbaa !11
  %6 = getelementptr inbounds i8, i8* %3, i64 %5
  %7 = getelementptr inbounds i8, i8* %6, i64 -32
  %8 = getelementptr inbounds i8, i8* %7, i64 -32
  %9 = bitcast i8* %7 to i64*
  %10 = bitcast i8* %8 to i64*
  %11 = getelementptr inbounds i8, i8* %7, i64 24
  %12 = bitcast i8* %11 to i64*
  %13 = load i64, i64* %12, align 8, !tbaa !13
  %14 = getelementptr inbounds i8, i8* %8, i64 24
  %15 = bitcast i8* %14 to i64*
  %16 = load i64, i64* %15, align 8, !tbaa !13
  %17 = add i64 %16, %13
  %18 = icmp ult i64 %17, %13
  %19 = icmp ult i64 %17, %16
  %20 = or i1 %18, %19
  %21 = zext i1 %20 to i64
  store i64 %17, i64* %12, align 8, !tbaa !13
  %22 = getelementptr inbounds i8, i8* %7, i64 16
  %23 = bitcast i8* %22 to i64*
  %24 = load i64, i64* %23, align 8, !tbaa !13
  %25 = getelementptr inbounds i8, i8* %8, i64 16
  %26 = bitcast i8* %25 to i64*
  %27 = load i64, i64* %26, align 8, !tbaa !13
  %28 = add i64 %27, %24
  %29 = add i64 %28, %21
  %30 = icmp ult i64 %29, %24
  %31 = icmp ult i64 %29, %27
  %32 = or i1 %30, %31
  %33 = icmp eq i64 %29, %24
  %34 = icmp ne i64 %27, 0
  %35 = and i1 %34, %33
  %36 = or i1 %32, %35
  %37 = zext i1 %36 to i64
  store i64 %29, i64* %23, align 8, !tbaa !13
  %38 = getelementptr inbounds i8, i8* %7, i64 8
  %39 = bitcast i8* %38 to i64*
  %40 = load i64, i64* %39, align 8, !tbaa !13
  %41 = getelementptr inbounds i8, i8* %8, i64 8
  %42 = bitcast i8* %41 to i64*
  %43 = load i64, i64* %42, align 8, !tbaa !13
  %44 = add i64 %43, %40
  %45 = add i64 %44, %37
  %46 = icmp ult i64 %45, %40
  %47 = icmp ult i64 %45, %43
  %48 = or i1 %46, %47
  %49 = icmp eq i64 %45, %40
  %50 = icmp ne i64 %43, 0
  %51 = and i1 %50, %49
  %52 = or i1 %48, %51
  %53 = zext i1 %52 to i64
  store i64 %45, i64* %39, align 8, !tbaa !13
  %54 = load i64, i64* %9, align 8, !tbaa !13
  %55 = load i64, i64* %10, align 8, !tbaa !13
  %56 = add i64 %55, %54
  %57 = add i64 %56, %53
  store i64 %57, i64* %9, align 8, !tbaa !13
  %58 = load i64, i64* %4, align 8, !tbaa !11
  %59 = add i64 %58, -1
  store i64 %59, i64* %4, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind uwtable willreturn
define dso_local i32 @math_sub(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #6 {
  %2 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %3 = load i8*, i8** %2, align 8, !tbaa !5
  %4 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %5 = load i64, i64* %4, align 8, !tbaa !11
  %6 = getelementptr inbounds i8, i8* %3, i64 %5
  %7 = getelementptr inbounds i8, i8* %6, i64 -32
  %8 = getelementptr inbounds i8, i8* %7, i64 -32
  %9 = bitcast i8* %7 to i64*
  %10 = getelementptr inbounds i8, i8* %7, i64 24
  %11 = bitcast i8* %10 to i64*
  %12 = load i64, i64* %11, align 8, !tbaa !13
  %13 = getelementptr inbounds i8, i8* %8, i64 24
  %14 = bitcast i8* %13 to i64*
  %15 = load i64, i64* %14, align 8, !tbaa !13
  %16 = sub i64 %12, %15
  %17 = icmp ult i64 %12, %15
  store i64 %16, i64* %11, align 8, !tbaa !13
  %18 = getelementptr inbounds i8, i8* %7, i64 16
  %19 = bitcast i8* %18 to i64*
  %20 = load i64, i64* %19, align 8, !tbaa !13
  %21 = getelementptr inbounds i8, i8* %8, i64 16
  %22 = bitcast i8* %21 to i64*
  %23 = load i64, i64* %22, align 8, !tbaa !13
  %24 = icmp ult i64 %20, %23
  br i1 %24, label %28, label %25

25:                                               ; preds = %1
  %26 = icmp eq i64 %20, %23
  %27 = select i1 %26, i1 %17, i1 false
  br label %28

28:                                               ; preds = %25, %1
  %29 = phi i1 [ true, %1 ], [ %27, %25 ]
  %.neg10 = sext i1 %17 to i64
  %.neg3 = add i64 %20, %.neg10
  %30 = sub i64 %.neg3, %23
  %31 = bitcast i8* %8 to i64*
  %.neg = sext i1 %29 to i64
  store i64 %30, i64* %19, align 8, !tbaa !13
  %32 = getelementptr inbounds i8, i8* %7, i64 8
  %33 = bitcast i8* %32 to i64*
  %34 = load i64, i64* %33, align 8, !tbaa !13
  %35 = getelementptr inbounds i8, i8* %8, i64 8
  %36 = bitcast i8* %35 to i64*
  %37 = load i64, i64* %36, align 8, !tbaa !13
  %.neg6 = add i64 %34, %.neg
  %38 = sub i64 %.neg6, %37
  %39 = icmp ult i64 %34, %37
  %40 = icmp eq i64 %34, %37
  %41 = select i1 %40, i1 %29, i1 false
  %42 = select i1 %39, i1 true, i1 %41
  %.neg11 = sext i1 %42 to i64
  store i64 %38, i64* %33, align 8, !tbaa !13
  %43 = load i64, i64* %9, align 8, !tbaa !13
  %44 = load i64, i64* %31, align 8, !tbaa !13
  %.neg9 = sub i64 %43, %44
  %45 = add i64 %.neg9, %.neg11
  store i64 %45, i64* %9, align 8, !tbaa !13
  %46 = load i64, i64* %4, align 8, !tbaa !11
  %47 = add i64 %46, -1
  store i64 %47, i64* %4, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: nofree nosync nounwind uwtable
define dso_local i32 @math_mul(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #10 {
  %2 = alloca [64 x i16], align 16
  %3 = bitcast [64 x i16]* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %3) #13
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(128) %3, i8 0, i64 128, i1 false)
  %4 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %5 = load i64, i64* %4, align 8, !tbaa !11
  %6 = icmp ult i64 %5, 2
  br i1 %6, label %131, label %7

7:                                                ; preds = %1
  %8 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %9 = load i8*, i8** %8, align 8, !tbaa !5
  %10 = shl i64 %5, 5
  %11 = add i64 %10, -32
  %12 = getelementptr inbounds i8, i8* %9, i64 %11
  %13 = add i64 %10, -64
  %14 = getelementptr inbounds i8, i8* %9, i64 %13
  %15 = add i64 %5, -1
  store i64 %15, i64* %4, align 8, !tbaa !11
  %16 = getelementptr inbounds i8, i8* %12, i64 -7
  %17 = getelementptr inbounds i8, i8* %16, i64 31
  %18 = bitcast i8* %17 to <8 x i8>*
  %19 = load <8 x i8>, <8 x i8>* %18, align 1, !tbaa !12
  %20 = shufflevector <8 x i8> %19, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %21 = zext <8 x i8> %20 to <8 x i16>
  %22 = getelementptr inbounds i8, i8* %16, i64 23
  %23 = bitcast i8* %22 to <8 x i8>*
  %24 = load <8 x i8>, <8 x i8>* %23, align 1, !tbaa !12
  %25 = shufflevector <8 x i8> %24, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %26 = zext <8 x i8> %25 to <8 x i16>
  %27 = getelementptr inbounds i8, i8* %16, i64 15
  %28 = bitcast i8* %27 to <8 x i8>*
  %29 = load <8 x i8>, <8 x i8>* %28, align 1, !tbaa !12
  %30 = shufflevector <8 x i8> %29, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %31 = zext <8 x i8> %30 to <8 x i16>
  %32 = getelementptr inbounds i8, i8* %16, i64 7
  %33 = bitcast i8* %32 to <8 x i8>*
  %34 = load <8 x i8>, <8 x i8>* %33, align 1, !tbaa !12
  %35 = shufflevector <8 x i8> %34, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %36 = zext <8 x i8> %35 to <8 x i16>
  br label %37

37:                                               ; preds = %37, %7
  %38 = phi i64 [ 31, %7 ], [ %80, %37 ]
  %39 = getelementptr inbounds i8, i8* %14, i64 %38
  %40 = load i8, i8* %39, align 1, !tbaa !12
  %41 = zext i8 %40 to i16
  %42 = insertelement <8 x i16> poison, i16 %41, i64 0
  %43 = shufflevector <8 x i16> %42, <8 x i16> poison, <8 x i32> zeroinitializer
  %44 = add nuw nsw i64 %38, 32
  %45 = mul nuw <8 x i16> %43, %21
  %46 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %44
  %47 = getelementptr inbounds i16, i16* %46, i64 -7
  %48 = bitcast i16* %47 to <8 x i16>*
  %49 = load <8 x i16>, <8 x i16>* %48, align 2, !tbaa !14
  %50 = shufflevector <8 x i16> %49, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %51 = add <8 x i16> %45, %50
  %52 = shufflevector <8 x i16> %51, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i16> %52, <8 x i16>* %48, align 2, !tbaa !14
  %53 = add nuw nsw i64 %38, 24
  %54 = mul nuw <8 x i16> %43, %26
  %55 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %53
  %56 = getelementptr inbounds i16, i16* %55, i64 -7
  %57 = bitcast i16* %56 to <8 x i16>*
  %58 = load <8 x i16>, <8 x i16>* %57, align 2, !tbaa !14
  %59 = shufflevector <8 x i16> %58, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %60 = add <8 x i16> %54, %59
  %61 = shufflevector <8 x i16> %60, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i16> %61, <8 x i16>* %57, align 2, !tbaa !14
  %62 = add nuw nsw i64 %38, 16
  %63 = mul nuw <8 x i16> %43, %31
  %64 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %62
  %65 = getelementptr inbounds i16, i16* %64, i64 -7
  %66 = bitcast i16* %65 to <8 x i16>*
  %67 = load <8 x i16>, <8 x i16>* %66, align 2, !tbaa !14
  %68 = shufflevector <8 x i16> %67, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %69 = add <8 x i16> %68, %63
  %70 = shufflevector <8 x i16> %69, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i16> %70, <8 x i16>* %66, align 2, !tbaa !14
  %71 = add nuw nsw i64 %38, 8
  %72 = mul nuw <8 x i16> %43, %36
  %73 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %71
  %74 = getelementptr inbounds i16, i16* %73, i64 -7
  %75 = bitcast i16* %74 to <8 x i16>*
  %76 = load <8 x i16>, <8 x i16>* %75, align 2, !tbaa !14
  %77 = shufflevector <8 x i16> %76, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %78 = add <8 x i16> %77, %72
  %79 = shufflevector <8 x i16> %78, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  store <8 x i16> %79, <8 x i16>* %75, align 2, !tbaa !14
  %80 = add nsw i64 %38, -1
  %81 = icmp eq i64 %38, 0
  br i1 %81, label %82, label %37, !llvm.loop !16

82:                                               ; preds = %37
  %83 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 63
  %84 = load i16, i16* %83, align 2, !tbaa !14
  %85 = lshr i16 %84, 8
  %86 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 62
  %87 = load i16, i16* %86, align 4, !tbaa !14
  %88 = add i16 %87, %85
  store i16 %88, i16* %86, align 4, !tbaa !14
  %89 = and i16 %84, 255
  store i16 %89, i16* %83, align 2, !tbaa !14
  br label %90

90:                                               ; preds = %82, %90
  %91 = phi i16 [ %88, %82 ], [ %104, %90 ]
  %92 = phi i16* [ %86, %82 ], [ %102, %90 ]
  %93 = phi i64 [ 63, %82 ], [ %95, %90 ]
  %94 = lshr i16 %91, 8
  %95 = add nsw i64 %93, -2
  %96 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %95
  %97 = load i16, i16* %96, align 2, !tbaa !14
  %98 = add i16 %97, %94
  %99 = and i16 %91, 255
  store i16 %99, i16* %92, align 2, !tbaa !14
  %100 = lshr i16 %98, 8
  %101 = add nsw i64 %93, -3
  %102 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %101
  %103 = load i16, i16* %102, align 2, !tbaa !14
  %104 = add i16 %103, %100
  store i16 %104, i16* %102, align 2, !tbaa !14
  %105 = and i16 %98, 255
  store i16 %105, i16* %96, align 2, !tbaa !14
  %106 = icmp ugt i64 %95, 1
  br i1 %106, label %90, label %107, !llvm.loop !18

107:                                              ; preds = %90
  %108 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 32
  %109 = bitcast i16* %108 to <8 x i16>*
  %110 = load <8 x i16>, <8 x i16>* %109, align 16, !tbaa !14
  %111 = trunc <8 x i16> %110 to <8 x i8>
  %112 = bitcast i8* %14 to <8 x i8>*
  store <8 x i8> %111, <8 x i8>* %112, align 1, !tbaa !12
  %113 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 40
  %114 = bitcast i16* %113 to <8 x i16>*
  %115 = load <8 x i16>, <8 x i16>* %114, align 16, !tbaa !14
  %116 = trunc <8 x i16> %115 to <8 x i8>
  %117 = getelementptr inbounds i8, i8* %14, i64 8
  %118 = bitcast i8* %117 to <8 x i8>*
  store <8 x i8> %116, <8 x i8>* %118, align 1, !tbaa !12
  %119 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 48
  %120 = bitcast i16* %119 to <8 x i16>*
  %121 = load <8 x i16>, <8 x i16>* %120, align 16, !tbaa !14
  %122 = trunc <8 x i16> %121 to <8 x i8>
  %123 = getelementptr inbounds i8, i8* %14, i64 16
  %124 = bitcast i8* %123 to <8 x i8>*
  store <8 x i8> %122, <8 x i8>* %124, align 1, !tbaa !12
  %125 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 56
  %126 = bitcast i16* %125 to <8 x i16>*
  %127 = load <8 x i16>, <8 x i16>* %126, align 16, !tbaa !14
  %128 = trunc <8 x i16> %127 to <8 x i8>
  %129 = getelementptr inbounds i8, i8* %14, i64 24
  %130 = bitcast i8* %129 to <8 x i8>*
  store <8 x i8> %128, <8 x i8>* %130, align 1, !tbaa !12
  br label %131

131:                                              ; preds = %107, %1
  %132 = phi i32 [ -3, %1 ], [ 0, %107 ]
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %3) #13
  ret i32 %132
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #11

; Function Attrs: nofree nounwind uwtable
define dso_local i32 @math_div(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #7 {
  %2 = alloca [32 x i8], align 16
  %3 = alloca [32 x i8], align 16
  %4 = alloca [32 x i8], align 16
  %5 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %6 = load i64, i64* %5, align 8, !tbaa !11
  %7 = icmp ult i64 %6, 2
  br i1 %7, label %228, label %8

8:                                                ; preds = %1
  %9 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 0
  %10 = load i8*, i8** %9, align 8, !tbaa !5
  %11 = shl i64 %6, 5
  %12 = add i64 %11, -32
  %13 = getelementptr inbounds i8, i8* %10, i64 %12
  %14 = add i64 %11, -64
  %15 = getelementptr inbounds i8, i8* %10, i64 %14
  %16 = add i64 %6, -2
  store i64 %16, i64* %5, align 8, !tbaa !11
  %17 = load i8, i8* %13, align 1, !tbaa !12
  %18 = icmp eq i8 %17, 0
  br i1 %18, label %19, label %143

19:                                               ; preds = %8
  %20 = getelementptr inbounds i8, i8* %13, i64 1
  %21 = load i8, i8* %20, align 1, !tbaa !12
  %22 = icmp eq i8 %21, 0
  br i1 %22, label %23, label %143

23:                                               ; preds = %19
  %24 = getelementptr inbounds i8, i8* %13, i64 2
  %25 = load i8, i8* %24, align 1, !tbaa !12
  %26 = icmp eq i8 %25, 0
  br i1 %26, label %27, label %143

27:                                               ; preds = %23
  %28 = getelementptr inbounds i8, i8* %13, i64 3
  %29 = load i8, i8* %28, align 1, !tbaa !12
  %30 = icmp eq i8 %29, 0
  br i1 %30, label %31, label %143

31:                                               ; preds = %27
  %32 = getelementptr inbounds i8, i8* %13, i64 4
  %33 = load i8, i8* %32, align 1, !tbaa !12
  %34 = icmp eq i8 %33, 0
  br i1 %34, label %35, label %143

35:                                               ; preds = %31
  %36 = getelementptr inbounds i8, i8* %13, i64 5
  %37 = load i8, i8* %36, align 1, !tbaa !12
  %38 = icmp eq i8 %37, 0
  br i1 %38, label %39, label %143

39:                                               ; preds = %35
  %40 = getelementptr inbounds i8, i8* %13, i64 6
  %41 = load i8, i8* %40, align 1, !tbaa !12
  %42 = icmp eq i8 %41, 0
  br i1 %42, label %43, label %143

43:                                               ; preds = %39
  %44 = getelementptr inbounds i8, i8* %13, i64 7
  %45 = load i8, i8* %44, align 1, !tbaa !12
  %46 = icmp eq i8 %45, 0
  br i1 %46, label %47, label %143

47:                                               ; preds = %43
  %48 = getelementptr inbounds i8, i8* %13, i64 8
  %49 = load i8, i8* %48, align 1, !tbaa !12
  %50 = icmp eq i8 %49, 0
  br i1 %50, label %51, label %143

51:                                               ; preds = %47
  %52 = getelementptr inbounds i8, i8* %13, i64 9
  %53 = load i8, i8* %52, align 1, !tbaa !12
  %54 = icmp eq i8 %53, 0
  br i1 %54, label %55, label %143

55:                                               ; preds = %51
  %56 = getelementptr inbounds i8, i8* %13, i64 10
  %57 = load i8, i8* %56, align 1, !tbaa !12
  %58 = icmp eq i8 %57, 0
  br i1 %58, label %59, label %143

59:                                               ; preds = %55
  %60 = getelementptr inbounds i8, i8* %13, i64 11
  %61 = load i8, i8* %60, align 1, !tbaa !12
  %62 = icmp eq i8 %61, 0
  br i1 %62, label %63, label %143

63:                                               ; preds = %59
  %64 = getelementptr inbounds i8, i8* %13, i64 12
  %65 = load i8, i8* %64, align 1, !tbaa !12
  %66 = icmp eq i8 %65, 0
  br i1 %66, label %67, label %143

67:                                               ; preds = %63
  %68 = getelementptr inbounds i8, i8* %13, i64 13
  %69 = load i8, i8* %68, align 1, !tbaa !12
  %70 = icmp eq i8 %69, 0
  br i1 %70, label %71, label %143

71:                                               ; preds = %67
  %72 = getelementptr inbounds i8, i8* %13, i64 14
  %73 = load i8, i8* %72, align 1, !tbaa !12
  %74 = icmp eq i8 %73, 0
  br i1 %74, label %75, label %143

75:                                               ; preds = %71
  %76 = getelementptr inbounds i8, i8* %13, i64 15
  %77 = load i8, i8* %76, align 1, !tbaa !12
  %78 = icmp eq i8 %77, 0
  br i1 %78, label %79, label %143

79:                                               ; preds = %75
  %80 = getelementptr inbounds i8, i8* %13, i64 16
  %81 = load i8, i8* %80, align 1, !tbaa !12
  %82 = icmp eq i8 %81, 0
  br i1 %82, label %83, label %143

83:                                               ; preds = %79
  %84 = getelementptr inbounds i8, i8* %13, i64 17
  %85 = load i8, i8* %84, align 1, !tbaa !12
  %86 = icmp eq i8 %85, 0
  br i1 %86, label %87, label %143

87:                                               ; preds = %83
  %88 = getelementptr inbounds i8, i8* %13, i64 18
  %89 = load i8, i8* %88, align 1, !tbaa !12
  %90 = icmp eq i8 %89, 0
  br i1 %90, label %91, label %143

91:                                               ; preds = %87
  %92 = getelementptr inbounds i8, i8* %13, i64 19
  %93 = load i8, i8* %92, align 1, !tbaa !12
  %94 = icmp eq i8 %93, 0
  br i1 %94, label %95, label %143

95:                                               ; preds = %91
  %96 = getelementptr inbounds i8, i8* %13, i64 20
  %97 = load i8, i8* %96, align 1, !tbaa !12
  %98 = icmp eq i8 %97, 0
  br i1 %98, label %99, label %143

99:                                               ; preds = %95
  %100 = getelementptr inbounds i8, i8* %13, i64 21
  %101 = load i8, i8* %100, align 1, !tbaa !12
  %102 = icmp eq i8 %101, 0
  br i1 %102, label %103, label %143

103:                                              ; preds = %99
  %104 = getelementptr inbounds i8, i8* %13, i64 22
  %105 = load i8, i8* %104, align 1, !tbaa !12
  %106 = icmp eq i8 %105, 0
  br i1 %106, label %107, label %143

107:                                              ; preds = %103
  %108 = getelementptr inbounds i8, i8* %13, i64 23
  %109 = load i8, i8* %108, align 1, !tbaa !12
  %110 = icmp eq i8 %109, 0
  br i1 %110, label %111, label %143

111:                                              ; preds = %107
  %112 = getelementptr inbounds i8, i8* %13, i64 24
  %113 = load i8, i8* %112, align 1, !tbaa !12
  %114 = icmp eq i8 %113, 0
  br i1 %114, label %115, label %143

115:                                              ; preds = %111
  %116 = getelementptr inbounds i8, i8* %13, i64 25
  %117 = load i8, i8* %116, align 1, !tbaa !12
  %118 = icmp eq i8 %117, 0
  br i1 %118, label %119, label %143

119:                                              ; preds = %115
  %120 = getelementptr inbounds i8, i8* %13, i64 26
  %121 = load i8, i8* %120, align 1, !tbaa !12
  %122 = icmp eq i8 %121, 0
  br i1 %122, label %123, label %143

123:                                              ; preds = %119
  %124 = getelementptr inbounds i8, i8* %13, i64 27
  %125 = load i8, i8* %124, align 1, !tbaa !12
  %126 = icmp eq i8 %125, 0
  br i1 %126, label %127, label %143

127:                                              ; preds = %123
  %128 = getelementptr inbounds i8, i8* %13, i64 28
  %129 = load i8, i8* %128, align 1, !tbaa !12
  %130 = icmp eq i8 %129, 0
  br i1 %130, label %131, label %143

131:                                              ; preds = %127
  %132 = getelementptr inbounds i8, i8* %13, i64 29
  %133 = load i8, i8* %132, align 1, !tbaa !12
  %134 = icmp eq i8 %133, 0
  br i1 %134, label %135, label %143

135:                                              ; preds = %131
  %136 = getelementptr inbounds i8, i8* %13, i64 30
  %137 = load i8, i8* %136, align 1, !tbaa !12
  %138 = icmp eq i8 %137, 0
  br i1 %138, label %139, label %143

139:                                              ; preds = %135
  %140 = getelementptr inbounds i8, i8* %13, i64 31
  %141 = load i8, i8* %140, align 1, !tbaa !12
  %142 = icmp eq i8 %141, 0
  br i1 %142, label %228, label %143

143:                                              ; preds = %139, %135, %131, %127, %123, %119, %115, %111, %107, %103, %99, %95, %91, %87, %83, %79, %75, %71, %67, %63, %59, %55, %51, %47, %43, %39, %35, %31, %27, %23, %19, %8
  %144 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %144) #13
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %144, i8 0, i64 32, i1 false)
  %145 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %145) #13
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %145, i8 0, i64 32, i1 false)
  %146 = getelementptr inbounds [32 x i8], [32 x i8]* %4, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %146) #13
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %146, i8* noundef nonnull align 1 dereferenceable(32) %15, i64 32, i1 false)
  %147 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 31
  br label %148

148:                                              ; preds = %._crit_edge, %143
  %149 = phi i8 [ 0, %143 ], [ %.pre, %._crit_edge ]
  %150 = phi i32 [ 0, %143 ], [ %226, %._crit_edge ]
  %151 = shl i8 %149, 1
  store i8 %151, i8* %145, align 16, !tbaa !12
  br label %166

152:                                              ; preds = %225
  %153 = getelementptr inbounds i8, i8* %10, i64 %16
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %153, i8* noundef nonnull align 16 dereferenceable(32) %144, i64 32, i1 false) #13
  %154 = load i64, i64* %5, align 8, !tbaa !11
  %155 = add i64 %154, 32
  store i64 %155, i64* %5, align 8, !tbaa !11
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %146) #13
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %145) #13
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %144) #13
  br label %228

156:                                              ; preds = %176
  %157 = lshr i32 %150, 3
  %158 = zext i32 %157 to i64
  %159 = getelementptr inbounds [32 x i8], [32 x i8]* %4, i64 0, i64 %158
  %160 = load i8, i8* %159, align 1, !tbaa !12
  %161 = zext i8 %160 to i32
  %162 = and i32 %150, 7
  %163 = lshr i32 128, %162
  %164 = and i32 %163, %161
  %165 = icmp eq i32 %164, 0
  br i1 %165, label %192, label %189

166:                                              ; preds = %187, %148
  %167 = phi i8 [ %151, %148 ], [ %188, %187 ]
  %168 = phi i8* [ %145, %148 ], [ %182, %187 ]
  %169 = phi i64 [ 0, %148 ], [ %181, %187 ]
  %170 = or i64 %169, 1
  %171 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %170
  %172 = load i8, i8* %171, align 1, !tbaa !12
  %173 = icmp sgt i8 %172, -1
  br i1 %173, label %176, label %174

174:                                              ; preds = %166
  %175 = or i8 %167, 1
  store i8 %175, i8* %168, align 1, !tbaa !12
  %.pre2 = load i8, i8* %171, align 1, !tbaa !12
  br label %176

176:                                              ; preds = %174, %166
  %177 = phi i8 [ %.pre2, %174 ], [ %172, %166 ]
  %178 = shl i8 %177, 1
  store i8 %178, i8* %171, align 1, !tbaa !12
  %179 = icmp eq i64 %170, 31
  br i1 %179, label %156, label %180

180:                                              ; preds = %176
  %181 = add nuw nsw i64 %169, 2
  %182 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %181
  %183 = load i8, i8* %182, align 2, !tbaa !12
  %184 = icmp sgt i8 %183, -1
  br i1 %184, label %187, label %185

185:                                              ; preds = %180
  %186 = or i8 %178, 1
  store i8 %186, i8* %171, align 1, !tbaa !12
  br label %187

187:                                              ; preds = %185, %180
  %188 = shl i8 %183, 1
  store i8 %188, i8* %182, align 2, !tbaa !12
  br label %166

189:                                              ; preds = %156
  %190 = load i8, i8* %147, align 1, !tbaa !12
  %191 = or i8 %190, 1
  store i8 %191, i8* %147, align 1, !tbaa !12
  br label %192

192:                                              ; preds = %189, %156
  %193 = call i32 @memcmp(i8* noundef nonnull dereferenceable(32) %145, i8* noundef nonnull dereferenceable(32) %13, i64 noundef 32) #14
  %194 = icmp sgt i32 %193, -1
  br i1 %194, label %.preheader, label %225

195:                                              ; preds = %.preheader
  %196 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i64 0, i64 %158
  %197 = load i8, i8* %196, align 1, !tbaa !12
  %198 = trunc i32 %163 to i8
  %199 = or i8 %197, %198
  store i8 %199, i8* %196, align 1, !tbaa !12
  br label %225

.preheader:                                       ; preds = %192, %.preheader
  %200 = phi i64 [ %223, %.preheader ], [ 31, %192 ]
  %201 = phi i32 [ %221, %.preheader ], [ 0, %192 ]
  %202 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %200
  %203 = load i8, i8* %202, align 1, !tbaa !12
  %204 = zext i8 %203 to i32
  %205 = getelementptr inbounds i8, i8* %13, i64 %200
  %206 = load i8, i8* %205, align 1, !tbaa !12
  %207 = zext i8 %206 to i32
  %208 = sub nsw i32 %204, %207
  %209 = add nsw i32 %208, %201
  %210 = ashr i32 %209, 31
  %211 = trunc i32 %209 to i8
  store i8 %211, i8* %202, align 1, !tbaa !12
  %212 = add nsw i64 %200, -1
  %213 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %212
  %214 = load i8, i8* %213, align 1, !tbaa !12
  %215 = zext i8 %214 to i32
  %216 = getelementptr inbounds i8, i8* %13, i64 %212
  %217 = load i8, i8* %216, align 1, !tbaa !12
  %218 = zext i8 %217 to i32
  %219 = sub nsw i32 %215, %218
  %220 = add nsw i32 %219, %210
  %221 = ashr i32 %220, 31
  %222 = trunc i32 %220 to i8
  store i8 %222, i8* %213, align 1, !tbaa !12
  %223 = add nsw i64 %200, -2
  %224 = icmp eq i64 %212, 0
  br i1 %224, label %195, label %.preheader, !llvm.loop !19

225:                                              ; preds = %195, %192
  %226 = add nuw nsw i32 %150, 1
  %227 = icmp eq i32 %226, 256
  br i1 %227, label %152, label %._crit_edge, !llvm.loop !20

._crit_edge:                                      ; preds = %225
  %.pre = load i8, i8* %145, align 16, !tbaa !12
  br label %148

228:                                              ; preds = %152, %139, %1
  %229 = phi i32 [ 0, %152 ], [ -3, %1 ], [ -5, %139 ]
  ret i32 %229
}

; Function Attrs: argmemonly mustprogress nofree nounwind readonly willreturn
declare i32 @memcmp(i8* nocapture noundef, i8* nocapture noundef, i64 noundef) local_unnamed_addr #12

; Function Attrs: nounwind
define i32 @main() local_unnamed_addr #13 {
entry:
  %0 = tail call noalias dereferenceable_or_null(16) i8* @malloc(i64 noundef 16) #13
  %1 = bitcast i8* %0 to %struct.evm_stack*
  %2 = icmp eq i8* %0, null
  br i1 %2, label %common.ret, label %3

3:                                                ; preds = %entry
  %4 = tail call noalias dereferenceable_or_null(8192) i8* @malloc(i64 noundef 8192) #13
  %5 = getelementptr %struct.evm_stack, %struct.evm_stack* %1, i64 0, i32 0
  store i8* %4, i8** %5, align 8, !tbaa !5
  %6 = icmp eq i8* %4, null
  br i1 %6, label %7, label %stack_ready

7:                                                ; preds = %3
  tail call void @free(i8* noundef nonnull %0) #13
  br label %common.ret

common.ret:                                       ; preds = %entry, %7, %stack_ready, %op6_ok
  %common.ret.op = phi i32 [ 0, %op6_ok ], [ %op6_errcode, %stack_ready ], [ -1, %7 ], [ -1, %entry ]
  ret i32 %common.ret.op

stack_ready:                                      ; preds = %3
  %8 = getelementptr %struct.evm_stack, %struct.evm_stack* %1, i64 0, i32 1
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %4, i8* noundef nonnull align 16 dereferenceable(32) getelementptr inbounds ([32 x i8], [32 x i8]* @const_push32_1, i64 0, i64 0), i64 32, i1 false) #13
  %9 = getelementptr inbounds i8, i8* %4, i64 32
  %10 = getelementptr inbounds i8, i8* %4, i64 64
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %10, i8 -54, i64 32, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %9, i8* noundef nonnull align 16 dereferenceable(32) getelementptr inbounds ([32 x i8], [32 x i8]* @const_push32_1, i64 0, i64 0), i64 32, i1 false)
  store i64 64, i64* %8, align 8, !tbaa !11
  %op6_errcode = tail call i32 @math_div(%struct.evm_stack* nonnull %1)
  %op6_is_error = icmp slt i32 %op6_errcode, 0
  br i1 %op6_is_error, label %common.ret, label %op6_ok

op6_ok:                                           ; preds = %stack_ready
  %t6 = load i64, i64* %8, align 8
  %t8 = getelementptr inbounds i8, i8* %4, i64 %t6
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %t8, i8 0, i64 32, i1 false)
  %t10 = add i64 %t6, 32
  %l1_3 = getelementptr inbounds i8, i8* %4, i64 %t10
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(26) %l1_3, i8 0, i64 26, i1 false)
  %l1_5 = getelementptr i8, i8* %l1_3, i64 26
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(6) %l1_5, i8 51, i64 6, i1 false)
  %l1_6 = add i64 %t6, 64
  %l2_3 = getelementptr inbounds i8, i8* %4, i64 %l1_6
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(24) %l2_3, i8 0, i64 24, i1 false)
  %l2_5 = getelementptr i8, i8* %l2_3, i64 24
  %11 = bitcast i8* %l2_5 to i64*
  store i64 1229782938247303441, i64* %11, align 1
  %l2_6 = add i64 %t6, 96
  %l3_2 = getelementptr inbounds i8, i8* %4, i64 %l2_6
  %l3_6 = getelementptr inbounds i8, i8* %l3_2, i64 -32
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 1 dereferenceable(32) %l3_2, i8* noundef nonnull align 1 dereferenceable(32) %l3_6, i64 32, i1 false)
  %l3_7 = add i64 %t6, 128
  store i64 %l3_7, i64* %8, align 8
  %l4_2 = getelementptr inbounds i8, i8* %4, i64 %l3_7
  %l4_aptr = getelementptr inbounds i8, i8* %l4_2, i64 -32
  %l4_bptr = getelementptr inbounds i8, i8* %l4_aptr, i64 -32
  %l4_aptr2 = bitcast i8* %l4_aptr to i256*
  %l4_bptr2 = bitcast i8* %l4_bptr to i256*
  %l4_a = load i256, i256* %l4_aptr2, align 4
  %l4_b = load i256, i256* %l4_bptr2, align 4
  %l4_sum = add i256 %l4_b, %l4_a
  store i256 %l4_sum, i256* %l4_aptr2, align 4
  %12 = tail call i32 @stack_print_item(%struct.evm_stack* nonnull %1, i32 1)
  %13 = tail call i32 @stack_print_item(%struct.evm_stack* nonnull %1, i32 2)
  %14 = tail call i32 @stack_print_item(%struct.evm_stack* nonnull %1, i32 3)
  %15 = tail call i32 @stack_print_item(%struct.evm_stack* nonnull %1, i32 4)
  br label %common.ret
}

attributes #0 = { mustprogress nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { mustprogress nofree nosync nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #5 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #6 = { mustprogress nofree norecurse nosync nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { nofree nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { nofree nounwind }
attributes #10 = { nofree nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #11 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #12 = { argmemonly mustprogress nofree nounwind readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #13 = { nounwind }
attributes #14 = { nounwind readonly willreturn }

!llvm.ident = !{!0, !0}
!llvm.module.flags = !{!1, !2, !3, !4}

!0 = !{!"Debian clang version 14.0.6"}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{i32 7, !"PIE Level", i32 2}
!4 = !{i32 7, !"uwtable", i32 1}
!5 = !{!6, !7, i64 0}
!6 = !{!"evm_stack", !7, i64 0, !10, i64 8}
!7 = !{!"any pointer", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!"long", !8, i64 0}
!11 = !{!6, !10, i64 8}
!12 = !{!8, !8, i64 0}
!13 = !{!10, !10, i64 0}
!14 = !{!15, !15, i64 0}
!15 = !{!"short", !8, i64 0}
!16 = distinct !{!16, !17}
!17 = !{!"llvm.loop.mustprogress"}
!18 = distinct !{!18, !17}
!19 = distinct !{!19, !17}
!20 = distinct !{!20, !17}
