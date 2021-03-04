# partition an array, given a pivot

.globl _start

.data # variable declarations
array1: .word -1 22 8 35 5 4 11 2 1 78 # [test]: use 8 as pivot
newline: .asciz "\n"
space: .asciz " "

.text # instructions 
_start:
	# load address of A[0] to a0
	la a0, array1

partition:
	# swap A[2] and A[9] to store pivot at the end
	li a1, 2
	li a2, 9
	jal swap
	
	li s0, -1	# t4 <- lo-1 (i = -1)
	li s1, 0	# t5 <- lo (j = 0)
	li s2, 9  	# t6 <- hi (hi = 9)
	
	# s3 <- pivot
	lw s3, 36(a0)
	
	loop:
		bge s1, s2, loop_exit
		
		slli t0, s1, 2   # offset of A[j] relative to A[0]
		add t0, a0, t0	 # address of A[j]
		lw s4, 0(t0)	 # s4 <- A[j]
		
		bgt s4, s3, skip
			addi s0, s0, 1	# i = i+1
			# swap A[i] with A[j]
			mv a1, s0
			mv a2, s1
			jal swap
			
		skip:
			addi s1, s1, 1	# j = j+1
	j loop
	
	loop_exit:
		# swap A[i+1] with A[hi] 
		addi s0, s0, 1	# i = i+1
		mv a1, s0
		mv a2, s2
		jal swap
	
	li a1, 10
	jal print_array	
	j exit
		
# swaps a[i] and a[j]
# a0: address of a[0], a1: i, a2: j
swap:
	slli t0, a1, 2
	add t0, a0, t0
	slli t1, a2, 2
	add t1, a0, t1
	lw t2, 0(t0)
	lw t3, 0(t1)
	sw t2, 0(t1)
	sw t3, 0(t0)
	ret

# prints the array
# a0: address of a[0], a1: n
print_array:
	li t0, 0
	li t1, 0
	mv a2, a0
	print_loop:
		bge t0, a1, print_end
		slli t1, t0, 2
		add t1, a2, t1
	
		li a7, 1
		lw a0, 0(t1)
		ecall
	
		li a7, 4
		la a0, space
		ecall
		
		addi t0, t0, 1
		j print_loop
	print_end:
		li a7, 4
		la a0, newline
		ecall

exit:
	li a7, 10
	ecall
	