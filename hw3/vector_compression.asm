.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter vector input size (greater than 0):  "
msg2: .asciiz ". Enter num: "
msg3: .asciiz "The non-zero vector is: "
msg4: .asciiz "The non-zero indices are: "
charCR: .asciiz "\n"

.text
.globl main
main:	print_str(msg1) 			# get the vector input size
	read_int($s0)				# store vector size into $s0
	
	li $s1, 0				# use $s1 for index counting
	move $s2, $sp				# save the original location of the stack pointer
	
	get_input:
		print_reg_int($s1)		# print what number currently inputting
		print_str(msg2) 		# ask to enter num
		read_int($t0)			# read value into $t0
		
		beq $t0, $zero, finally		# skip stuff if 0
		not_zero:
			sw $t0 0($sp)		# storing number on stack
			sw $s1, 4($sp) 		# storing index at stack+4
			subi, $sp, $sp, 8	# decrement by 8	 
		finally: 
			addi $s1 $s1, 1
			bne $s0, $s1, get_input
	
	move $s3, $sp				# save the ending point of the stack
	move $sp, $s2				# reset the stack pointer
	
	print_str(msg3)				# print compressed vector
	print_str(charCR)
	print_vector:
		lw $t0, 0($sp)			# load the value at sp into t0
		print_reg_int($t0)		# print the value
		print_str(charCR)		# print a new line
		subi $sp, $sp, 8		# decrement the stack
		bne $sp, $s3, print_vector	# repeat if $sp is not at $s3 (where values end)
	
	move $sp, $s2				# reset the stack pointer
	
	print_str(msg4)				# print compressed vector
	print_str(charCR)
	print_indices:
		lw $t0, 4($sp)			# load the value at sp+4 into t0
		print_reg_int($t0)		# print the value
		print_str(charCR)		# print a new line
		subi $sp, $sp, 8		# decrement the stack
		bne $sp, $s3, print_indices	# repeat if $sp is not at $s3 (where values end)
	
	move $sp, $s2				# reset the stack pointer

	print_str(charCR)
	exit