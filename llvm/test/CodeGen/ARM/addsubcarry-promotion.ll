; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O2 -mtriple armv7a < %s | FileCheck --check-prefixes=ARM,ARMV7A %s

; RUN: llc -O2 -mtriple thumbv6m < %s | FileCheck --check-prefixes=THUMB1,THUMBV6M %s
; RUN: llc -O2 -mtriple thumbv8m.base < %s | FileCheck --check-prefixes=THUMB1,THUMBV8M-BASE %s

; RUN: llc -O2 -mtriple thumbv7a < %s | FileCheck --check-prefixes=THUMB,THUMBV7A %s
; RUN: llc -O2 -mtriple thumbv8m.main < %s | FileCheck --check-prefixes=THUMB,THUMBV8M-MAIN %s

define void @fn1(i32 %a, i32 %b, i32 %c) local_unnamed_addr #0 {
; ARM-LABEL: fn1:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    rsb r2, r2, #0
; ARM-NEXT:    adds r0, r1, r0
; ARM-NEXT:    movw r1, #65535
; ARM-NEXT:    sxth r2, r2
; ARM-NEXT:    adc r0, r2, #1
; ARM-NEXT:    tst r0, r1
; ARM-NEXT:    bxeq lr
; ARM-NEXT:  .LBB0_1: @ %for.cond
; ARM-NEXT:    @ =>This Inner Loop Header: Depth=1
; ARM-NEXT:    b .LBB0_1
;
; THUMB1-LABEL: fn1:
; THUMB1:       @ %bb.0: @ %entry
; THUMB1-NEXT:    rsbs r2, r2, #0
; THUMB1-NEXT:    sxth r2, r2
; THUMB1-NEXT:    movs r3, #1
; THUMB1-NEXT:    adds r0, r1, r0
; THUMB1-NEXT:    adcs r3, r2
; THUMB1-NEXT:    lsls r0, r3, #16
; THUMB1-NEXT:    beq .LBB0_2
; THUMB1-NEXT:  .LBB0_1: @ %for.cond
; THUMB1-NEXT:    @ =>This Inner Loop Header: Depth=1
; THUMB1-NEXT:    b .LBB0_1
; THUMB1-NEXT:  .LBB0_2: @ %if.end
; THUMB1-NEXT:    bx lr
;
; THUMB-LABEL: fn1:
; THUMB:       @ %bb.0: @ %entry
; THUMB-NEXT:    rsbs r2, r2, #0
; THUMB-NEXT:    adds r0, r0, r1
; THUMB-NEXT:    sxth r2, r2
; THUMB-NEXT:    adc r0, r2, #1
; THUMB-NEXT:    lsls r0, r0, #16
; THUMB-NEXT:    it eq
; THUMB-NEXT:    bxeq lr
; THUMB-NEXT:  .LBB0_1: @ %for.cond
; THUMB-NEXT:    @ =>This Inner Loop Header: Depth=1
; THUMB-NEXT:    b .LBB0_1
entry:
  %add = add i32 %b, %a
  %cmp = icmp ult i32 %add, %b
  %conv = zext i1 %cmp to i32
  %sub = sub i32 1, %c
  %add1 = add i32 %sub, %conv
  %conv2 = trunc i32 %add1 to i16
  %tobool = icmp eq i16 %conv2, 0
  br i1 %tobool, label %if.end, label %for.cond.preheader

for.cond.preheader:                               ; preds = %entry
  br label %for.cond

for.cond:                                         ; preds = %for.cond.preheader, %for.cond
  br label %for.cond

if.end:                                           ; preds = %entry
  ret void
}
