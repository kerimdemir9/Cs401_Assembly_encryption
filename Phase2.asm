.data
newline: .asciiz "\n"
Sbox1: .byte 0x02, 0x0F, 0x0C, 0x01, 0x05, 0x06, 0x0A, 0x0D, 0x0E, 0x08, 0x03, 0x04, 0x00, 0x0B, 0x09, 0x07
Sbox2: .byte 0x0F, 0x04, 0x05, 0x08, 0x09, 0x07, 0x02, 0x01, 0x0A, 0x03, 0x00, 0x0E, 0x06, 0x0C, 0x0D, 0x0B
Sbox3: .byte 0x04, 0x0A, 0x01, 0x06, 0x08, 0x0F, 0x07, 0x0C, 0x03, 0x00, 0x0E, 0x0D, 0x05, 0x09, 0x0B, 0x02
Sbox4: .byte 0x07, 0x0C, 0x0E, 0x09, 0x02, 0x01, 0x05, 0x0F, 0x0B, 0x06, 0x0D, 0x00, 0x04, 0x08, 0x0A, 0x03
SboxCombined: .byte 0x02, 0x0F, 0x0C, 0x01, 0x05, 0x06, 0x0A, 0x0D, 0x0E, 0x08, 0x03, 0x04, 0x00, 0x0B, 0x09, 0x07, 0x0F, 0x04, 0x05, 0x08, 0x09, 0x07, 0x02, 0x01, 0x0A, 0x03, 0x00, 0x0E, 0x06, 0x0C, 0x0D, 0x0B, 0x04, 0x0A, 0x01, 0x06, 0x08, 0x0F, 0x07, 0x0C, 0x03, 0x00, 0x0E, 0x0D, 0x05, 0x09, 0x0B, 0x02, 0x07, 0x0C, 0x0E, 0x09, 0x02, 0x01, 0x05, 0x0F, 0x0B, 0x06, 0x0D, 0x00, 0x04, 0x08, 0x0A, 0x03 
Pbox: .byte 0x05, 0x07, 0x03, 0x04, 0x02, 0x06, 0x01, 0x00
numbers: .half 0x7601, 0x7af1, 0x8478, 0x2f20, 0xf0e7, 0x6d6c, 0xbe14, 0x5da5, 0xf9bd, 0x405e, 0x0240, 0xb0f8, 0x9a34, 0xb28e, 0x918d, 0xacfa, 0xcd15, 0xb629, 0x4d0e, 0xf226, 0x224b, 0xdbfc, 0x7377, 0x8a31, 0x8016, 0x9c90, 0x3bd9, 0x4eb2, 0x0b2a, 0xd2e1, 0xa15a, 0x04cb, 0xd020, 0xd747, 0x2ea0, 0x3288, 0xb7e2, 0x7ac7, 0x9587, 0x8b9d, 0x1533, 0xe08e, 0x50a8, 0x23a9, 0x6393, 0x82bb, 0x3c63, 0xcdfe, 0x496a, 0xa49c, 0x0e1b, 0xf2fd, 0x74b6, 0xb0eb, 0xb272, 0x5c68, 0xbb0f ,0x1906, 0xa34d, 0xedf5, 0x91bd, 0x7af1, 0x6dd9, 0x6a6a, 0x7ead, 0xc17d, 0x4fff, 0x727f, 0x5b0e, 0x826e, 0x960c, 0x17bc, 0x1670, 0xb767, 0x4974, 0x3499, 0x4a0f, 0x043d, 0x374e, 0xdcd2, 0xf0f7, 0x6f8b, 0xd846, 0xab2a, 0x33e8, 0x8158, 0x37f1, 0x1b53, 0x032e, 0xab31, 0x76f0, 0x2342, 0x69fa, 0xff7a, 0x00eb, 0x1bc1, 0xa512, 0xd709, 0x8844, 0x8ddc


test: .half 0x1111

.text
main:	
	la $s1, Pbox
	#la $s1, Sbox1
	#la $s2, Sbox2
	#la $s3, Sbox3
	#la $s4, Sbox4
	la $s0, SboxCombined
	la $s5, numbers
	la $s7, newline

	la $s1, test
	lhu $a0, 0($s1)
	jal F_x
	move $a0, $v0
	jal printInteger
	 
	
finish:		
	j exit


F_x:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	move $t7, $a0
	
	andi $s3, $t7, 15
	srl $t7, $t7, 4
	andi $s2, $t7, 15
	srl $t7, $t7, 4
	andi $s1, $t7, 15
	srl $t7, $t7, 4
	andi $s0, $t7, 15
	
	add $t5, $zero, $s0
	sll $t5, $t5, 4
	or $s0, $t5, $s1 # s0 = x0||x1
	
	move $a0, $s0
	jal P_x
	move $s0, $v0 # s0 = P(x0||x1)
	
	add $t6, $zero, $s2
	sll $t6, $t6, 4
	or $t6, $t6, $s3 # t6 = x2||x3
	sll $t6, $t6, 8
	or $s2, $t6, $s0 # s2 = x2||x3||P(x0||x1)
	
	move $a0, $s2
	jal S_x
	move $a0, $v0 # a0 = S(x2||x3||P(x0||x1))
	
	jal L_x
	# v0 = L(S(x2||x3||P(x0||x1)))
	# move $t6, $v0 # t6 = L(S(x2||x3||P(x0||x1)))
	
		
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 20	
	jr $ra



P_x: # $s0 contains P(x) mapping indexes
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	la $s0, Pbox
	move $t1, $a0 # store input number in $t1
	li $v0, 0 # holds result
	li $t0, 0 # index counter
	
	shiftLoop:
		beq $t0, 8, exitPx
		add $t2, $s0, $t0
		lb $t3, 0($t2) # mapping index is in $t3
		
		li $t4, 1 # used for masking
		li $t5, 7
		sub $t5, $t5, $t0 # $t5 index from inverse
		sllv $t4, $t4, $t5 # shift mask to correct position
		and $t6, $t1, $t4 # isolate the input numbers bit into $t6
		
		sle $t7, $t3, $t0 # mapping index left of the current index or right
		beq $t7, 1, shiftLeft # if the mapping index is in the left side
		j shiftRight
		
		shiftLeft:
			sub $t7, $t0, $t3 # extract shift amount
			sllv $t6, $t6, $t7 # shift left
			or $v0, $v0, $t6 # save bit into return register
			addi $t0, $t0, 1 # increment counter
			j shiftLoop
		shiftRight: 
			sub $t7, $t3, $t0 # extract shift amount
			srlv $t6, $t6, $t7 # shift right
			or $v0, $v0, $t6 # save bit into return register
			addi $t0, $t0, 1 # increment counter
			j shiftLoop
	exitPx:
		lw $s0, 0($sp)
		addi $sp, $sp, 4
		jr $ra
		
	


L_x:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	add $s0, $a0, $zero
	
	sll $t1, $s0, 6
	srl $t4, $s0, 10
	or $t1, $t1, $t4
	
	srl $t2, $s0, 6
	sll $t4, $s0, 10
	or $t2, $t2, $t4
	
	xor $t3, $s0, $t1
	xor $t1, $t3, $t2
	
	andi $t1, $t1, 65535
	
	add $v0, $zero, $t1
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	


S_x:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	la $s0, SboxCombined
	add $t7, $a0, $zero
	
	# seperation of x1-x2-x3-x4
	andi $t4, $t7, 15
	srl $t7, $t7, 4
	andi $t3, $t7, 15
	srl $t7, $t7, 4
	andi $t2, $t7, 15
	srl $t7, $t7, 4
	andi $t1, $t7, 15
	
	# mapping of S(xi) with multiple S-boxes	
#	add $t0, $s1, $t1
#	lb $t0, 0($t0)
#	sll $t0, $t0, 4
#	add $t1, $s2, $t2
#	lb $t2, 0($t1)
#	add $t0, $t0, $t2
#	sll $t0, $t0, 4	
#	add $t2, $s3, $t3
#	lb $t1, 0($t2)
#	add $t0, $t0, $t1
#	sll $t0, $t0, 4
#	add $t1, $s4, $t4
#	lb $t2, 0($t1)
#	add $t0, $t0, $t2	
#	add $v0, $zero, $t0
	
	# with single S-box
	add $t0, $s0, $t1
	lb $t1, 0($t0)
	sll $t1, $t1, 4
	add $t0, $s0, $t2
	addi $t0, $t0, 16
	lb $t2, 0($t0)
	add $t1, $t1, $t2
	sll $t1, $t1, 4
	add $t0, $s0, $t3
	addi $t0, $t0, 32
	lb $t3, 0($t0)
	add $t1, $t1, $t3
	sll $t1, $t1, 4
	add $t0, $s0, $t4
	addi $t0, $t0, 48
	lb $t4, 0($t0)
	add $t1, $t1, $t4	
	add $v0, $zero, $t1
	
	
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra


exit:
      	li $v0, 10
      	syscall
      
      
# load the integer to $a0 before calling
# sample (want to print $s0) => add $a0, $s0, $zero
printInteger:
	li $v0, 1
	syscall
		
	add $a0, $zero, $s7        
    	li $v0, 4
    	syscall
	jr $ra
		
