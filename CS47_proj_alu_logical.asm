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
#	$a2: operation code ('+':add, '-':sub, '*':mul, '/':div)
# Return:
#	$v0: ($a0+$a1) | ($a0-$a1) | ($a0*$a1):LO | ($a0 / $a1)
# 	$v1: ($a0 * $a1):HI | ($a0 % $a1)
# Notes:
#####################################################################
au_logical:
# TBD: Complete it
	addi $sp, $sp, -56
	sw $ra, 56($sp)
	sw $fp, 52($sp)
	sw $a0, 48($sp)
	sw $a1, 44($sp)
	sw $a2, 40($sp)	
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 56

	beq $a2, '+', add_logical
	beq $a2, '-', sub_logical
	beq $a2, '*', mul_logical
	beq $a2, '/', div_logical
	
add_logical:
	addi $sp, $sp, -56
	sw $ra, 56($sp)
	sw $fp, 52($sp)
	sw $a0, 48($sp)
	sw $a1, 44($sp)
	sw $a2, 40($sp)	
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 56
	
	li $a2, 0x00000000 # Addition mode
	jal add_sub_logical
	
	lw $ra, 56($sp)
	lw $fp, 52($sp)
	lw $a0, 48($sp)
	lw $a1, 44($sp)
	lw $a2, 40($sp)	
	lw $s0, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 56
	jr $ra		
	
sub_logical:
	addi $sp, $sp, -56
	sw $ra, 56($sp)
	sw $fp, 52($sp)
	sw $a0, 48($sp)
	sw $a1, 44($sp)
	sw $a2, 40($sp)	
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 56

	# if mode = subtraction
	li $a2, 0xFFFFFFFF # carry
	jal add_sub_logical	
	
	lw $ra, 56($sp)
	lw $fp, 52($sp)
	lw $a0, 48($sp)
	lw $a1, 44($sp)
	lw $a2, 40($sp)	
	lw $s0, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 56
	jr $ra	
	
mul_logical:
	jal mul_signed
	j exit	
	
div_logical:
	jal div_signed	
	j exit
	
add_sub_logical:
	addi $sp, $sp, -52
	sw $ra, 52($sp)
	sw $fp, 48($sp)
	sw $a0, 44($sp)
	sw $a1, 40($sp)
	sw $a2, 36($sp)	
	sw $s0, 32($sp)
	sw $s1, 28($sp)
	sw $s2, 24($sp)
	sw $s3, 20($sp)
	sw $s4, 16($sp)
	sw $s5, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 52
	
	li $t0, 0 # i = 0
	li $v0, 0 # sum = 0
	extract_nth_bit($s7, $a2, $zero) # get LSB of $a2 = mode
	bne $s7, 1, iterate # if != 1, iterate in addition mode
	not $a1, $a1 # else negate and then iterate

iterate:
	# if mode = addition
	extract_nth_bit($s0, $a0, $t0) # a0[i] extract bit i from $a0
	extract_nth_bit($s1, $a1, $t0) # a1[i] extract bit i from $a1
	xor $s2, $s0, $s1 # A XOR B = $a0[i] XOR $a1[i]
	xor $s3, $s7, $s2 # $s3 = Y = C XOR (A XOR B)
	
	and $s5, $s7, $s2 # C AND (A XOR B)
	and $s4, $s0, $s1 # A AND B = A AND B
	or $s7, $s5, $s4 # $s7 = CO = C AND (A XOR B) OR (A AND B)
	
	insert_to_nth_bit($t5,$t0,$s3,$t4) # S[i] = Y --> sum = inserting bits at i 
	add $t0, $t0,1 #i++
	bge $t0, 32, add_sub_end
	j iterate

add_sub_end:	
	move $v0, $t5 # sum
	move $v1, $s7 # carryout bit
		
	lw $ra, 52($sp)
	lw $fp, 48($sp)
	lw $a0, 44($sp)
	lw $a1, 40($sp)
	lw $a2, 36($sp)	
	lw $s0, 32($sp)
	lw $s1, 28($sp)
	lw $s2, 24($sp)
	lw $s3, 20($sp)
	lw $s4, 16($sp)
	lw $s5, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 52
	jr $ra		
	
mul_unsigned:
	addi $sp, $sp, -56
	sw $ra, 56($sp)
	sw $fp, 52($sp)
	sw $a0, 48($sp)
	sw $a1, 44($sp)
	sw $a2, 40($sp)	
	sw $s0, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 56

	li $s7, 0 # i = 0
	li $s0, 0 # Hi register
	move $s1, $a0 # M = multiplicand $a0
	move $s2, $a1 # L = multiplier $a1
	j mul_unsignedIterate
	
mul_unsignedIterate:		
	extract_nth_bit($a0, $s2,$zero) #extract LSB of lo register
	jal bit_replicator
	move $s4, $v0 # R = $s4
	and $s5, $s1,$s4 # X = M & R
	move $a0, $s0	
	move $a1, $s5
	jal add_logical # H = H + X
	move $s0, $v0 # H = $s0
	srl $s2,$s2, 1 # L = L >> 1
	extract_nth_bit($s6,$s0,$zero) # extract LSB of H
	li $t2, 31
	insert_to_nth_bit($s2,$t2,$s6,$t3) # L[31] = H[0]
	srl $s0, $s0, 1 #H = H >> 1
	add $s7, $s7, 1 
	blt $s7, 32, mul_unsignedIterate
	j mul_UnsignedIterate_end

mul_UnsignedIterate_end:
	move $v0,$s2
	move $v1, $s0	
	
	lw $ra, 56($sp)
	lw $fp, 52($sp)
	lw $a0, 48($sp)
	lw $a1, 44($sp)
	lw $a2, 40($sp)	
	lw $s0, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 56
	jr $ra		

mul_signed:
	addi $sp, $sp, -48
	sw $ra, 48($sp)
	sw $fp, 44($sp)
	sw $a0, 40($sp)
	sw $a1, 36($sp)
	sw $a2, 32($sp)	
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	addi $fp, $sp 48
	
	move $s1, $a0 # $s1 = $a0
	move $s2, $a1 # $s2 = $a1
	jal twos_complement_if_neg
	move $s3,$v0 # $s3 = N1 twos complement 
	move $a0, $s2 
	jal twos_complement_if_neg # N2 twos complement
	move $a1, $v0 # $a1 = N2
	move $a0, $s3 # $a0 = N1
	jal mul_unsigned # multiplication w/ 2's complement $a0 and $a1
	move $a0, $v0 # Rlo
	move $a1,$v1 # Rhi
	
	li $t1, 31 # MSB index
	extract_nth_bit($s3, $s1, $t1) # extract a0[31] 
	extract_nth_bit($s4, $s2, $t1) # extract a1[31]
	xor $s5, $s3, $s4 # S = a0[31] XOR a1[31]
	bne $s5,1, mul_signed_end
	jal twos_complement_64bit	

mul_signed_end:																																																																														
	lw $ra, 48($sp)
	lw $fp, 44($sp)
	lw $a0, 40($sp)
	lw $a1, 36($sp)
	lw $a2, 32($sp)	
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s5, 8($sp)
	addi $sp, $sp 48
	jr $ra
			
twos_complement:
	addi $sp, $sp, -20
	sw $ra, 20($sp)
	sw $fp, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	addi $fp, $sp 20

	not $a0, $a0
	li $a1, 1
	jal add_logical # add ~$a0 + 1
	
	lw $ra, 20($sp)
	lw $fp, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	addi $sp, $sp 20
	jr $ra	
	
twos_complement_if_neg:
	addi $sp, $sp, -16
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp 16
	
	move $v0, $a0 # else return $a0 in $v0
	bge $a0, $zero, twos_comp_neg_end
	jal twos_complement
	# if $a0 < 0, twos complement it

twos_comp_neg_end:		
	lw $ra, 16($sp)
	lw $fp, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp 16
	jr $ra	
	
twos_complement_64bit:
	addi $sp, $sp, -28
	sw $ra, 28($sp)
	sw $fp, 24($sp)
	sw $a0, 20($sp)
	sw $a1, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	addi $fp, $sp 28

	not $a0, $a0
	not $a1, $a1
	move $s1, $a1 # save inverted $a1 in $s1
	li $a1, 1
	jal add_logical # add ~$a0 + 1
	move $s2, $v0 # $s2 = ~$a0 + 1
	move $a1, $s1 # get ~$a1 back into $a1
	move $a0, $v1 # $a0 = carryout bit
	jal add_logical # add ~$a1 + carryoutbit 
	move $v1, $v0 
	move $v0,$s2
	
	lw $ra, 28($sp)
	lw $fp, 24($sp)
	lw $a0, 20($sp)
	lw $a1, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	addi $sp, $sp 28
	jr $ra
	
bit_replicator:
	addi $sp, $sp, -16
	sw $ra, 16($sp)
	sw $fp, 12($sp)
	sw $a0, 8($sp)
	addi $fp, $sp 16

	beq $a0, $zero, replicate_zero # if $a0 = 0, replicate zero
	li $v0, 0xFFFFFFFF # else replicate one
	j replicate_end
	
replicate_zero:
	li $v0, 0x00000000
	#j replicate_end	
	
replicate_end:	
	lw $ra, 16($sp)
	lw $fp, 12($sp)
	lw $a0, 8($sp)
	addi $sp, $sp 16
	jr $ra	
	
# a0 dividend, $a1 divisor, $v0 quotient, $v1 remainder	
div_unsigned:
	addi $sp, $sp, -44
	sw $ra, 44($sp)
	sw $fp, 40($sp)
	sw $a0, 36($sp)
	sw $a1, 32($sp)
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 44

	li $s7, 0 # i = 0
	move $s0, $a0 # Q dividend 
	move $s1, $a1 # D 
	li $s2, 0 # R = 0
	
div_unsignedIterate:	
	sll $s2, $s2, 1 # R = R << 1
	li $t1, 31
	extract_nth_bit($s3,$s0,$t1) # extract MSB Q[31] 
	insert_to_nth_bit($s2,$zero,$s3,$t2) # Insert at LSB R[0] = Q[31]
	sll $s0, $s0, 1 # Q = Q << 1
	move $s4, $a0 # save Q $a0 in $s4
	move $a0, $s2 # move R into $a0, D is still the same ($a1)
	jal sub_logical # S = R - D
	move $s2, $a0 # $s2 = R
	move $s3 $v0 # $s3 = S = R - D
	move $a0, $s4 # move original $a0 back into $a0
	blt $s3,$zero increment_index
		
	move $s2, $s3 # R = S
	li $t3, 1
	insert_to_nth_bit($s0,$zero, $t3, $t2) # Q[0] = 1 
	#j increment_index
	
increment_index:
	add $s7, $s7, 1 # i++	
	bge $s7, 32, div_unsigned_end
	j div_unsignedIterate

div_unsigned_end:
	move $v0, $s0
	move $v1, $s2
		
	lw $ra, 44($sp)
	lw $fp, 40($sp)
	lw $a0, 36($sp)
	lw $a1, 32($sp)
	lw $s0, 28($sp)
	lw $s1, 24($sp)
	lw $s2, 20($sp)
	lw $s3, 16($sp)
	lw $s4, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 44
	jr $ra			
	
#a0 dividend, $a1 divisor, #v0 quotient, $v1 remainder	
div_signed:
	addi $sp, $sp, -48
	sw $ra, 48($sp)
	sw $fp, 44($sp)
	sw $a0, 40($sp)
	sw $a1, 36($sp)
	sw $s1, 32($sp)
	sw $s2, 28($sp)
	sw $s3, 24($sp)
	sw $s4, 20($sp)
	sw $s5, 16($sp)
	sw $s6, 12($sp)
	sw $s7, 8($sp)
	addi $fp, $sp 48
	
	move $s1, $a0 # $s1 = $a0
	move $s2, $a1 # $s2 = $a1
	jal twos_complement_if_neg
	move $s3,$v0 # $s3 = N1 twos complement 
	move $a0, $s2 
	jal twos_complement_if_neg # N2 twos complement
	move $a1, $v0 # $a1 = N2
	move $a0, $s3 # $a0 = N1
	jal div_unsigned
	
	move $s3, $v0 # Q
	move $s4, $v1 # R
	
	# determine sign of Q
	li $t1, 31 # MSB index
	extract_nth_bit($s5, $s1, $t1) # extract a0[31] 
	extract_nth_bit($s6, $s2, $t1) # extract a1[31]
	xor $s7, $s5, $s6 # S = a0[31] XOR a1[31]
	bne $s7, 1, determine_r
	move $a0, $s3 # $a0 = Q
	jal twos_complement
	move $s3, $v0 #  Q = Q's twos complement
	
determine_r:	
	# determine sign of R
	li $t1, 31 # MSB index
	extract_nth_bit($s5, $s1, $t1) # extract a0[31] 
	move $s7, $s5 # S = a0[31]
	bne $s7, 1, div_signed_end
	move $a0, $s4 # R = $a0
	jal twos_complement
	move $s4, $v0

div_signed_end:	
	move $v0, $s3 # Q
	move $v1, $s4 # R
		
	lw $ra, 48($sp)
	lw $fp, 44($sp)
	lw $a0, 40($sp)
	lw $a1, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 48
	jr $ra		
																									
exit: 
	lw $ra, 56($sp)
	lw $fp, 52($sp)
	lw $a0, 48($sp)
	lw $a1, 44($sp)
	lw $a2, 40($sp)	
	lw $s0, 36($sp)
	lw $s1, 32($sp)
	lw $s2, 28($sp)
	lw $s3, 24($sp)
	lw $s4, 20($sp)
	lw $s5, 16($sp)
	lw $s6, 12($sp)
	lw $s7, 8($sp)
	addi $sp, $sp 56
	jr $ra	
