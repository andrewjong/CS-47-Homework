.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter a number ? "
msg2: .asciiz "Factorial of the number is "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1)
	read_int($t0)
	
	# Write body of the iterative
	# factorial program here
	# Store the factorial result into 
	# register $s0
	li $t1, 1 			# store the value 1 into t1
	li $s0, 1			# initialize return value as 1
	loop:	
		mul $s0, $s0, $t0	# multiply $s0 by the factor
		subi $t0, $t0, 1	# subtract 1 from the vactor
		bne $t0, $t1, loop	# loop
	
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit