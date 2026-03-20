.text
    li   t1, 6             # t1 = 6
    li   t2, 8             # t2 = 8

    mv   t3, t2            # t3 = t2.copy()
    li   t4, 0             # t4 = 0

find_n:
    li   t5, 1
    beq  t3, t5, done_find  # if t3 == 1 break;
    srli t3, t3, 1         # t3 = t3 >> 1
    addi t4, t4, 1         # n += 1
    j    find_n

done_find:
    sll  t0, t1, t4