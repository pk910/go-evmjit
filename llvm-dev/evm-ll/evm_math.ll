; ModuleID = './evm-c/evm_math.c'
source_filename = "./evm-c/evm_math.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.evm_stack = type { i8*, i64 }

; Function Attrs: nofree norecurse nosync nounwind uwtable
define dso_local i32 @math_add(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #0 {
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
  %13 = load i64, i64* %12, align 8, !tbaa !12
  %14 = getelementptr inbounds i8, i8* %8, i64 24
  %15 = bitcast i8* %14 to i64*
  %16 = load i64, i64* %15, align 8, !tbaa !12
  %17 = add i64 %13, %16
  %18 = icmp ult i64 %17, %13
  %19 = icmp ult i64 %17, %16
  %20 = or i1 %18, %19
  %21 = zext i1 %20 to i64
  store i64 %17, i64* %12, align 8, !tbaa !12
  %22 = getelementptr inbounds i8, i8* %7, i64 16
  %23 = bitcast i8* %22 to i64*
  %24 = load i64, i64* %23, align 8, !tbaa !12
  %25 = getelementptr inbounds i8, i8* %8, i64 16
  %26 = bitcast i8* %25 to i64*
  %27 = load i64, i64* %26, align 8, !tbaa !12
  %28 = add i64 %24, %21
  %29 = add i64 %28, %27
  %30 = icmp ult i64 %29, %24
  %31 = icmp ult i64 %29, %27
  %32 = or i1 %30, %31
  %33 = icmp eq i64 %29, %24
  %34 = icmp ne i64 %27, 0
  %35 = and i1 %33, %34
  %36 = or i1 %32, %35
  %37 = zext i1 %36 to i64
  store i64 %29, i64* %23, align 8, !tbaa !12
  %38 = getelementptr inbounds i8, i8* %7, i64 8
  %39 = bitcast i8* %38 to i64*
  %40 = load i64, i64* %39, align 8, !tbaa !12
  %41 = getelementptr inbounds i8, i8* %8, i64 8
  %42 = bitcast i8* %41 to i64*
  %43 = load i64, i64* %42, align 8, !tbaa !12
  %44 = add i64 %40, %37
  %45 = add i64 %44, %43
  %46 = icmp ult i64 %45, %40
  %47 = icmp ult i64 %45, %43
  %48 = or i1 %46, %47
  %49 = icmp eq i64 %45, %40
  %50 = icmp ne i64 %43, 0
  %51 = and i1 %49, %50
  %52 = or i1 %48, %51
  %53 = zext i1 %52 to i64
  store i64 %45, i64* %39, align 8, !tbaa !12
  %54 = load i64, i64* %9, align 8, !tbaa !12
  %55 = load i64, i64* %10, align 8, !tbaa !12
  %56 = add i64 %54, %53
  %57 = add i64 %56, %55
  store i64 %57, i64* %9, align 8, !tbaa !12
  %58 = load i64, i64* %4, align 8, !tbaa !11
  %59 = add i64 %58, -1
  store i64 %59, i64* %4, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree norecurse nosync nounwind uwtable
define dso_local i32 @math_sub(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #0 {
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
  %12 = load i64, i64* %11, align 8, !tbaa !12
  %13 = getelementptr inbounds i8, i8* %8, i64 24
  %14 = bitcast i8* %13 to i64*
  %15 = load i64, i64* %14, align 8, !tbaa !12
  %16 = sub i64 %12, %15
  %17 = icmp ult i64 %12, %15
  store i64 %16, i64* %11, align 8, !tbaa !12
  %18 = getelementptr inbounds i8, i8* %7, i64 16
  %19 = bitcast i8* %18 to i64*
  %20 = load i64, i64* %19, align 8, !tbaa !12
  %21 = getelementptr inbounds i8, i8* %8, i64 16
  %22 = bitcast i8* %21 to i64*
  %23 = load i64, i64* %22, align 8, !tbaa !12
  %24 = icmp ult i64 %20, %23
  br i1 %24, label %28, label %25

25:                                               ; preds = %1
  %26 = icmp eq i64 %20, %23
  %27 = select i1 %26, i1 %17, i1 false
  br label %28

28:                                               ; preds = %25, %1
  %29 = phi i1 [ true, %1 ], [ %27, %25 ]
  %30 = zext i1 %17 to i64
  %31 = add i64 %23, %30
  %32 = sub i64 %20, %31
  %33 = bitcast i8* %8 to i64*
  %34 = zext i1 %29 to i64
  store i64 %32, i64* %19, align 8, !tbaa !12
  %35 = getelementptr inbounds i8, i8* %7, i64 8
  %36 = bitcast i8* %35 to i64*
  %37 = load i64, i64* %36, align 8, !tbaa !12
  %38 = getelementptr inbounds i8, i8* %8, i64 8
  %39 = bitcast i8* %38 to i64*
  %40 = load i64, i64* %39, align 8, !tbaa !12
  %41 = add i64 %40, %34
  %42 = sub i64 %37, %41
  %43 = icmp ult i64 %37, %40
  %44 = icmp eq i64 %37, %40
  %45 = select i1 %44, i1 %29, i1 false
  %46 = select i1 %43, i1 true, i1 %45
  %47 = zext i1 %46 to i64
  store i64 %42, i64* %36, align 8, !tbaa !12
  %48 = load i64, i64* %9, align 8, !tbaa !12
  %49 = load i64, i64* %33, align 8, !tbaa !12
  %50 = add i64 %49, %47
  %51 = sub i64 %48, %50
  store i64 %51, i64* %9, align 8, !tbaa !12
  %52 = load i64, i64* %4, align 8, !tbaa !11
  %53 = add i64 %52, -1
  store i64 %53, i64* %4, align 8, !tbaa !11
  ret i32 0
}

; Function Attrs: nofree nosync nounwind uwtable
define dso_local i32 @math_mul(%struct.evm_stack* nocapture noundef %0) local_unnamed_addr #2 {
  %2 = alloca [64 x i16], align 16
  %3 = bitcast [64 x i16]* %2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 128, i8* nonnull %3) #8
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(128) %3, i8 0, i64 128, i1 false)
  %4 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %5 = load i64, i64* %4, align 8, !tbaa !11
  %6 = icmp ult i64 %5, 2
  br i1 %6, label %135, label %7

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
  %19 = load <8 x i8>, <8 x i8>* %18, align 1, !tbaa !13
  %20 = shufflevector <8 x i8> %19, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %21 = zext <8 x i8> %20 to <8 x i16>
  %22 = getelementptr inbounds i8, i8* %12, i64 -7
  %23 = getelementptr inbounds i8, i8* %22, i64 23
  %24 = bitcast i8* %23 to <8 x i8>*
  %25 = load <8 x i8>, <8 x i8>* %24, align 1, !tbaa !13
  %26 = shufflevector <8 x i8> %25, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %27 = zext <8 x i8> %26 to <8 x i16>
  %28 = getelementptr inbounds i8, i8* %12, i64 -7
  %29 = getelementptr inbounds i8, i8* %28, i64 15
  %30 = bitcast i8* %29 to <8 x i8>*
  %31 = load <8 x i8>, <8 x i8>* %30, align 1, !tbaa !13
  %32 = shufflevector <8 x i8> %31, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %33 = zext <8 x i8> %32 to <8 x i16>
  %34 = getelementptr inbounds i8, i8* %12, i64 -7
  %35 = getelementptr inbounds i8, i8* %34, i64 7
  %36 = bitcast i8* %35 to <8 x i8>*
  %37 = load <8 x i8>, <8 x i8>* %36, align 1, !tbaa !13
  %38 = shufflevector <8 x i8> %37, <8 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %39 = zext <8 x i8> %38 to <8 x i16>
  br label %40

40:                                               ; preds = %40, %7
  %41 = phi i64 [ 31, %7 ], [ %87, %40 ]
  %42 = getelementptr inbounds i8, i8* %14, i64 %41
  %43 = load i8, i8* %42, align 1, !tbaa !13
  %44 = zext i8 %43 to i16
  %45 = insertelement <8 x i16> poison, i16 %44, i64 0
  %46 = shufflevector <8 x i16> %45, <8 x i16> poison, <8 x i32> zeroinitializer
  %47 = add i64 %41, 32
  %48 = mul nuw <8 x i16> %46, %21
  %49 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %47
  %50 = getelementptr inbounds i16, i16* %49, i64 -7
  %51 = bitcast i16* %50 to <8 x i16>*
  %52 = load <8 x i16>, <8 x i16>* %51, align 2, !tbaa !14
  %53 = shufflevector <8 x i16> %52, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %54 = add <8 x i16> %48, %53
  %55 = shufflevector <8 x i16> %54, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %56 = bitcast i16* %50 to <8 x i16>*
  store <8 x i16> %55, <8 x i16>* %56, align 2, !tbaa !14
  %57 = add i64 %41, 24
  %58 = mul nuw <8 x i16> %46, %27
  %59 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %57
  %60 = getelementptr inbounds i16, i16* %59, i64 -7
  %61 = bitcast i16* %60 to <8 x i16>*
  %62 = load <8 x i16>, <8 x i16>* %61, align 2, !tbaa !14
  %63 = shufflevector <8 x i16> %62, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %64 = add <8 x i16> %58, %63
  %65 = shufflevector <8 x i16> %64, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %66 = bitcast i16* %60 to <8 x i16>*
  store <8 x i16> %65, <8 x i16>* %66, align 2, !tbaa !14
  %67 = add i64 %41, 16
  %68 = mul nuw <8 x i16> %46, %33
  %69 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %67
  %70 = getelementptr inbounds i16, i16* %69, i64 -7
  %71 = bitcast i16* %70 to <8 x i16>*
  %72 = load <8 x i16>, <8 x i16>* %71, align 2, !tbaa !14
  %73 = shufflevector <8 x i16> %72, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %74 = add <8 x i16> %68, %73
  %75 = shufflevector <8 x i16> %74, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %76 = bitcast i16* %70 to <8 x i16>*
  store <8 x i16> %75, <8 x i16>* %76, align 2, !tbaa !14
  %77 = add i64 %41, 8
  %78 = mul nuw <8 x i16> %46, %39
  %79 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %77
  %80 = getelementptr inbounds i16, i16* %79, i64 -7
  %81 = bitcast i16* %80 to <8 x i16>*
  %82 = load <8 x i16>, <8 x i16>* %81, align 2, !tbaa !14
  %83 = shufflevector <8 x i16> %82, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %84 = add <8 x i16> %78, %83
  %85 = shufflevector <8 x i16> %84, <8 x i16> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %86 = bitcast i16* %80 to <8 x i16>*
  store <8 x i16> %85, <8 x i16>* %86, align 2, !tbaa !14
  %87 = add nsw i64 %41, -1
  %88 = icmp eq i64 %41, 0
  br i1 %88, label %89, label %40, !llvm.loop !16

89:                                               ; preds = %40
  %90 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 63
  %91 = load i16, i16* %90, align 2, !tbaa !14
  br label %92

92:                                               ; preds = %103, %89
  %93 = phi i16 [ %91, %89 ], [ %109, %103 ]
  %94 = phi i64 [ 63, %89 ], [ %106, %103 ]
  %95 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %94
  %96 = lshr i16 %93, 8
  %97 = add nsw i64 %94, -1
  %98 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %97
  %99 = load i16, i16* %98, align 2, !tbaa !14
  %100 = add i16 %99, %96
  store i16 %100, i16* %98, align 2, !tbaa !14
  %101 = and i16 %93, 255
  store i16 %101, i16* %95, align 2, !tbaa !14
  %102 = icmp ugt i64 %94, 1
  br i1 %102, label %103, label %111, !llvm.loop !18

103:                                              ; preds = %92
  %104 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %97
  %105 = lshr i16 %100, 8
  %106 = add nsw i64 %94, -2
  %107 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 %106
  %108 = load i16, i16* %107, align 2, !tbaa !14
  %109 = add i16 %108, %105
  store i16 %109, i16* %107, align 2, !tbaa !14
  %110 = and i16 %100, 255
  store i16 %110, i16* %104, align 2, !tbaa !14
  br label %92

111:                                              ; preds = %92
  %112 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 32
  %113 = bitcast i16* %112 to <8 x i16>*
  %114 = load <8 x i16>, <8 x i16>* %113, align 16, !tbaa !14
  %115 = trunc <8 x i16> %114 to <8 x i8>
  %116 = bitcast i8* %14 to <8 x i8>*
  store <8 x i8> %115, <8 x i8>* %116, align 1, !tbaa !13
  %117 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 40
  %118 = bitcast i16* %117 to <8 x i16>*
  %119 = load <8 x i16>, <8 x i16>* %118, align 16, !tbaa !14
  %120 = trunc <8 x i16> %119 to <8 x i8>
  %121 = getelementptr inbounds i8, i8* %14, i64 8
  %122 = bitcast i8* %121 to <8 x i8>*
  store <8 x i8> %120, <8 x i8>* %122, align 1, !tbaa !13
  %123 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 48
  %124 = bitcast i16* %123 to <8 x i16>*
  %125 = load <8 x i16>, <8 x i16>* %124, align 16, !tbaa !14
  %126 = trunc <8 x i16> %125 to <8 x i8>
  %127 = getelementptr inbounds i8, i8* %14, i64 16
  %128 = bitcast i8* %127 to <8 x i8>*
  store <8 x i8> %126, <8 x i8>* %128, align 1, !tbaa !13
  %129 = getelementptr inbounds [64 x i16], [64 x i16]* %2, i64 0, i64 56
  %130 = bitcast i16* %129 to <8 x i16>*
  %131 = load <8 x i16>, <8 x i16>* %130, align 16, !tbaa !14
  %132 = trunc <8 x i16> %131 to <8 x i8>
  %133 = getelementptr inbounds i8, i8* %14, i64 24
  %134 = bitcast i8* %133 to <8 x i8>*
  store <8 x i8> %132, <8 x i8>* %134, align 1, !tbaa !13
  br label %135

135:                                              ; preds = %111, %1
  %136 = phi i32 [ -3, %1 ], [ 0, %111 ]
  call void @llvm.lifetime.end.p0i8(i64 128, i8* nonnull %3) #8
  ret i32 %136
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nounwind uwtable
define dso_local i32 @math_div(%struct.evm_stack* noundef %0) local_unnamed_addr #4 {
  %2 = alloca [32 x i8], align 16
  %3 = alloca [32 x i8], align 16
  %4 = alloca [32 x i8], align 16
  %5 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %0, i64 0, i32 1
  %6 = load i64, i64* %5, align 8, !tbaa !11
  %7 = icmp ult i64 %6, 2
  br i1 %7, label %231, label %8

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
  %17 = load i8, i8* %13, align 1, !tbaa !13
  %18 = icmp eq i8 %17, 0
  br i1 %18, label %19, label %143

19:                                               ; preds = %8
  %20 = getelementptr inbounds i8, i8* %13, i64 1
  %21 = load i8, i8* %20, align 1, !tbaa !13
  %22 = icmp eq i8 %21, 0
  br i1 %22, label %23, label %143

23:                                               ; preds = %19
  %24 = getelementptr inbounds i8, i8* %13, i64 2
  %25 = load i8, i8* %24, align 1, !tbaa !13
  %26 = icmp eq i8 %25, 0
  br i1 %26, label %27, label %143

27:                                               ; preds = %23
  %28 = getelementptr inbounds i8, i8* %13, i64 3
  %29 = load i8, i8* %28, align 1, !tbaa !13
  %30 = icmp eq i8 %29, 0
  br i1 %30, label %31, label %143

31:                                               ; preds = %27
  %32 = getelementptr inbounds i8, i8* %13, i64 4
  %33 = load i8, i8* %32, align 1, !tbaa !13
  %34 = icmp eq i8 %33, 0
  br i1 %34, label %35, label %143

35:                                               ; preds = %31
  %36 = getelementptr inbounds i8, i8* %13, i64 5
  %37 = load i8, i8* %36, align 1, !tbaa !13
  %38 = icmp eq i8 %37, 0
  br i1 %38, label %39, label %143

39:                                               ; preds = %35
  %40 = getelementptr inbounds i8, i8* %13, i64 6
  %41 = load i8, i8* %40, align 1, !tbaa !13
  %42 = icmp eq i8 %41, 0
  br i1 %42, label %43, label %143

43:                                               ; preds = %39
  %44 = getelementptr inbounds i8, i8* %13, i64 7
  %45 = load i8, i8* %44, align 1, !tbaa !13
  %46 = icmp eq i8 %45, 0
  br i1 %46, label %47, label %143

47:                                               ; preds = %43
  %48 = getelementptr inbounds i8, i8* %13, i64 8
  %49 = load i8, i8* %48, align 1, !tbaa !13
  %50 = icmp eq i8 %49, 0
  br i1 %50, label %51, label %143

51:                                               ; preds = %47
  %52 = getelementptr inbounds i8, i8* %13, i64 9
  %53 = load i8, i8* %52, align 1, !tbaa !13
  %54 = icmp eq i8 %53, 0
  br i1 %54, label %55, label %143

55:                                               ; preds = %51
  %56 = getelementptr inbounds i8, i8* %13, i64 10
  %57 = load i8, i8* %56, align 1, !tbaa !13
  %58 = icmp eq i8 %57, 0
  br i1 %58, label %59, label %143

59:                                               ; preds = %55
  %60 = getelementptr inbounds i8, i8* %13, i64 11
  %61 = load i8, i8* %60, align 1, !tbaa !13
  %62 = icmp eq i8 %61, 0
  br i1 %62, label %63, label %143

63:                                               ; preds = %59
  %64 = getelementptr inbounds i8, i8* %13, i64 12
  %65 = load i8, i8* %64, align 1, !tbaa !13
  %66 = icmp eq i8 %65, 0
  br i1 %66, label %67, label %143

67:                                               ; preds = %63
  %68 = getelementptr inbounds i8, i8* %13, i64 13
  %69 = load i8, i8* %68, align 1, !tbaa !13
  %70 = icmp eq i8 %69, 0
  br i1 %70, label %71, label %143

71:                                               ; preds = %67
  %72 = getelementptr inbounds i8, i8* %13, i64 14
  %73 = load i8, i8* %72, align 1, !tbaa !13
  %74 = icmp eq i8 %73, 0
  br i1 %74, label %75, label %143

75:                                               ; preds = %71
  %76 = getelementptr inbounds i8, i8* %13, i64 15
  %77 = load i8, i8* %76, align 1, !tbaa !13
  %78 = icmp eq i8 %77, 0
  br i1 %78, label %79, label %143

79:                                               ; preds = %75
  %80 = getelementptr inbounds i8, i8* %13, i64 16
  %81 = load i8, i8* %80, align 1, !tbaa !13
  %82 = icmp eq i8 %81, 0
  br i1 %82, label %83, label %143

83:                                               ; preds = %79
  %84 = getelementptr inbounds i8, i8* %13, i64 17
  %85 = load i8, i8* %84, align 1, !tbaa !13
  %86 = icmp eq i8 %85, 0
  br i1 %86, label %87, label %143

87:                                               ; preds = %83
  %88 = getelementptr inbounds i8, i8* %13, i64 18
  %89 = load i8, i8* %88, align 1, !tbaa !13
  %90 = icmp eq i8 %89, 0
  br i1 %90, label %91, label %143

91:                                               ; preds = %87
  %92 = getelementptr inbounds i8, i8* %13, i64 19
  %93 = load i8, i8* %92, align 1, !tbaa !13
  %94 = icmp eq i8 %93, 0
  br i1 %94, label %95, label %143

95:                                               ; preds = %91
  %96 = getelementptr inbounds i8, i8* %13, i64 20
  %97 = load i8, i8* %96, align 1, !tbaa !13
  %98 = icmp eq i8 %97, 0
  br i1 %98, label %99, label %143

99:                                               ; preds = %95
  %100 = getelementptr inbounds i8, i8* %13, i64 21
  %101 = load i8, i8* %100, align 1, !tbaa !13
  %102 = icmp eq i8 %101, 0
  br i1 %102, label %103, label %143

103:                                              ; preds = %99
  %104 = getelementptr inbounds i8, i8* %13, i64 22
  %105 = load i8, i8* %104, align 1, !tbaa !13
  %106 = icmp eq i8 %105, 0
  br i1 %106, label %107, label %143

107:                                              ; preds = %103
  %108 = getelementptr inbounds i8, i8* %13, i64 23
  %109 = load i8, i8* %108, align 1, !tbaa !13
  %110 = icmp eq i8 %109, 0
  br i1 %110, label %111, label %143

111:                                              ; preds = %107
  %112 = getelementptr inbounds i8, i8* %13, i64 24
  %113 = load i8, i8* %112, align 1, !tbaa !13
  %114 = icmp eq i8 %113, 0
  br i1 %114, label %115, label %143

115:                                              ; preds = %111
  %116 = getelementptr inbounds i8, i8* %13, i64 25
  %117 = load i8, i8* %116, align 1, !tbaa !13
  %118 = icmp eq i8 %117, 0
  br i1 %118, label %119, label %143

119:                                              ; preds = %115
  %120 = getelementptr inbounds i8, i8* %13, i64 26
  %121 = load i8, i8* %120, align 1, !tbaa !13
  %122 = icmp eq i8 %121, 0
  br i1 %122, label %123, label %143

123:                                              ; preds = %119
  %124 = getelementptr inbounds i8, i8* %13, i64 27
  %125 = load i8, i8* %124, align 1, !tbaa !13
  %126 = icmp eq i8 %125, 0
  br i1 %126, label %127, label %143

127:                                              ; preds = %123
  %128 = getelementptr inbounds i8, i8* %13, i64 28
  %129 = load i8, i8* %128, align 1, !tbaa !13
  %130 = icmp eq i8 %129, 0
  br i1 %130, label %131, label %143

131:                                              ; preds = %127
  %132 = getelementptr inbounds i8, i8* %13, i64 29
  %133 = load i8, i8* %132, align 1, !tbaa !13
  %134 = icmp eq i8 %133, 0
  br i1 %134, label %135, label %143

135:                                              ; preds = %131
  %136 = getelementptr inbounds i8, i8* %13, i64 30
  %137 = load i8, i8* %136, align 1, !tbaa !13
  %138 = icmp eq i8 %137, 0
  br i1 %138, label %139, label %143

139:                                              ; preds = %135
  %140 = getelementptr inbounds i8, i8* %13, i64 31
  %141 = load i8, i8* %140, align 1, !tbaa !13
  %142 = icmp eq i8 %141, 0
  br i1 %142, label %231, label %143

143:                                              ; preds = %139, %135, %131, %127, %123, %119, %115, %111, %107, %103, %99, %95, %91, %87, %83, %79, %75, %71, %67, %63, %59, %55, %51, %47, %43, %39, %35, %31, %27, %23, %19, %8
  %144 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %144) #8
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %144, i8 0, i64 32, i1 false)
  %145 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %145) #8
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %145, i8 0, i64 32, i1 false)
  %146 = getelementptr inbounds [32 x i8], [32 x i8]* %4, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %146) #8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %146, i8* noundef nonnull align 1 dereferenceable(32) %15, i64 32, i1 false)
  %147 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 31
  %148 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 0
  br label %149

149:                                              ; preds = %143, %228
  %150 = phi i32 [ 0, %143 ], [ %229, %228 ]
  %151 = load i8, i8* %148, align 16, !tbaa !13
  %152 = shl i8 %151, 1
  store i8 %152, i8* %148, align 16, !tbaa !13
  br label %165

153:                                              ; preds = %228
  %154 = call i32 @stack_push(%struct.evm_stack* noundef %0, i8* noundef nonnull %144) #8
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %146) #8
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %145) #8
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %144) #8
  br label %231

155:                                              ; preds = %175
  %156 = lshr i32 %150, 3
  %157 = zext i32 %156 to i64
  %158 = getelementptr inbounds [32 x i8], [32 x i8]* %4, i64 0, i64 %157
  %159 = load i8, i8* %158, align 1, !tbaa !13
  %160 = zext i8 %159 to i32
  %161 = and i32 %150, 7
  %162 = lshr i32 128, %161
  %163 = and i32 %162, %160
  %164 = icmp eq i32 %163, 0
  br i1 %164, label %194, label %191

165:                                              ; preds = %187, %149
  %166 = phi i8 [ %152, %149 ], [ %190, %187 ]
  %167 = phi i8* [ %148, %149 ], [ %188, %187 ]
  %168 = phi i64 [ 0, %149 ], [ %181, %187 ]
  %169 = or i64 %168, 1
  %170 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %169
  %171 = load i8, i8* %170, align 1, !tbaa !13
  %172 = icmp sgt i8 %171, -1
  br i1 %172, label %175, label %173

173:                                              ; preds = %165
  %174 = or i8 %166, 1
  store i8 %174, i8* %167, align 1, !tbaa !13
  br label %175

175:                                              ; preds = %165, %173
  %176 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %169
  %177 = load i8, i8* %176, align 1, !tbaa !13
  %178 = shl i8 %177, 1
  store i8 %178, i8* %176, align 1, !tbaa !13
  %179 = icmp eq i64 %169, 31
  br i1 %179, label %155, label %180

180:                                              ; preds = %175
  %181 = add nuw nsw i64 %168, 2
  %182 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %181
  %183 = load i8, i8* %182, align 2, !tbaa !13
  %184 = icmp sgt i8 %183, -1
  br i1 %184, label %187, label %185

