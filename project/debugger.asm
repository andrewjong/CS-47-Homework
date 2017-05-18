.include "./cs47_common_macro.asm"
.include "./cs47_proj_macro.asm"

.data
askForNum1: .asciiz "Please provide first number: "
askForNum2: .asciiz "Please provide second number: "
askForOPCode: .asciiz "Please provide OP code (as an int in ascii): "

provideOutput: .asciiz "Here is the output ($v0, $v1): "

charComma: .asciiz ","
charSpace: .asciiz " "
charCR: .asciiz "\n"

.text
.globl main2

main2:
	print_str(askForNum1)
	read_int($s0)
	print_str(charCR)
	
	print_str(askForNum2)
	read_int($s1)
	print_str(charCR)
	
	print_str(askForOPCode)
	read_int($s2)
	print_str(charCR)
	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	jal au_logical
	#twos_comp_64($a0, $a1)
	#abs_val($a0)
	#twos_comp($a0)
	#jal twos_complement
	# jal absolute_value
	# set_n_with($a0, $a1, $a2)
	move $s0, $v0
	move $s2, $v1
	
	print_str(provideOutput)
	print_reg_int($s0)
	print_str(charComma)
	print_str(charSpace)
	print_reg_int($s1)
	
	exit
