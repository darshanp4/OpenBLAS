#define ASSEMBLER
#include "common.h"
#define N      $r4
#define X      $r5
#define INCX   $r6
#define I      $r17
#define TEMP   $r18
#define t1     $r15
#define t2     $r12
#define t3     $r13
#define t4     $r14
#define VX0    $xr12
#define VX1    $xr13
#define VX2    $xr14
#define VX3    $xr15
#define VT0    $xr23
#define VT1    $xr22
#define res1   $xr16
#define res2   $xr17
#define res0   $xr18
#define neg1   $xr19

    PROLOGUE
    xvxor.v res1, res1, res1
    xvxor.v res2, res2, res2
    xvxor.v res0, res0, res0
    bge $r0, N, .L999
    bge $r0, INCX, .L999
    li.w t1, -1
    xvreplgr2vr.w neg1, t1
    xvffint.s.w neg1, neg1
    li.d  TEMP, SIZE
    slli.d  INCX, INCX, BASE_SHIFT
    srai.d I, N, 3
    bne INCX, TEMP, .L20
    bge $r0, I, .L13
    .align 3

.L11:
    xvld VX0, X, 0 * SIZE
    xvfmul.s VX2, neg1, VX0
    xvfcmp.clt.s VT0, VX0, res0
    xvbitsel.v VX0, VX0, VX2, VT0
    xvfadd.s res1, VX0, res1
    addi.d X, X, 8 * SIZE
    addi.d  I, I, -1
    blt $r0, I, .L11
    .align 3

.L12:
    xvfadd.s res2, res1, res2
    xvpickve.w VX1, res1, 1
    xvpickve.w VX2, res1, 2
    xvpickve.w VX3, res1, 3
    xvfadd.s res1, VX1, res1
    xvfadd.s res1, VX2, res1
    xvfadd.s res1, VX3, res1
    xvpickve.w VX0, res2, 4
    xvpickve.w VX1, res2, 5
    xvpickve.w VX2, res2, 6
    xvpickve.w VX3, res2, 7
    xvfadd.s res1, VX0, res1
    xvfadd.s res1, VX1, res1
    xvfadd.s res1, VX2, res1
    xvfadd.s res1, VX2, res1
    .align 3

.L13:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L14:
    fld.s $f12, X, 0 * SIZE
    fabs.s $f12, $f12
    fadd.s $f16, $f12, $f16
    addi.d I, I, -1
    addi.d  X, X, SIZE
    blt $r0, I, .L14
    b .L999
    .align 3

.L20:
    bge $r0, I, .L23
    .align 3

.L21:
    ld.w t1, X, 0 * SIZE
    add.d X, X, INCX
    ld.w t2, X, 0 * SIZE
    add.d X, X, INCX
    ld.w t3, X, 0 * SIZE
    add.d X, X, INCX
    ld.w t4, X, 0 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.w VX0, t1, 0
    xvinsgr2vr.w VX0, t2, 1
    xvinsgr2vr.w VX0, t3, 2
    xvinsgr2vr.w VX0, t4, 3
    ld.w t1, X, 0 * SIZE
    add.d X, X, INCX
    ld.w t2, X, 0 * SIZE
    add.d X, X, INCX
    ld.w t3, X, 0 * SIZE
    add.d X, X, INCX
    ld.w t4, X, 0 * SIZE
    add.d X, X, INCX
    xvinsgr2vr.w VX0, t1, 4
    xvinsgr2vr.w VX0, t2, 5
    xvinsgr2vr.w VX0, t3, 6
    xvinsgr2vr.w VX0, t4, 7
    xvfmul.s VX2, neg1, VX0
    xvfcmp.clt.s VT0, VX0, res0
    xvbitsel.v VX0, VX0, VX2, VT0
    xvfadd.s res1, VX0, res1
    addi.d  I, I, -1
    blt $r0, I, .L21
    .align 3

.L22:
    xvfadd.s res2, res1, res2
    xvpickve.w VX1, res1, 1
    xvpickve.w VX2, res1, 2
    xvpickve.w VX3, res1, 3
    xvfadd.s res1, VX1, res1
    xvfadd.s res1, VX2, res1
    xvfadd.s res1, VX3, res1
    xvpickve.w VX0, res2, 4
    xvpickve.w VX1, res2, 5
    xvpickve.w VX2, res2, 6
    xvpickve.w VX3, res2, 7
    xvfadd.s res1, VX0, res1
    xvfadd.s res1, VX1, res1
    xvfadd.s res1, VX2, res1
    xvfadd.s res1, VX2, res1
    .align 3

.L23:
    andi I, N, 7
    bge $r0, I, .L999
    .align 3

.L24:
    fld.s $f12, X, 0 * SIZE
    fabs.s $f12, $f12
    fadd.s $f16, $f12, $f16
    addi.d I, I, -1
    add.d  X, X, INCX
    blt $r0, I, .L24
    .align 3

.L999:
    fmov.s $f0, $f16
    jirl $r0, $r1, 0x0
    .align 3

    EPILOGUE