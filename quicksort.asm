# sort an array using the quicksort algorithm

.globl _start

.data # variable declarations
array1: .word -1 22 8 35 5 4 11 2 1 78 # [test]
newline: .asciz "\n"
space: .asciz " "

.text # instructions 
_start:
	# load address of A[0] to a0
	la a1, array1
main:
	li a2, 10
	jal print_array
	
	li a2, 0
	li a3, 9
	jal quicksort
	j exit	
	
# sorts a[lo, hi]
# a1: address of a[0], a2: lo, a3: hi
quicksort:
	bge a2, a3, quicksort_end
		# save to stack
		addi sp, sp, -16
		sw ra, 0(sp)
		sw s0, 4(sp)	# lo
		sw s1, 8(sp)	# hi
		sw s2, 12(sp)	# pivot
		
		mv s0, a2
		mv s1, a3

		jal partition
		mv s2, a0
		
		li a2, 10
		jal print_array
		
		# quicksort(lo, pivot-1)
		mv a2, s0
		addi a3, s2, -1
		jal quicksort
		
		# quicksort(pivot+1, hi)
		addi a2, s2, 1
		mv a3, s1
		jal quicksort
		
		# restore saved values and reset sp 
		lw ra, 0(sp)
		lw s0, 4(sp)
		lw s1, 8(sp)
		lw s2, 12(sp)
		addi sp, sp, 16
		
	quicksort_end:
		ret

# partitions a[lo, hi]
# a1: address of a[0], a2: lo, a3: hi
# returns a0: pivot
partition:
	# save to stack
	addi sp, sp, -16
	sw ra, 0(sp)
	sw s0, 4(sp)	# i
	sw s1, 8(sp)	# j
	sw s2, 12(sp)	# hi
	
	addi s0, a2, -1	# i <- lo-1
	mv s1, a2		# j <- lo
	mv s2, a3  		# s2 <- hi
	
	# pivot <- a[hi]
	slli t0, s2, 2
	add t0, a1, t0
	lw s3, 0(t0)
	
	loop:
		bge s1, s2, loop_exit
		
		slli t0, s1, 2   # offset of A[j] relative to A[0]
		add t0, a1, t0	 # address of A[j]
		lw s4, 0(t0)	 # s4 <- A[j]
		
		bgt s4, s3, skip
			addi s0, s0, 1	# i = i+1
			# swap A[i] with A[j]
			mv a2, s0
			mv a3, s1
			jal swap
			
		skip:
			addi s1, s1, 1	# j = j+1
	j loop
	
	loop_exit:
		# swap A[i+1] with A[hi] 
		addi s0, s0, 1	# i = i+1
		mv a2, s0
		mv a3, s2
		jal swap
	
	# store i in a0 for return
	mv a0, s0
	
	# restore saved values and reset sp 
	lw ra, 0(sp)
	lw s0, 4(sp)
	lw s1, 8(sp)
	lw s2, 12(sp)
	addi sp, sp, 16
	ret
		
# swaps a[i] and a[j]
# a1: address of a[0], a2: i, a3: j
swap:
	addi sp, sp, -4
	sw ra, 0(sp)
	
	slli t0, a2, 2
	add t0, a1, t0
	slli t1, a3, 2
	add t1, a1, t1
	lw t2, 0(t0)
	lw t3, 0(t1)
	sw t2, 0(t1)
	sw t3, 0(t0)
	
	lw ra, 0(sp)
	addi sp, sp, 4
	ret

# prints the array
# a1: address of a[0], a2: n
print_array:
	li t0, 0
	li t1, 0
	print_loop:
		bge t0, a2, print_end
		slli t1, t0, 2
		add t1, a1, t1
	
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
	ret

exit:
	li a7, 10
	ecall
	