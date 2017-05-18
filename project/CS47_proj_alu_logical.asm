.include "./cs47_proj_macro.asm"
.text
.globl au_logical
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_logical
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':addop, '-':sub_op, '*':mul_op, '/':div_op)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
	# store all used registers on the stack
	addi $sp, $sp, -48
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)
	sw $ra, 32($sp)
	sw $a0, 36($sp)
	sw $a1, 40($sp)
	sw $a2, 44($sp)


	li $t0, '+'						# determine which opcode to perform
	beq $a2, $t0, addsubop
	li $t0, '-'
	beq $a2, $t0, addsubop
	li $t0, '*'
	beq $a2, $t0, mulop
	li $t0, '/'
	beq $a2, $t0, divop
	j end 							# skip everything if no opcode

addsubop:
	move $s0, $zero						# in $s0, (I) initialize the counter with 0 
	move $s1, $zero						# in $s1, (S) initialize the sum as 0 
	move $s2, $zero						# in $s2, (C) establish the carry value
	# invert a number if subtraction and set ci to 1
	li $t0, '-'
	bne $t0, $a2, addop					# 	  if operations +, not -, skip inversion of argument 
	not $a1, $a1						# 	  invert $a1
	addi $s2, $s2, 1					# 	  set ci to 1 if subtract
		
addop:
	# extract what's relevant
	extract_n($a0, $s0)					# 	  extract the ith bit for 1st number a0
	move $s3, $v0						# in $s3, store the extracted a0[i]
	extract_n($a1, $s0)					# 	  extract the ith bit for 2nd number a1
	move $s4, $v0						# in $s4, store the extracted a1[i]
	# do the add
	xor $s5, $s3, $s4					# in $s5, "add" the bits from a0 and a1 using xor (y) 
	xor $s5, $s5, $s2					# 	  also "add" the carry value
	# do the carry
	xor $t0, $s3, $s4					# 	  CO algo is CI(AxB)+AB. CO will be stored where CI was. This is the AxB part
	and $s2, $s2, $t0					# in $s2, the carry, store the CI(AxB) part
	and $t0, $s3, $s4					#	  this is the AB part
	or $s2, $s2, $t0					# in $s2, add the AB
	# set the right bit
	set_n_with($s1, $s0, $s5)				# 	  store (y) in sum at appropriate location
	move $s1, $v0
	addi $s0, $s0, 1					# 	  increment counter (i)
	li $t0, 32						#	  the size of MIPS ints
	bne $s0, $t0, addop					#	  repeat if i!=32
	move $v1, $s2
j end

mulop:
	li $t0, '.' 			# THIS IS WHERE MULTIPLICATION STARTS

	move $s1, $a0			# in $s1, (N1) store $a0
	move $s2, $a1			# in $s2, (N2) store $a1

	result_sign($s1, $s2)		# get the sign of multiplying the two numbers
	move $s0, $v0			# in $s0, (S) store the sign

	abs_val($s1)			# find the absolute value of N1
	move $s1, $v0
	abs_val($s2)			# find the absolute value of N2
	move $s2, $v0

	move $a0, $s1			# put |N1| in $a0
	move $a1, $s2			# put |N2| in $a1

	jal mul_unsigned		# do an unsigned multiplication

	beq $s0, $zero, fi_mulop 	# if positive number, jump to end
	twos_comp_64($v0, $v1)		# else switch to negative

	fi_mulop:

j end

# unsigned multiplication. $a0 multiplicand. $a1 multiplier. $v0 Lo. $v1 Hi
mul_unsigned:
	li $t0, 'x'				# THIS IS WHERE MULTIPLICATION UNSIGNED STARTS
	addi $sp, $sp, -28
	sw $s0, ($sp)				# store on the stack
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)

	move $s0, $zero				# in $s0, (I) start index i at 0
	move $s1, $zero				# in $s1, (H) variable thing
	move $s2, $a0				# in $s2, (M) put the multiplicand
	move $s3, $a1				# in $s3, (L) put the multiplier

	mul_unsigned_loop:
		extract_n($s3, $zero)		# extract the 0th bit from L and replicate it
		bit_replicator($v0) 		# replicate it. R = {32{L[0]}} 

		and $s4, $s2, $v0		# in $s4, (X) = M & R

		add $s1, $s1, $s4		# H = H + X

		srl $s3, $s3, 1			# L = L >> 1

		extract_n($s1, $zero)		# H[0] 
		li $t9, 31			# the index for setting at L
		set_n_with($s3, $t9, $v0)	# L[31] = H[0]
		move $s3, $v0			# overwrite L with new value

		srl $s1, $s1, 1			# H = H >> 1

		addi $s0, $s0, 1 		# I = I + 1

		li $t0, 32			# set limit to 32
		bne $s0, $t0, mul_unsigned_loop # REPEAT LOOP
		move $v1, $s1
		move $v0, $s3
	
	lw $s0, ($sp)				# restore from the stack
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
jr $ra # end

divop:
	li $t0, '/'		# THIS IS WHERE DIVISION STARTS
	move $s0, $zero		# in $s0, (I) counter = 0
	move $s1, $a0		# in $s1, (Q) = dividend
	move $s2, $a1		# in $s2, (D) = divisor
	move $s3, $zero		# in $s3, (R) remainder = 0

	result_sign($s1, $s2)		
	move $s5, $v0		# in $s5, store the sign result of the operation
	result_sign($s1, $zero)
	move $s6, $v0		# in $s6, extract the sign bit of the first argument

	abs_val($s1)
	move $s1, $v0		# in $a0, put |$a0|
	abs_val($s2)				
	move $s2, $v0		# in $a1, put |$a1|

	unsigned_div_loop:	# DIVISION LOOP
		sll $s3, $s3, 1			# R = R << 1
		
		li $t0, 31				
		extract_n($s1, $t0)		# Q[31]
		set_n_with($s3, $zero, $v0) 	# in $v0, set Q[31]
		move $s3, $v0			# R[0] = Q[31]

		sll $s1, $s1, 1			# Q = Q << 1

		sub $s4, $s3, $s2		# in $s4, (S) = R - D

		blt $s4, $zero, skip_set_remainder 	# S < 0?
		move $s3, $s4			#  R = S
		set_n($s1, $zero)		
		move $s1, $v0			# Q[0] = 1

		skip_set_remainder:
		addi $s0, $s0, 1

		li $t0, 32
		bne $s0, $t0, unsigned_div_loop # REPEAT LOOP

	quotient_sign:
		beq $s5, $zero, remainder_sign 	# if result sign positive number, determine remainder sign
		twos_comp($s1)			# take the two's complement on quotient
		move $s1, $v0			# in $s1, (Q) put result

	remainder_sign:
		beq $s6, $zero, fi_divop 	# if result sign of first argument was 0, skip taking 2's comp
		twos_comp($s3)
		move $s3, $v0			# in $s3, (R) put result

	fi_divop:
		move $v0, $s1			# return values
		move $v1, $s3
j end

end: 
	# restore the stack
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)
	lw $ra, 32($sp)
	lw $a0, 36($sp)
	lw $a1, 40($sp)
	lw $a2, 44($sp)
	addi $sp, $sp, 48
jr 	$ra
	
