.text
	li   t0, 0
	li   s1, 0x7FFFFFFF
	li   s2, 1
	add  s3, s1, s2
	xor  t1, s1, s2
	blt  t1, zero, EXIT
	xor  t2, s1, s3
	bge  t2, zero, EXIT
	jal  x0, OVERFLOW
	
OVERFLOW:
	addi t0, t0, 1
	
EXIT: