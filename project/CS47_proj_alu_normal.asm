.include "./cs47_proj_macro.asm"
.text
.globl au_normal
# TBD: Complete your project procedures
# Needed skeleton is given
#####################################################################
# Implement au_normal
# Argument:
# 	$a0: First number
#	$a1: Second number
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_normal:
# Determine which operation to do
li $t0, '+'
beq $a2, $t0, add_op
li $t0, '-'
beq $a2, $t0, sub_op
li $t0, '*'
beq $a2, $t0, mul_op
li $t0, '/'
beq $a2, $t0, div_op
j end # skip everything if no opcode

add_op:
add $v0, $a0, $a1
j end

sub_op:
sub $v0, $a0, $a1
j end
 
mul_op:
mult $a0, $a1
mflo $v0
mfhi $v1
j end

div_op:
div $a0, $a1
mflo $v0
mfhi $v1
j end

end: 
jr	$ra
	
