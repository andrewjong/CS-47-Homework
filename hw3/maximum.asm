.include "./cs47_macro.asm"

.data
msg1: .asciiz "Enter num 1: "
msg2: .asciiz "Enter num 2: "
msg3: .asciiz "Enter num 3: "
msg4: .asciiz "Max is "
charCR: .asciiz "\n"

.text
.globl main

.macro max2($reg1, $reg2)
blt $reg1, $reg2, else		# if reg2 < reg1, return reg1
	move $v0, $reg1
	j endif
else:
	move $v0, $reg2		# else reg1 < reg2, return reg2
endif:
.end_macro

main:	print_str(msg1)		# get the vector input size
	read_int($t0)		# store vector size into $t0
	
	print_str(msg2)		# read the other values
	read_int($t1)
	
	print_str(msg3)		# ''
	read_int($t2)
	
	max2($t0, $t1)		# call max 2 on $t0 and $t1
	move $t3, $v0		# store return
	max2($t2, $t3)		# call max 2 on $t3 and result of $t0 and $t1
	move $t3, $v0		# store return
	
	print_str(msg4)		# print the result
	print_reg_int($t3)
	exit
