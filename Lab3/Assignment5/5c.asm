.data
	A: .word 1, 3, 2, 5, 0, 4, 7, 8, 9, 6   # A = [1, 3, 2, 5, 0, 4, 7, 8, 9, 6]

.text
    # s1 = i
    # s2 = &A (&A[0] at init())
    # s3 = n
    # s4 = step
    # s5 = sum
    la   s2, A              # s2 = A[0]
    addi s3, zero, 9        # n = 9 (A.size())
    addi s4, zero, 1        # step = 1
    addi s1, zero, 0        # i = 0
    addi s5, zero, 0        # sum = 0

loop:
                            # while true {
    add  t1, s1, s1         # t1 = 2*i
    add  t1, t1, t1         # t1 = 4*i (word = 4 bytes)
    add  t1, t1, s2         # t1 = &A[i]
    lw   t0, 0(t1)          # t0 = A[i]
    beq  t0, zero, endloop  # if (A[i] == 0) break;
    add  s5, s5, t0         # sum += A[i]

    add  s1, s1, s4         # i += step
    j    loop

endloop: