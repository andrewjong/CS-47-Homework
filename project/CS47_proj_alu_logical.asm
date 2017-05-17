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
	beq $a2, $t0, addorsub
	li $t0, '-'
	beq $a2, $t0, addorsub
	li $t0, '*'
	beq $a2, $t0, mulop
	li $t0, '/'
	beq $a2, $t0, divop
	j end 							# skip everything if no opcode

addorsub:
	move $s0, $zero						# in $s0, initialize the counter (i)  with 0 
	move $s1, $zero						# in $s1, initialize the sum (s) as 0 
	move $s2, $zero						# in $s2, establish the carry value (c) 
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

	set_n_with($s1, $s0, $s5)				# 	  store (y) in sum at appropriate location
	move $s1, $v0
	addi $s0, $s0, 1					# 	  increment counter (i)
	li $t0, 32						#	  the size of MIPS ints
	bne $s0, $t0, addop					#	  repeat if i!=32
	move $v1, $s2
j end

mulop:
	li $t0, '.' 	# THIS IS WHERE MULOP STARTS

	li $t3, 31				# bit to extract for sign
	extract_n($a0, $t3)		# extract for number 1
	move $t4, $v0			# store in $t4
	extract_n($a1, $t3) 	# extract for number 2
	move $t5, $v0
	xor $s0, $t4, $t5		# in $s0, xor to find out sign

	abs_val($a0)			# find the absolute value of N1, already in a0
	move $s1, $v0

	abs_val($a1)

	move $a0, $s1			# put |N1| in $a0
	move $a1, $v0			# put |N2| in $a1

	jal mul_unsigned		# do an unsigned multiplication

	beq $s0, $zero, fi_mulop # if positive number, jump to end
	twos_comp_64($v0, $v1)

	fi_mulop:

j end

# unsigned multiplication. $a0 multiplicand. $a1 multiplier. $v0 Lo. $v1 Hi
mul_unsigned:
	li $t0, 'x'				# THIS IS WHERE MULTIPLICATION UNSIGNED STARTS
	addi $sp, $sp, -28
	sw $s0, ($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $ra, 24($sp)

	move $s0, $zero				# in $s0, (I) start index i at 0
	move $s1, $zero				# in $s1, (H) variable thing
	move $s3, $a0				# in $s3, (M) put the multiplicand
	move $s4, $a1				# in $s4, (L) put the multiplier

	mul_unsigned_loop:
		extract_n($s4, $zero)		# extract the 0th bit from L and replicate it
		bit_replicator($v0) 		# replicate it. R = {32{L[0]}} 

		and $s5, $s3, $v0			# in $s5, (X) = M & R

		add $s1, $s1, $s5			# H = H + X

		srl $s4, $s4, 1			# L = L >> 1

		extract_n($s1, $zero)		# H[0] 
		li $t0, 31					# the index for setting at L
		set_n_with($s4, $t0, $v0)	# L[31] = H[0]
		move $s4, $v0				# overwrite L with new value

		srl $s1, $s1, 1			# H = H >> 1

		addi $s0, $s0, 1 			# I = I + 1

		li $t0, 32					# set limit to 32
		bne $s0, $t0, mul_unsigned_loop
		move $v1, $s1
		move $v0, $s4
	
	lw $s0, ($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $ra, 24($sp)
	addi $sp, $sp, 28
jr $ra # end


mul_signed:



divop:
#	move $s0, $a0 # Dividend (Q)
#	move $s1, $a1 # Divisor (D)
#	
#	# Take two's complement of arguments if negative
#	bgt $a0, 0, skip_dividend_complement
#	beq $a0, 0, skip_dividend_complement
#	twos_comp($a0)
#	move $s0, $v0
#	skip_dividend_complement:
#	
#	bgt $a1, 0, skip_divisor_complement
#	beq $a1, 0, skip_divisor_complement
#	twos_comp($a1)
#	move $s1, $v0
#	skip_divisor_complement:
#	
#	unsigned_division:
#		move $s0, $s0 # Dividend (Q)
#		move $s1, $s1 # Divisor (D)
#	
#		move $s2, $zero # Index (I)
#	
#		move $s3, $zero # Remainder (R)
#	
#		move $s4, $zero # S
#	
#		
#		div_loop:
#		sll $s3, $s3, 1 # R = R << 1
#		
#		### R[0] = Q[31]
#		srl $s7, $s0, 31
#		set_n_with($s3, $zero, $s7)
#		move $s3, $v0
#		###
#		
#		sll $s0, $s0, 1 # Q = Q << 1
#		
#		### S = R - D
#		addi	$sp, $sp, -20
#		sw	$ra, 20($sp)
#		sw	$a0, 16($sp)
#		sw	$a1, 12($sp)
#		sw	$a2, 8($sp)
#		
#		move $a0, $s3
#		move $a1, $s1
#		li $a2, '-'
#		jal au_logical
#		
#		move $s4, $v0
#		
#		lw	$ra, 20($sp)
#		lw	$a0, 16($sp)
#		lw	$a1, 12($sp)
#		lw	$a2, 8($sp)
#		addi $sp, $sp, 20
#		###
#		
#		blt $s4, 0, s_less_than_zero
#		
#		move $s3, $s4 # R = S
#		or $s0, $s0, 1 # Q[0] = 1
#		s_less_than_zero:
#		
#		addi $s2, $s2, 1 # Allowed to increment index like this according to Patra's PDF on class modules
#		bne $s2, 32, div_loop # Keep going until index = 32
#		
#	### If quotient is negative, take two's complement of the unsigned_divisor quotient
#	li $s2, 31
#	extract_n($a0, $s2)
#	move $s4, $v0
#	extract_n($a1, $s2)
#	xor $s4, $s4, $v0
#	
#	beq $s4, 0, skip_quotient_complement
#	twos_comp($s0)
#	move $s0, $v0
#	skip_quotient_complement:
#	###
#	
#	### If dividend is negative, make remainder negative
#	li $s2, 31
#	extract_n($a0, $s2)
#	move $s4, $v0
#	
#	beq $s4, 0, skip_remainder_complement
#	twos_comp($s3)
#	move $s3, $v0
#	skip_remainder_complement:
#	###
#	
#	move $v0, $s0
#	move $v1, $s3
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
jr	$ra
	
