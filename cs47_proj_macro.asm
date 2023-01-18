# Add you macro definition here - do not touch cs47_common_macro.asm"
#<------------------ MACRO DEFINITIONS ---------------------->#

.macro extract_nth_bit($regD, $regS, $regT)
li 	$t3, 0x1
sllv  	$t3,$t3,$regT # Mask shifted by n # of bits
and 	$t4, $regS, $t3 # and between source and mask		
srlv 	$regD, $t4, $regT # $regD will be either 0 or 1 
.end_macro 

.macro insert_to_nth_bit($regD, $regS, $regT, $maskReg)
li $maskReg, 0x1
sllv $t3, $maskReg, $regS # left shift mask by n bits
not $t4, $t3 # $t4 = inverted mask
and $t5, $t4, $regD # $t5 = and between !mask & source
sllv $t6, $regT, $regS # shift b by n bits
or $regD, $t5, $t6 # $regD = or between result and shifted b
.end_macro

