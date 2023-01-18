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
# TBD: Complete it
	# looks at operation code, depending on
	# sign compute values and return to the caller
	beq $a2, '+', addition
	beq $a2, '-', subtraction
	beq $a2, '*', multiplication
	beq $a2, '/', division
	
addition:
	add $v0, $a0, $a1
	jr 	$ra
	
subtraction:
	sub $v0, $a0, $a1
	jr 	$ra
	
multiplication:
	mul $v0, $a0, $a1
	mflo $v0
	mfhi $v1
	jr	$ra
	
division:
	div $a0, $a1 
	mflo $v0 #quotient
	mfhi $v1 # remainder
	jr 	$ra
