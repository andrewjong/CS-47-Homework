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
	
	print_str(msg2)
	print_reg_int($s0)
	print_str(charCR)
	
	exit
	
