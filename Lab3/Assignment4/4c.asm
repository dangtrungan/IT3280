.text
start:
    addi s1, zero, -6       # i = -6
    addi s2, zero, 5        # j = 5
    addi t1, zero, 10       # x = 10
    addi t2, zero, 20       # y = 20
    addi t3, zero, 4        # z = 4
 
    add  s3, s1, s2         # k = i + j
    blt  zero, s3, else     # if (k <= 0)
 
then:
    addi t1, t1, 1          # x = x + 1
    addi t3, zero, 1        # z = 1
    j    endif              # skip else
 
else:
    addi t2, t2, -1         # y = y - 1
    add  t3, t3, t3         # z = 2 * z
 
endif: