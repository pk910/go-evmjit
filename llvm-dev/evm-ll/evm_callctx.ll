; ModuleID = './evm-c/evm_callctx.c'
source_filename = "./evm-c/evm_callctx.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.evm_callctx = type { %struct.evm_stack*, i64, i64, i32 (i8*, i8, i8*, i8, i8*, i8)*, i8* }
%struct.evm_stack = type { i8*, i64 }

@.str = private unnamed_addr constant [16 x i8] c"callctx != NULL\00", align 1
@.str.1 = private unnamed_addr constant [22 x i8] c"./evm-c/evm_callctx.c\00", align 1
@__PRETTY_FUNCTION__.callctx_free = private unnamed_addr constant [33 x i8] c"void callctx_free(evm_callctx *)\00", align 1
@__PRETTY_FUNCTION__.callctx_get_pc = private unnamed_addr constant [39 x i8] c"uint64_t callctx_get_pc(evm_callctx *)\00", align 1
@__PRETTY_FUNCTION__.callctx_get_gas = private unnamed_addr constant [40 x i8] c"uint64_t callctx_get_gas(evm_callctx *)\00", align 1
@__PRETTY_FUNCTION__.callctx_opcode_callback = private unnamed_addr constant [78 x i8] c"int32_t callctx_opcode_callback(evm_callctx *, uint8_t, uint8_t *, uint8_t *)\00", align 1
@.str.2 = private unnamed_addr constant [12 x i8] c"Opcode: %d\0A\00", align 1

; Function Attrs: mustprogress nofree nounwind uwtable willreturn
define dso_local noalias %struct.evm_callctx* @callctx_init(%struct.evm_stack* noundef %0) local_unnamed_addr #0 {
  %2 = tail call noalias dereferenceable_or_null(40) i8* @malloc(i64 noundef 40) #10
  %3 = bitcast i8* %2 to %struct.evm_callctx*
  %4 = icmp eq i8* %2, null
  br i1 %4, label %11, label %5

5:                                                ; preds = %1
  %6 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %3, i64 0, i32 0
  store %struct.evm_stack* %0, %struct.evm_stack** %6, align 8, !tbaa !5
  %7 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %3, i64 0, i32 1
  %8 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %3, i64 0, i32 3
  %9 = bitcast i64* %7 to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 8 dereferenceable(16) %9, i8 0, i64 16, i1 false)
  store i32 (i8*, i8, i8*, i8, i8*, i8)* bitcast (i32 (%struct.evm_callctx*, i8, i8*, i8*)* @callctx_opcode_callback to i32 (i8*, i8, i8*, i8, i8*, i8)*), i32 (i8*, i8, i8*, i8, i8*, i8)** %8, align 8, !tbaa !11
  %10 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %3, i64 0, i32 4
  store i8* null, i8** %10, align 8, !tbaa !12
  br label %11

11:                                               ; preds = %1, %5
  %12 = phi %struct.evm_callctx* [ %3, %5 ], [ null, %1 ]
  ret %struct.evm_callctx* %12
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: inaccessiblememonly mustprogress nofree nounwind willreturn
declare noalias noundef i8* @malloc(i64 noundef) local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define dso_local i32 @callctx_opcode_callback(%struct.evm_callctx* noundef readnone %0, i8 noundef zeroext %1, i8* nocapture readnone %2, i8* nocapture readnone %3) #3 {
  %5 = icmp eq %struct.evm_callctx* %0, null
  br i1 %5, label %6, label %7

6:                                                ; preds = %4
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 40, i8* noundef getelementptr inbounds ([78 x i8], [78 x i8]* @__PRETTY_FUNCTION__.callctx_opcode_callback, i64 0, i64 0)) #11
  unreachable

7:                                                ; preds = %4
  %8 = zext i8 %1 to i32
  %9 = tail call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([12 x i8], [12 x i8]* @.str.2, i64 0, i64 0), i32 noundef %8)
  ret i32 0
}

; Function Attrs: argmemonly mustprogress nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind uwtable
define dso_local void @callctx_free(%struct.evm_callctx* noundef %0) local_unnamed_addr #3 {
  %2 = icmp eq %struct.evm_callctx* %0, null
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 25, i8* noundef getelementptr inbounds ([33 x i8], [33 x i8]* @__PRETTY_FUNCTION__.callctx_free, i64 0, i64 0)) #11
  unreachable

4:                                                ; preds = %1
  %5 = bitcast %struct.evm_callctx* %0 to i8*
  tail call void @free(i8* noundef %5) #10
  ret void
}

; Function Attrs: noreturn nounwind
declare void @__assert_fail(i8* noundef, i8* noundef, i32 noundef, i8* noundef) local_unnamed_addr #4

; Function Attrs: inaccessiblemem_or_argmemonly mustprogress nounwind willreturn
declare void @free(i8* nocapture noundef) local_unnamed_addr #5

; Function Attrs: nounwind uwtable
define dso_local i64 @callctx_get_pc(%struct.evm_callctx* noundef readonly %0) local_unnamed_addr #3 {
  %2 = icmp eq %struct.evm_callctx* %0, null
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 30, i8* noundef getelementptr inbounds ([39 x i8], [39 x i8]* @__PRETTY_FUNCTION__.callctx_get_pc, i64 0, i64 0)) #11
  unreachable

4:                                                ; preds = %1
  %5 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %0, i64 0, i32 1
  %6 = load i64, i64* %5, align 8, !tbaa !13
  ret i64 %6
}

; Function Attrs: nounwind uwtable
define dso_local i64 @callctx_get_gas(%struct.evm_callctx* noundef readonly %0) local_unnamed_addr #3 {
  %2 = icmp eq %struct.evm_callctx* %0, null
  br i1 %2, label %3, label %4

3:                                                ; preds = %1
  tail call void @__assert_fail(i8* noundef getelementptr inbounds ([16 x i8], [16 x i8]* @.str, i64 0, i64 0), i8* noundef getelementptr inbounds ([22 x i8], [22 x i8]* @.str.1, i64 0, i64 0), i32 noundef 35, i8* noundef getelementptr inbounds ([40 x i8], [40 x i8]* @__PRETTY_FUNCTION__.callctx_get_gas, i64 0, i64 0)) #11
  unreachable

4:                                                ; preds = %1
  %5 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %0, i64 0, i32 2
  %6 = load i64, i64* %5, align 8, !tbaa !14
  ret i64 %6
}

; Function Attrs: nofree nounwind
declare noundef i32 @printf(i8* nocapture noundef readonly, ...) local_unnamed_addr #6

; Function Attrs: nounwind uwtable
define dso_local i32 @callctx_call(%struct.evm_callctx* noundef %0) local_unnamed_addr #3 {
  %2 = alloca [32 x i8], align 16
  %3 = getelementptr inbounds [32 x i8], [32 x i8]* %2, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 32, i8* nonnull %3) #10
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(32) %3, i8 0, i64 32, i1 false)
  %4 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %0, i64 0, i32 3
  %5 = load i32 (i8*, i8, i8*, i8, i8*, i8)*, i32 (i8*, i8, i8*, i8, i8*, i8)** %4, align 8, !tbaa !11
  %6 = bitcast %struct.evm_callctx* %0 to i8*
  %7 = call i32 %5(i8* noundef %6, i8 noundef zeroext 8, i8* noundef nonnull %3, i8 noundef zeroext 32, i8* noundef null, i8 noundef zeroext 0) #10
  call void @llvm.lifetime.end.p0i8(i64 32, i8* nonnull %3) #10
  ret i32 %7
}

; Function Attrs: argmemonly mustprogress nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #7

; Function Attrs: mustprogress nofree norecurse nosync nounwind uwtable willreturn
define dso_local i32 @callctx_stack_inc(%struct.evm_callctx* nocapture noundef readonly %0) local_unnamed_addr #8 {
  %2 = getelementptr inbounds %struct.evm_callctx, %struct.evm_callctx* %0, i64 0, i32 0
  %3 = load %struct.evm_stack*, %struct.evm_stack** %2, align 8, !tbaa !5
  %4 = getelementptr inbounds %struct.evm_stack, %struct.evm_stack* %3, i64 0, i32 1
  %5 = load i64, i64* %4, align 8, !tbaa !15
  %6 = add i64 %5, 32
  store i64 %6, i64* %4, align 8, !tbaa !15
  ret i32 0
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind readnone uwtable willreturn
define dso_local i32 @callctx_switch_branch(%struct.evm_callctx* nocapture noundef readnone %0, i64 noundef %1) local_unnamed_addr #9 {
  switch i64 %1, label %6 [
    i64 42, label %7
    i64 48, label %3
    i64 4, label %4
    i64 77, label %5
  ]

3:                                                ; preds = %2
  br label %7

4:                                                ; preds = %2
  br label %7

5:                                                ; preds = %2
  br label %7

6:                                                ; preds = %2
  br label %7

7:                                                ; preds = %2, %6, %5, %4, %3
  %8 = phi i32 [ 0, %6 ], [ 88, %5 ], [ 3, %4 ], [ 2, %3 ], [ 1, %2 ]
  ret i32 %8
}

attributes #0 = { mustprogress nofree nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly mustprogress nofree nosync nounwind willreturn }
attributes #2 = { inaccessiblememonly mustprogress nofree nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind uwtable "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { noreturn nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { inaccessiblemem_or_argmemonly mustprogress nounwind willreturn "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nofree nounwind "frame-pointer"="none" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #7 = { argmemonly mustprogress nofree nounwind willreturn writeonly }
attributes #8 = { mustprogress nofree norecurse nosync nounwind uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #9 = { mustprogress nofree norecurse nosync nounwind readnone uwtable willreturn "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #10 = { nounwind }
attributes #11 = { noreturn nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{!"Debian clang version 14.0.6"}
!5 = !{!6, !7, i64 0}
!6 = !{!"evm_callctx", !7, i64 0, !10, i64 8, !10, i64 16, !7, i64 24, !7, i64 32}
!7 = !{!"any pointer", !8, i64 0}
!8 = !{!"omnipotent char", !9, i64 0}
!9 = !{!"Simple C/C++ TBAA"}
!10 = !{!"long", !8, i64 0}
!11 = !{!6, !7, i64 24}
!12 = !{!6, !7, i64 32}
!13 = !{!6, !10, i64 8}
!14 = !{!6, !10, i64 16}
!15 = !{!16, !10, i64 8}
!16 = !{!"evm_stack", !7, i64 0, !10, i64 8}
