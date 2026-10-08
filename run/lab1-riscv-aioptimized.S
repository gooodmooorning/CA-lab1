.data
# -------------------------------------- TODO: FILL IN YOUR FILE PATH !!! -------------------------------------------
read_path:
		.string "/home/student/labs/CA-lab1/sample/data.in"
write_path:
		.string "/home/student/labs/CA-lab1/sample/data.out"
# ------------------------------------------------------------------------------------------------------------------
X:
        .zero   1024

# Y is available for implementations that are not fully in-place.
# If your code operates fully in-place, you can ignore or remove the Y array.
Y:
	.zero	1024

N:
        .zero   4

# expTable is stored same as C code
# Notice the second half is all zero!
expTable:
        .word	8192
        .word	0
        .word	8182
        .word	-401
        .word	8152
        .word	-802
        .word	8103
        .word	-1202
        .word	8034
        .word	-1598
        .word	7946
        .word	-1990
        .word	7839
        .word	-2378
        .word	7713
        .word	-2759
        .word	7568
        .word	-3134
        .word	7405
        .word	-3502
        .word	7224
        .word	-3861
        .word	7026
        .word	-4211
        .word	6811
        .word	-4551
        .word	6579
        .word	-4879
        .word	6332
        .word	-5196
        .word	6069
        .word	-5501
        .word	5792
        .word	-5792
        .word	5501
        .word	-6069
        .word	5196
        .word	-6332
        .word	4879
        .word	-6579
        .word	4551
        .word	-6811
        .word	4211
        .word	-7026
        .word	3861
        .word	-7224
        .word	3502
        .word	-7405
        .word	3134
        .word	-7568
        .word	2759
        .word	-7713
        .word	2378
        .word	-7839
        .word	1990
        .word	-7946
        .word	1598
        .word	-8034
        .word	1202
        .word	-8103
        .word	802
        .word	-8152
        .word	401
        .word	-8182
        .word	0
        .word	-8192
        .word	-401
        .word	-8182
        .word	-802
        .word	-8152
        .word	-1202
        .word	-8103
        .word	-1598
        .word	-8034
        .word	-1990
        .word	-7946
        .word	-2378
        .word	-7839
        .word	-2759
        .word	-7713
        .word	-3134
        .word	-7568
        .word	-3502
        .word	-7405
        .word	-3861
        .word	-7224
        .word	-4211
        .word	-7026
        .word	-4551
        .word	-6811
        .word	-4879
        .word	-6579
        .word	-5196
        .word	-6332
        .word	-5501
        .word	-6069
        .word	-5792
        .word	-5792
        .word	-6069
        .word	-5501
        .word	-6332
        .word	-5196
        .word	-6579
        .word	-4879
        .word	-6811
        .word	-4551
        .word	-7026
        .word	-4211
        .word	-7224
        .word	-3861
        .word	-7405
        .word	-3502
        .word	-7568
        .word	-3134
        .word	-7713
        .word	-2759
        .word	-7839
        .word	-2378
        .word	-7946
        .word	-1990
        .word	-8034
        .word	-1598
        .word	-8103
        .word	-1202
        .word	-8152
        .word	-802
        .word	-8182
        .word	-401
        .zero	512


.text
main:
        addi    sp,sp,-16
        sw      ra,12(sp)
        jal    data_input
        jal    dft_transform_impl
        jal    data_output
        lw      ra,12(sp)
        li      a0,0
        li a7, 10
        ecall
        addi    sp,sp,16
        jr      ra


_printf_num:
# DO NOT MODIFY THIS!!!
        li a7, 1
        ecall
        ret


_printf_char:
# DO NOT MODIFY THIS!!!
        li a7, 11
        ecall
        ret


_read_int:
# DO NOT MODIFY THIS!!!
        mv      a5,a1
        mv      a4,a2
        li a7, 1024
        li a1, 0
        ecall
        mv t3, a0
        li a7, 65
        mv a1, a5
        mv a2, a4
        ecall
        li a7, 57
        mv a0, t3
        ecall
        ret


_write_int:
# DO NOT MODIFY THIS!!!
        mv a5, a1
        mv a4, a2
        li a7, 1024
        li a1, 1
        ecall
        mv t3, a0
        li a7, 66
        mv a1, a5
        mv a2, a4
        ecall
        li a7, 57
        mv a0, t3
        ecall
        ret

    .text
    .globl dft_transform_impl

dft_transform_impl:
# --------------------------------------- TODO: FILL IN CODE HERE ---------------------------------------
    .text
    .globl dft_transform_impl

dft_transform_impl:
    addi    sp, sp, -128
    sw      ra, 124(sp)
    sw      s0, 120(sp)
    sw      s1, 116(sp)
    sw      s2, 112(sp)
    sw      s3, 108(sp)
    sw      s4, 104(sp)
    sw      s5, 100(sp)
    sw      s6, 96(sp)
    sw      s7, 92(sp)
    sw      s8, 88(sp)
    sw      s9, 84(sp)
    sw      s10, 80(sp)
    sw      s11, 76(sp)

    la      s0, N
    lw      s0, 0(s0)
    la      s1, X
    la      s3, expTable

    # l = log2(N)
    li      s4, 0
    li      t0, 1
calc_l:
    bge     t0, s0, calc_l_end
    slli    t0, t0, 1
    addi    s4, s4, 1
    j       calc_l
calc_l_end:

    # ---------- 位反转（递增递推，原地）----------
    li      s8, 1
    li      s9, 0
    srli    s10, s0, 1
rev_loop:
    bge     s8, s0, rev_end
    mv      t0, s9
    mv      t1, s10
rev_carry:
    and     t2, t0, t1
    beqz    t2, rev_carry_done
    xor     t0, t0, t1
    srli    t1, t1, 1
    j       rev_carry
rev_carry_done:
    xor     s9, t0, t1
    bge     s8, s9, rev_next
    slli    t2, s8, 3
    add     t2, s1, t2
    slli    t3, s9, 3
    add     t3, s1, t3
    lw      t4, 0(t2)
    lw      t5, 4(t2)
    lw      t6, 0(t3)
    lw      a0, 4(t3)
    sw      t6, 0(t2)
    sw      a0, 4(t2)
    sw      t4, 0(t3)
    sw      t5, 4(t3)
rev_next:
    addi    s8, s8, 1
    j       rev_loop
rev_end:

    # ---------- size = 2 特化 ----------
    li      s8, 0
sz2_loop:
    bge     s8, s0, sz2_end
    slli    t0, s8, 3
    add     t1, s1, t0
    lw      t2, 0(t1)
    lw      t3, 4(t1)
    lw      t4, 8(t1)
    lw      t5, 12(t1)
    add     t6, t2, t4
    add     a0, t3, t5
    sub     a1, t2, t4
    sub     a2, t3, t5
    sw      t6, 0(t1)
    sw      a0, 4(t1)
    sw      a1, 8(t1)
    sw      a2, 12(t1)
    addi    s8, s8, 2
    j       sz2_loop
sz2_end:

    # ---------- 主循环：size = 4 起，内层展开 2 次 ----------
    li      s5, 4               # size
    srli    s7, s0, 2           # N/4
    slli    s7, s7, 3           # 字节步长 = (N/4)*8

size_loop:
    bgt     s5, s0, size_end
    srli    s6, s5, 1           # halfsize

    li      s8, 0               # i = 0
i_loop:
    bge     s8, s0, i_end

    slli    t1, s8, 3
    add     s10, s1, t1         # &X[i]
    slli    t1, s6, 3
    add     s11, s10, t1        # &X[i+halfsize]
    mv      t0, s3              # &expTable[0]
    srli    s9, s6, 1           # 内层迭代次数 = halfsize/2

inner_loop:
    # ---- 第一组 ----
    lw      t1, 0(s10)          # X[j].x
    lw      t2, 4(s10)          # X[j].y
    lw      t3, 0(s11)          # X[j+h].x
    lw      t4, 4(s11)          # X[j+h].y
    lw      t5, 0(t0)           # W.x
    lw      t6, 4(t0)           # W.y
    mul     a0, t3, t5
    mul     a1, t4, t6
    mul     a2, t3, t6
    mul     a3, t4, t5
    srai    a0, a0, 13
    srai    a1, a1, 13
    srai    a2, a2, 13
    srai    a3, a3, 13
    sub     a4, a0, a1          # diff = m1 - m2
    add     a5, a2, a3          # sum  = m3 + m4
    sub     a6, t1, a4          # x1
    sub     a7, t2, a5          # y1
    add     a0, t1, a4          # x2
    add     a1, t2, a5          # y2
    sw      a0, 0(s10)
    sw      a1, 4(s10)
    sw      a6, 0(s11)
    sw      a7, 4(s11)

    # ---- 第二组 ----
    lw      t1, 8(s10)
    lw      t2, 12(s10)
    lw      t3, 8(s11)
    lw      t4, 12(s11)
    add     t0, t0, s7
    lw      t5, 0(t0)
    lw      t6, 4(t0)
    mul     a0, t3, t5
    mul     a1, t4, t6
    mul     a2, t3, t6
    mul     a3, t4, t5
    srai    a0, a0, 13
    srai    a1, a1, 13
    srai    a2, a2, 13
    srai    a3, a3, 13
    sub     a4, a0, a1
    add     a5, a2, a3
    sub     a6, t1, a4
    sub     a7, t2, a5
    add     a0, t1, a4
    add     a1, t2, a5
    sw      a0, 8(s10)
    sw      a1, 12(s10)
    sw      a6, 8(s11)
    sw      a7, 12(s11)

    addi    s10, s10, 16
    addi    s11, s11, 16
    add     t0, t0, s7
    addi    s9, s9, -1
    bnez    s9, inner_loop

    add     s8, s8, s5
    j       i_loop
i_end:
    slli    s5, s5, 1
    srli    s7, s7, 1
    j       size_loop
size_end:

    lw      ra, 124(sp)
    lw      s0, 120(sp)
    lw      s1, 116(sp)
    lw      s2, 112(sp)
    lw      s3, 108(sp)
    lw      s4, 104(sp)
    lw      s5, 100(sp)
    lw      s6, 96(sp)
    lw      s7, 92(sp)
    lw      s8, 88(sp)
    lw      s9, 84(sp)
    lw      s10, 80(sp)
    lw      s11, 76(sp)
    addi    sp, sp, 128
    ret
# -------------------------------------------------------------------------------------------------------

# The .s code reads and writes data in exactly the same format as C code.
#  The data is stored in the X array in the same format as a C struct (with real and imaginary parts interleaved).
# DATA_OUTPUT
data_output:
# DO NOT MODIFY THIS!!!
    addi sp,sp,-4
    sw ra,0(sp)

    la a0, write_path
    li a7, 1024
    li a1, 1
    ecall

    mv t3, a0

	la a1, N
	li a2, 1
	li a7, 66
	ecall

	lw t0, N
	la t2, X
	addi t4, zero, 0
OUTPUT_ONE_LINE:
	mv a0, t3
	mv a1, t2
	li a2, 2
	li a7, 66
	ecall
	addi t2, t2, 8
	addi t4, t4, 1
	blt t4, t0, OUTPUT_ONE_LINE

    mv a0, t3
    li a7, 57
    ecall
    lw ra,0(sp)
    addi sp,sp,4
    jr ra
# DATA_OUTPUT_END

# DATA_INPUT
data_input:
# DO NOT MODIFY THIS!!!
    addi sp,sp,-4
    sw ra, 0(sp)

    li a7, 1024
    li a1, 0
    la a0, read_path
    ecall

    mv t3, a0
    li a7, 65
    la a1, N
    li a2, 1
    ecall

    li a7, 65
    mv a0, t3
    la a1, X
    li a2, 256
    ecall

    mv a0, t3
    li a7, 57
    ecall
    lw ra, 0(sp)
    addi sp, sp, 4
    mv a0, t4
    mv a1, t5
    jr ra
# DATA_INPUT_END
