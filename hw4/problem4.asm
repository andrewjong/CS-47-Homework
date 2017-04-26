.include "./cs47_macro.asm"
.data

promptNum: 	.asciiz "Enter a number: "
promptMode: 	.asciiz "Choose extract (0) or set (1): "
promptPos: 	.asciiz "Enter a bit position: "
promptSet:	.asciiz "Enter a bit value "
dispBit:	.asciiz "The bit value is "
dispNum:	.asciiz "The number is now "

.macro extract_n($x, $pos)
srlv $v0, $x, $pos
and $v0, 1
.end_macro

.macro set_n($x, $pos)
li $t0, 1
sllv $v0, $t0, $pos
or $v0, $v0, $x
.end_macro

.text
.globl main

main:	print_str(promptMode)	# get extract or set mode in s0
	read_int($s0)

	print_str(promptNum)	# get a number in s1
	read_int($s1)
	
	print_str(promptPos)	# get bit position to manipulate in s2
	read_int($s2)
	
	bne $zero, $s0, set	# 0 for mode extract
	extract:
	extract_n($s1, $s2)
	move $s4, $v0		# put the extracted bit in s4
	print_str(dispBit)	# show what the extracted bit is
	print_reg_int($s4)
	j end
	
	set:
	set_n($s1, $s2)		# set the bit
	move $s4, $v0		# put new number in s4
	print_str(dispNum)	# show what the new number is
	print_reg_int($s4)
	
	end: exit
	