185:                                              ; preds = %180
  %186 = or i8 %178, 1
  store i8 %186, i8* %176, align 1, !tbaa !13
  br label %187

187:                                              ; preds = %185, %180
  %188 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %181
  %189 = load i8, i8* %188, align 2, !tbaa !13
  %190 = shl i8 %189, 1
  store i8 %190, i8* %188, align 2, !tbaa !13
  br label %165

191:                                              ; preds = %155
  %192 = load i8, i8* %147, align 1, !tbaa !13
  %193 = or i8 %192, 1
  store i8 %193, i8* %147, align 1, !tbaa !13
  br label %194

194:                                              ; preds = %191, %155
  %195 = call i32 @memcmp(i8* noundef nonnull dereferenceable(32) %145, i8* noundef nonnull dereferenceable(32) %13, i64 noundef 32) #9
  %196 = icmp sgt i32 %195, -1
  br i1 %196, label %202, label %228

197:                                              ; preds = %202
  %198 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i64 0, i64 %157
  %199 = load i8, i8* %198, align 1, !tbaa !13
  %200 = trunc i32 %162 to i8
  %201 = or i8 %199, %200
  store i8 %201, i8* %198, align 1, !tbaa !13
  br label %228

202:                                              ; preds = %194, %202
  %203 = phi i64 [ %226, %202 ], [ 31, %194 ]
  %204 = phi i32 [ %224, %202 ], [ 0, %194 ]
  %205 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %203
  %206 = load i8, i8* %205, align 1, !tbaa !13
  %207 = zext i8 %206 to i32
  %208 = getelementptr inbounds i8, i8* %13, i64 %203
  %209 = load i8, i8* %208, align 1, !tbaa !13
  %210 = zext i8 %209 to i32
  %211 = sub nsw i32 %207, %210
  %212 = add nsw i32 %211, %204
  %213 = ashr i32 %212, 31
  %214 = trunc i32 %212 to i8
  store i8 %214, i8* %205, align 1, !tbaa !13
  %215 = add nsw i64 %203, -1
  %216 = getelementptr inbounds [32 x i8], [32 x i8]* %3, i64 0, i64 %215
  %217 = load i8, i8* %216, align 1, !tbaa !13
  %218 = zext i8 %217 to i32
  %219 = getelementptr inbounds i8, i8* %13, i64 %215
  %220 = load i8, i8* %219, align 1, !tbaa !13
  %221 = zext i8 %220 to i32
  %222 = sub nsw i32 %218, %221
  %223 = add nsw i32 %222, %213
  %224 = ashr i32 %223, 31
  %225 = trunc i32 %223 to i8
  store i8 %225, i8* %216, align 1, !tbaa !13
  %226 = add nsw i64 %203, -2
  %227 = icmp eq i64 %215, 0
  br i1 %227, label %197, label %202, !llvm.loop !19

228:                                              ; preds = %197, %194
  %229 = add nuw nsw i32 %150, 1
  %230 = icmp eq i32 %229, 256
  br i1 %230, label %153, label %149, !llvm.loop !20

231:                                              ; preds = %139, %1, %153
  %232 = phi i32 [ %154, %153 ], [ -3, %1 ], [ -5, %139 ]
  ret i32 %232
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #5

; Function Attrs: argmemonly mustprogress nofree nounwind readonly willreturn
declare i32 @memcmp(i8* nocapture noundef, i8* nocapture noundef, i64 noundef) local_unnamed_addr #6

declare i32 @stack_push(%struct.evm_stack* noundef, i8* noundef) local_unnamed_addr #7

attributes #0 = { nofree norecurse nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #4 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { argmemonly mustprogress nofree nounwind willreturn }
attributes #6 = { argmemonly mustprogress nofree nounwind readonly willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #8 = { nounwind }
attributes #9 = { nounwind readonly willreturn }

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
!12 = !{!10, !10, i64 0}
!13 = !{!8, !8, i64 0}
!14 = !{!15, !15, i64 0}
!15 = !{!"short", !8, i64 0}
!16 = distinct !{!16, !17}
!17 = !{!"llvm.loop.mustprogress"}
!18 = distinct !{!18, !17}
!19 = distinct !{!19, !17}
!20 = distinct !{!20, !17}
