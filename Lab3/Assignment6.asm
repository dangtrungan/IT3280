# Register assignment:
#   int* s0 = &A[0];
#   int  s1 = n;
#   int  s2 = i;
#   int  s3 = maxAbs;
#   int  s4 = maxIdx;
#   int  t0 = A[i];
#   int  t1 = abs(A[i]);
#   int* t2 = &A[i];
.data
    A:   .word 3, -15, 7, -2, 20, -18, 5, 11   # A = [3, -15, 7, -2, 20, -18, 5, 11]
.text
    la   s0, A              # s0 = &A[0];
    addi s1, zero, 8        # s1 = A.length();
    addi s2, zero, 0        # s2 = 0;
    lw   t0, 0(s0)          # t0 = A[0];
    jal  ra, abs_val        # t1 = abs(t0);
    add  s3, zero, t1       # maxAbs = t1;
    addi s4, zero, 0        # maxIdx = 0;
    addi s2, zero, 1        # s2 = 1;
    
loop:
                            # while true {
    bge  s2, s1, endloop    #     if (i >= n) break;
    
                            #     t2 = &A[i]
    add  t2, s2, s2         #     t2 = s2 + s2
    add  t2, t2, t2         #     t2 = t2 + t2
    add  t2, t2, s0         #     t2 = t2 + s0
    
    lw   t0, 0(t2)          #     t0 = *t2
    
                            #     t1 = abs(A[i])
    j    abs_val            #     t1 = abs(t0)
    
    ble  t1, s3, continue   #     if (abs(A[i]) <= maxAbs) continue;
    add  s3, zero, t1       #     maxAbs = abs(A[i]);
    add  s4, zero, s2       #     maxIdx = i;

continue:
    addi s2, s2, 1          #     i++;
    j    loop               # }

endloop:

abs_val:
    blt  t0, zero, abs_neg  # if (t0 >= 0) {
    add  t1, zero, t0       #     t1 = t0;
    jalr x0, 0(ra)          #     return t1;
                            # }
abs_neg:                    # else {
    sub  t1, zero, t0       #     t1 = -t0;
    jalr x0, 0(ra)          #     return t1;
                            # }