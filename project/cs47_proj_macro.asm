# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#
# extracts from register at position
.macro extract_n($x, $pos)
    srlv $v0, $x, $pos
    and $v0, 1
.end_macro

# sets register at position to 1 
.macro set_n($x, $pos)
    li $t0, 1
    sllv $v0, $t0, $pos
    or $v0, $v0, $x		
.end_macro

# sets register at position with a 0 or 1
.macro set_n_with($source, $pos, $value)
    bne $value, $zero, set_one
    # case 0
    set_n($value, $pos)		# stick a 1 in the middle of zeros (e.g. 0000100)
    not $v0, $v0		# invert it (e.g. 11110111)
    and $v0, $v0, $source	# AND it with the source to set the position to 0
    j end_set_n_with
    # case 1
    set_one:
    set_n($source, $pos)
    end_set_n_with:
.end_macro

# replicates a bit across the entire word, 0 or 1
.macro bit_replicator($arg)
	bnez $arg, replicate_1
		move $v0, $zero		# set to zero
		j fi_bit_replicator	# and return
	replicate_1:
		li $v0, -1 		# -1 is all 1s in binary 2's complement
	fi_bit_replicator:
.end_macro

# get sign (+/-) of the result of multiplying or dividing two numbers
.macro result_sign($n1, $n2)
    addi $sp, $sp, -8			# store on the stack
    sw $a0, ($sp)
    sw $a1, 4($sp)

	li $t3, 31			# bit to extract for sign
	extract_n($n1, $t3)		# extract for number 1
	move $t4, $v0			# store in $t4
	extract_n($n2, $t3) 		# extract for number 2
	move $t5, $v0
	xor $v0, $t4, $t5		# in $s0, xor to find out sign
    
    lw $a0, ($sp)
    lw $a1, 4($sp)
    addi $sp, $sp, 8
.end_macro

# performs 2s complement to get the negative of a number
.macro twos_comp($num)
    not $a0, $num	# 1's complement
    li $a1, 1
    li $a2, '+'
    jal au_logical	# add 1 as 2's complement
.end_macro

# performs 2s complement on a 64 bit number
.macro twos_comp_64($low, $high)
    twos_comp($low)
    move $t0, $v1          		# get the carry value from twos
    not $v1, $high
    beq $t0, $zero, fi_twos_comp_64	# if carry out <= 0, skip carrying to the high order bit 
	addi $v1, $v1, 1		# otherwise we carry 1 into the high order
    fi_twos_comp_64:
.end_macro

# returns the absolute value of a number
.macro abs_val($num)
    addi $sp, $sp, -8		# store on the stack
    sw $a0, ($sp)
    sw $a1, 4($sp)

    move $v0, $num
    bgez $num, fi_abs_val	# don't negate if greater than zero
    twos_comp($num)		# else negate
    fi_abs_val:

    lw $a0, ($sp)		# restore form the stack
    lw $a1, 4($sp)
    addi $sp, $sp, 8
.end_macro
