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
    .globl reverse

reverse:
    li      t0, 0               # ret = 0
    li      t1, 0               # i = 0
rev_loop:
    bge     t1, a1, rev_end
    li      t2, 1
    sll     t2, t2, t1          # t2 = 1 << i
    and     t3, a0, t2          # t3 = x & (1 << i)
    beqz    t3, rev_skip
    sub     t4, a1, t1
    addi    t4, t4, -1          # t4 = l - i - 1
    li      t5, 1
    sll     t5, t5, t4          # t5 = 1 << (l - i - 1)
    add     t0, t0, t5          # ret += t5
rev_skip:
    addi    t1, t1, 1
    j       rev_loop
rev_end:
    mv      a0, t0
    ret

dft_transform_impl:
# --------------------------------------- TODO: FILL IN CODE HERE ---------------------------------------
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

    # load global
    la      s0, N
    lw      s0, 0(s0)           # s0 = N
    la      s1, X               # s1 = &X[0]
    la      s2, Y               # s2 = &Y[0]
    la      s3, expTable        # s3 = &expTable[0]

    # calc l = log2(N)
    li      s4, 0               # l = 0
    li      t0, 1               # i = 1
calc_l:
    bge     t0, s0, calc_l_end
    slli    t0, t0, 1
    addi    s4, s4, 1
    j       calc_l
calc_l_end:

    li      s8, 0               # i = 0
rev_store:
    bge     s8, s0, rev_store_end
    mv      a0, s8              # a0 = i
    mv      a1, s4              # a1 = l
    call    reverse             # a0 = reverse(i, l)
    slli    t0, a0, 3           # m * 8
    add     t1, s1, t0          # &X[m]
    lw      t2, 0(t1)           # X[m].x
    lw      t3, 4(t1)           # X[m].y
    slli    t4, s8, 3           # i * 8
    add     t5, s2, t4          # &Y[i]
    sw      t2, 0(t5)
    sw      t3, 4(t5)
    addi    s8, s8, 1
    j       rev_store
rev_store_end:

    # copy Y to X
    li      s8, 0
copy_yx:
    bge     s8, s0, copy_yx_end
    slli    t0, s8, 3
    add     t1, s2, t0          # &Y[i]
    lw      t2, 0(t1)
    lw      t3, 4(t1)
    add     t4, s1, t0          # &X[i]
    sw      t2, 0(t4)
    sw      t3, 4(t4)
    addi    s8, s8, 1
    j       copy_yx
copy_yx_end:

    # for (size = 2; size <= N; size <<= 1)
    li      s5, 2               # size = 2
size_loop:
    bgt     s5, s0, size_end
    srli    s6, s5, 1           # halfsize = size / 2
    div     s7, s0, s5          # expTable_step = N / size

    li      s8, 0               # i = 0
i_loop:
    bge     s8, s0, i_end
    li      s10, 0              # twiddle_k = 0
    mv      s9, s8              # j = i
    add     s11, s8, s6         
j_loop:
    bge     s9, s11, j_end

    slli    t0, s9, 3           # j * 8
    add     t1, s1, t0          # t1 = &X[j]
    slli    t2, s6, 3           # halfsize * 8
    add     t3, t1, t2          # t3 = &X[j+halfsize]

    # load X[j] and X[j+halfsize]
    lw      t4, 0(t1)           # X[j].x
    lw      t5, 4(t1)           # X[j].y
    lw      t6, 0(t3)           # X[j+halfsize].x
    lw      a0, 4(t3)           # X[j+halfsize].y

    # load expTable
    slli    a1, s10, 3
    add     a1, s3, a1
    lw      a2, 0(a1)           # expTable.x
    lw      a3, 4(a1)           # expTable.y

    # mymul implemented here
    mul     a4, t6, a2
    srai    a4, a4, 13          # m1 = (X[j+halfsize].x * wx) >> 13
    mul     a5, a0, a3
    srai    a5, a5, 13          # m2 = (X[j+halfsize].y * wy) >> 13
    mul     a6, t6, a3
    srai    a6, a6, 13          # m3 = (X[j+halfsize].x * wy) >> 13
    mul     a7, a0, a2
    srai    a7, a7, 13          # m4 = (X[j+halfsize].y * wx) >> 13

    # diff = m1 - m2，sum = m3 + m4
    sub     a4, a4, a5          # a4 = diff
    add     a6, a6, a7          # a6 = sum

    # x1 = X[j].x - diff，y1 = X[j].y - sum
    sub     a5, t4, a4          # a5 = x1
    sub     a7, t5, a6          # a7 = y1

    # x2 = X[j].x + diff，y2 = X[j].y + sum
    add     a4, t4, a4          # a4 = x2
    add     a6, t5, a6          # a6 = y2

    # writeback
    sw      a4, 0(t1)           # X[j].x        = x2
    sw      a6, 4(t1)           # X[j].y        = y2
    sw      a5, 0(t3)           # X[j+halfsize].x = x1
    sw      a7, 4(t3)           # X[j+halfsize].y = y1

    add     s10, s10, s7        # twiddle_k += expTable_step
    addi    s9, s9, 1           # j++
    j       j_loop
j_end:
    add     s8, s8, s5          # i += size
    j       i_loop
i_end:
    slli    s5, s5, 1           # size <<= 1
    j       size_loop
size_end:

    # return
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
