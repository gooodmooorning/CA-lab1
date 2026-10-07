.data
# -------------------------------------- TODO: FILL IN YOUR FILE PATH !!! -------------------------------------------
read_path:
		.string "/home/student/yao-archlab-f26/lab1/sample/data.in"
write_path:
		.string "/home/student/yao-archlab-f26/lab1/sample/data.out"
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

dft_transform_impl:
# --------------------------------------- TODO: FILL IN CODE HERE ---------------------------------------
        addi sp, sp, -128
        sw ra, 124(sp)
        sw s0, 120(sp)
        sw s1, 116(sp)
        sw s2, 112(sp)
        sw s3, 108(sp)
        sw s4, 104(sp)
        sw s5, 100(sp)
        sw s6, 96(sp)
        sw s7, 92(sp)
        sw s8, 88(sp)
        sw s9, 84(sp)
        sw s10, 80(sp)
        sw s11, 76(sp)

        # 加载全局变量地址
        la s0, N
        lw s0, 0(s0)          # s0 = N
        la s1, X              # s1 = &X[0]
        la s2, Y              # s2 = &Y[0]
        la s3, expTable       # s3 = &expTable[0]

        # 计算 l = log2(N)
        li s4, 0              # l = 0
        li t0, 1              # i = 1
    loop_l:
        bge t0, s0, end_l
        slli t0, t0, 1
        addi s4, s4, 1
        j loop_l
    end_l:

        # 第一个循环：位反转存入 Y
        li s8, 0              # i = 0
    loop_rev:
        bge s8, s0, end_rev
        mv a0, s8             # a0 = i
        mv a1, s4             # a1 = l
        call reverse          # a0 = reverse(i, l)
        mv t0, a0             # m = reverse(i, l)
        slli t0, t0, 3        # m * 8
        add t0, s1, t0        # &X[m]
        lw t1, 0(t0)          # X[m].x
        lw t2, 4(t0)          # X[m].y
        slli t3, s8, 3        # i * 8
        add t3, s2, t3        # &Y[i]
        sw t1, 0(t3)
        sw t2, 4(t3)
        addi s8, s8, 1
        j loop_rev
    end_rev:

        # 复制 Y 到 X
        li s8, 0
    loop_copy:
        bge s8, s0, end_copy
        slli t0, s8, 3        # i * 8
        add t1, s2, t0        # &Y[i]
        lw t2, 0(t1)
        lw t3, 4(t1)
        add t4, s1, t0        # &X[i]
        sw t2, 0(t4)
        sw t3, 4(t4)
        addi s8, s8, 1
        j loop_copy
    end_copy:

        # 外层循环：for (size = 2; size <= N; size <<= 1)
        li s5, 2              # size = 2
    loop_size:
        bgt s5, s0, end_size
        srli s6, s5, 1        # halfsize = size / 2
        div s7, s0, s5        # expTable_step = N / size (需 RV32M)

        li s8, 0              # i = 0
    loop_i:
        bge s8, s0, end_i
        li s10, 0             # twiddle_k = 0
        mv s11, s8            # j = i
        add s9, s8, s6        # s9 = i + halfsize
    loop_j:
        bge s11, s9, end_j

        # 计算地址
        slli t0, s11, 3       # j * 8
        add t1, s1, t0        # &X[j]
        slli t2, s6, 3        # halfsize * 8
        add t3, t1, t2        # &X[j+halfsize]
        sw t1, 48(sp)         # 保存 &X[j]
        sw t3, 52(sp)         # 保存 &X[j+halfsize]

        # 加载原始 X[j] 和 X[j+halfsize]
        lw t4, 0(t1)
        sw t4, 0(sp)          # X[j].x
        lw t4, 4(t1)
        sw t4, 4(sp)          # X[j].y
        lw t4, 0(t3)
        sw t4, 8(sp)          # X[j+halfsize].x
        lw t4, 4(t3)
        sw t4, 12(sp)         # X[j+halfsize].y

        # 加载 expTable[twiddle_k]
        slli t4, s10, 3       # twiddle_k * 8
        add t4, s3, t4        # &expTable[twiddle_k]
        lw t5, 0(t4)
        sw t5, 16(sp)         # expTable.x
        lw t5, 4(t4)
        sw t5, 20(sp)         # expTable.y

        # 调用 mymul 计算四个乘积
        # mymul(X[j+halfsize].x, expTable.x)
        lw a0, 8(sp)
        lw a1, 16(sp)
        call mymul
        sw a0, 24(sp)         # m1

        # mymul(X[j+halfsize].y, expTable.y)
        lw a0, 12(sp)
        lw a1, 20(sp)
        call mymul
        sw a0, 28(sp)         # m2

        # mymul(X[j+halfsize].x, expTable.y)
        lw a0, 8(sp)
        lw a1, 20(sp)
        call mymul
        sw a0, 32(sp)         # m3

        # mymul(X[j+halfsize].y, expTable.x)
        lw a0, 12(sp)
        lw a1, 16(sp)
        call mymul
        sw a0, 36(sp)         # m4

        # 计算 x1 = X[j].x - (m1 - m2)
        lw t0, 24(sp)         # m1
        lw t1, 28(sp)         # m2
        sub t2, t0, t1        # m1 - m2
        lw t3, 0(sp)          # X[j].x
        sub t4, t3, t2
        sw t4, 40(sp)         # x1

        # 计算 y1 = X[j].y - (m3 + m4)
        lw t0, 32(sp)         # m3
        lw t1, 36(sp)         # m4
        add t2, t0, t1        # m3 + m4
        lw t3, 4(sp)          # X[j].y
        sub t4, t3, t2
        sw t4, 44(sp)         # y1

        # 计算 x2 = X[j].x + (m1 - m2)
        lw t0, 24(sp)
        lw t1, 28(sp)
        sub t2, t0, t1
        lw t3, 0(sp)
        add t4, t3, t2
        sw t4, 56(sp)         # x2

        # 计算 y2 = X[j].y + (m3 + m4)
        lw t0, 32(sp)
        lw t1, 36(sp)
        add t2, t0, t1
        lw t3, 4(sp)
        add t4, t3, t2
        sw t4, 60(sp)         # y2

        # 写回结果
        lw t1, 48(sp)         # &X[j]
        lw t3, 52(sp)         # &X[j+halfsize]
        lw t4, 56(sp)
        sw t4, 0(t1)          # X[j].x = x2
        lw t4, 60(sp)
        sw t4, 4(t1)          # X[j].y = y2
        lw t4, 40(sp)
        sw t4, 0(t3)          # X[j+halfsize].x = x1
        lw t4, 44(sp)
        sw t4, 4(t3)          # X[j+halfsize].y = y1

        # twiddle_k += expTable_step
        add s10, s10, s7
        addi s11, s11, 1
        j loop_j
    end_j:
        add s8, s8, s5        # i += size
        j loop_i
    end_i:
        slli s5, s5, 1        # size <<= 1
        j loop_size
    end_size:

        # 恢复寄存器并返回
        lw ra, 124(sp)
        lw s0, 120(sp)
        lw s1, 116(sp)
        lw s2, 112(sp)
        lw s3, 108(sp)
        lw s4, 104(sp)
        lw s5, 100(sp)
        lw s6, 96(sp)
        lw s7, 92(sp)
        lw s8, 88(sp)
        lw s9, 84(sp)
        lw s10, 80(sp)
        lw s11, 76(sp)
        addi sp, sp, 128
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
