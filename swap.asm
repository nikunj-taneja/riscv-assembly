# modify and swap two variables in memory

.globl _start

.data # variable declarations
var1: .word 15
var2: .word 19
newline: .asciz "\n"

.text # instructions
_start:
	li a7, 1
	la a0, var1
	ecall
	jal print_newline
	
	li a7, 1
	la a0, var2
	ecall
	jal print_newline
	
	# load addresses of var1, var2 to registers t0, t1
	la t0, var1
	la t1, var2
	
	# load values of var1, var2 to registers t2, t3
	lw t2, (t0)
	lw t3, (t1)
	
	# modify var1, var2
	addi t2, t2, 1
	slli t3, t3, 2
	
	# print var1, var2
	li a7, 1
	mv a0, t2
	ecall
	jal print_newline
	
	li a7, 1
	mv a0, t3
	ecall
	jal print_newline
	
	# swap var1, var2 in memory
	sw t2, (t1)
	sw t3, (t0)
	
	# load values of var1, var2 to registers again
	lw t2, (t0)
	lw t3, (t1)
	
	# print var1, var2
	li a7, 1
	mv a0, t2
	ecall
	jal print_newline
	
	li a7, 1
	mv a0, t3
	ecall
	
	# end
	j exit
		
print_newline:
	li a7, 4
	la a0, newline
	ecall
	ret 
	 
exit:
	li a7, 10
	ecall
	