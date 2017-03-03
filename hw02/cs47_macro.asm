#<------------------ MACRO DEFINITIONS ---------------------->#
        # Macro : print_str
        # Usage: print_str(<address of the string>)
        .macro print_str($arg)
	li	$v0, 4     # System call code for print_str  
	la	$a0, $arg   # Address of the string to print
	syscall            # Print the string        
	.end_macro
	
	# Macro : print_int
        # Usage: print_int(<val>)
        .macro print_int($arg)
	li 	$v0, 1     # System call code for print_int
	li	$a0, $arg  # Integer to print
	syscall            # Print the integer
	.end_macro
	
	#Macro: read_int
	.macro read_int($reg)
	li $v0, 5 	   	# System call to read integer input
	syscall			# Get the input from the user
	move $reg, $v0		# put number V0 in said register
	.end_macro 
	
	# Macro : print_reg_int
        # Usage: print_reg_int($reg)
        .macro print_reg_int($reg)
	li 	$v0, 1     		# System call code for print_int
	add	$a0, $reg, $zero  	# Put $reg in $a0
	syscall            		# Print the integer
	.end_macro
	
	# Macro: swap_hi_lo
	# Usage: swap_hi_lo($temp1, $temp2)
	.macro swap_hi_lo($temp1, $temp2)
	mflo $temp1	# move lo into $temp1
	mfhi $temp2	# move hi into $temp2
	mthi $temp1	# move temp 1 into hi
	mtlo $temp2	# move temp 2 into lo
	.end_macro
	
	# Macro: print_hi_lo
	# Usage: pring_hi_lo($strHi, $strEqual, $strComma, $strLo)
	.macro print_hi_lo($strHi, $strEqual, $strComma, $strLo)
	print_str($strHi)	# print hi string
	print_str($strEqual)	# print '='
	mfhi $t0		# move hi value into $t0
	print_reg_int($t0)	# print the hi value in $t0
	
	print_str($strComma)	# print ','
	
	print_str($strLo)	# print hi string
	print_str($strEqual)	# print '='
	mflo $t0		# move hi value into $t0
	print_reg_int($t0)	# print the hi value in $t0
	
	
	.end_macro
	
	# Macro : exit
        # Usage: exit
        .macro exit
	li 	$v0, 10 
	syscall
	.end_macro
	
