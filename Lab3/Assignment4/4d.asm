.text
start:
    addi s1, zero, -6       # i = -6
    addi s2, zero, 5        # j = 5
    addi s3, zero, 2        # m = 2
    addi s4, zero, 4        # n = 4
    addi t1, zero, 10       # x = 10
    addi t2, zero, 20       # y = 20
    addi t3, zero, 4        # z = 4
 
    add  t4, s1, s2         # k = i + j
    add  t5, s3, s4         # o = m + n
    bge  t5, t4, else       # if (k > o)
 
then:
    addi t1, t1, 1          # x = x + 1
    addi t3, zero, 1        # z = 1
    j    endif              # skip else
 
else:
    addi t2, t2, -1         # y = y - 1
    add  t3, t3, t3         # z = 2 * z
 
endif: