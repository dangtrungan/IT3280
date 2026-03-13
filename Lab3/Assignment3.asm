.data

    test: .word 0

.text
main:
    #   s1 = test
    #   s2 = a
    #   s3 = b

    addi s2, zero, 10       # a = 10
    addi s3, zero, 6        # b = 6

    la   s0, test           # s0 = &test
    lw   s1, 0(s0)          # s1 = *s0 = test

    addi t0, zero, 0
    addi t1, zero, 1
    addi t2, zero, 2

			    # switch (test) {
    beq  s1, t0, case_0     # case 0:
    beq  s1, t1, case_1     # case 1:
    beq  s1, t2, case_2     # case 2:
    j    default            # default:

case_0:
    addi s2, s2, 1          # a = a + 1
    j    continue

case_1:
    sub  s2, s2, t1         # a = a - 1
    j    continue

case_2:
    add  s3, s3, s3         # b = 2 * b
    j    continue

default:

continue: