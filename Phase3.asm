.data
newline: .asciiz "\n"
SboxCombined: .byte 0x02, 0x0F, 0x0C, 0x01, 0x05, 0x06, 0x0A, 0x0D, 0x0E, 0x08, 0x03, 0x04, 0x00, 0x0B, 0x09, 0x07, 0x0F, 0x04, 0x05, 0x08, 0x09, 0x07, 0x02, 0x01, 0x0A, 0x03, 0x00, 0x0E, 0x06, 0x0C, 0x0D, 0x0B, 0x04, 0x0A, 0x01, 0x06, 0x08, 0x0F, 0x07, 0x0C, 0x03, 0x00, 0x0E, 0x0D, 0x05, 0x09, 0x0B, 0x02, 0x07, 0x0C, 0x0E, 0x09, 0x02, 0x01, 0x05, 0x0F, 0x0B, 0x06, 0x0D, 0x00, 0x04, 0x08, 0x0A, 0x03 
Pbox: .byte 0x05, 0x07, 0x03, 0x04, 0x02, 0x06, 0x01, 0x00

keyVector: .word 0x2301, 0x6745, 0xAB89, 0xEFCD, 0xDCFE, 0x98BA, 0x5476, 0x1032
initialVector: .word 0x3412, 0x7856, 0xBC9A, 0xF0DE
stateVector: .word 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000, 0x00000000
plainText: .word 0x1100, 0x3322, 0x5544, 0x7766, 0x9988, 0xBBAA, 0xDDCC, 0xFFEE


.text
main:	
	
	jal init_func
	
	la $s0, plainText
	
	lw $a0, 0($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger

	lw $a0, 4($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
	
	lw $a0, 8($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
	
	lw $a0, 12($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
	
	lw $a0, 16($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
	
	lw $a0, 20($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
	
	lw $a0, 24($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
	
	lw $a0, 28($s0)
	jal encrypt
	move $a0, $v0
	jal printInteger
		
finish:		
	j exit
	


encrypt:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp) # t0
	sw $s4, 20($sp) # t1
	sw $s5, 24($sp) # t2
	sw $s6, 28($sp) # plain-text
	sw $s7, 32($sp)
	
	add $s6, $a0, $zero # holds the plaintext

	la $s1, keyVector
	la $s2, stateVector
	
	lw $t0, 4($s1)
	lw $t1, 4($s2)
	xor $a0, $t0, $t1
	jal L_x
	add $s3, $v0, $zero
	
	lw $t0, 0($s1)
	lw $t1, 0($s2)
	xor $a0, $t0, $t1
	
	add $t2, $t1, $s6
	andi $s5, $t2, 65535 
	
	jal L_x
	add $s4, $v0, $zero
	
	add $a0, $s5, $zero
	add $a1, $s4, $zero
	add $a2, $s3, $zero
	
	jal W_x
	add $s3, $v0, $zero # s3 = t0
	
	lw $t0, 12($s1)
	lw $t1, 12($s2)
	xor $a0, $t0, $t1
	jal L_x
	add $s7, $v0, $zero
	
	lw $t0, 8($s1)
	lw $t1, 8($s2)
	xor $a0, $t0, $t1	
	jal L_x
	add $s4, $v0, $zero
	
	lw $t0, 4($s2)
	add $s5, $s3, $t0
	andi $t1, $s5, 65535 
	
	
	add $a0, $t1, $zero
	add $a1, $s4, $zero
	add $a2, $s7, $zero
	
	jal W_x
	add $s4, $v0, $zero # s4 = t1
	
	lw $t0, 20($s1)
	lw $t1, 20($s2)
	xor $a0, $t0, $t1
	jal L_x
	add $s7, $v0, $zero
	
	lw $t0, 16($s1)
	lw $t1, 16($s2)
	xor $a0, $t0, $t1	
	jal L_x
	add $s5, $v0, $zero
	
	lw $t0, 8($s2)
	add $t1, $t0, $s4
	andi $t2, $t1, 65535 
	
	add $a0, $t2, $zero
	add $a1, $s5, $zero
	add $a2, $s7, $zero
	
	jal W_x
	add $s5, $v0, $zero # s5 = t2
	
	
	lw $t0, 28($s1)
	lw $t1, 28($s2)
	xor $a0, $t0, $t1
	jal L_x
	add $s7, $v0, $zero
	
	lw $t0, 24($s1)
	lw $t1, 24($s2)
	xor $a0, $t0, $t1	
	jal L_x
	add $t5, $v0, $zero
	
	lw $t0, 12($s2)
	add $t1, $t0, $s5
	andi $t2, $t1, 65535 
	
	add $a0, $t2, $zero
	add $a1, $t5, $zero
	add $a2, $s7, $zero
	
	jal W_x
	add $s7, $v0, $zero
	
	# this part may be problematic
	lw $t0, 0($s2)
	add $t1, $t0, $s7
	andi $s7, $t1, 65535 # s7 = C
	# this part may be problematic
	
	lw $t1, 0($s2)
	add $t2, $t1, $s5
	and $t0, $t2, 65535 # T0 = t0
	
	lw $t1, 4($s2)
	add $t3, $t1, $s3
	and $t1, $t3, 65535 # T1 = t1
	
	lw $t3, 8($s2)
	add $t4, $t3, $s4
	and $t2, $t4, 65535 # T2 = t2
	
	lw $t3, 12($s2)
	lw $t4, 0($s2)
	add $t5, $t3, $t4
	add $t3, $t5, $s5
	add $t5, $t3, $s3
	and $t3, $t5, 65535 # T3 = t3

	lw $t5, 16($s2)
	xor $t4, $t5, $t3 # T4 = t4
	
	lw $t6, 4($s2)
	add $t7, $t6, $s3
	and $t6, $t7, 65535	
	lw $t7, 20($s2)
	xor $t5, $t7, $t6 # T5 = t5
	
	lw $t6, 8($s2)
	add $t7, $t6, $s4
	and $t6, $t7, 65535
	lw $t7, 24($s2)
	xor $t6, $t7, $t6 # T6 = t6
	
	lw $t7, 0($s2)
	add $s6, $t7, $s5
	and $t7, $s6, 65535
	lw $s6, 28($s2)
	xor $t7, $s6, $t7 # T7 = t7
	
	sw $t0, 0($s2)
	sw $t1, 4($s2)
	sw $t2, 8($s2)
	sw $t3, 12($s2)
	sw $t4, 16($s2)
	sw $t5, 20($s2)
	sw $t6, 24($s2)
	sw $t7, 28($s2)
	
	add $v0, $s7, $zero
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	lw $s7, 32($sp)
	addi $sp, $sp, 36
	jr $ra
	


init_func:
	addi $sp, $sp, -36
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	sw $s7, 32($sp)
	
	la $s0, initialVector
	la $s1, keyVector
	la $s2, stateVector
	# Ri = IVi mod 4 for i:0->7
	lw $t0, 0($s0)
	sw $t0, 0($s2)
	lw $t0, 4($s0)
	sw $t0, 4($s2)
	lw $t0, 8($s0)
	sw $t0, 8($s2)	
	lw $t0, 12($s0)
	sw $t0, 12($s2)
	lw $t0, 0($s0)
	sw $t0, 16($s2)	
	lw $t0, 4($s0)
	sw $t0, 20($s2)	
	lw $t0, 8($s0)
	sw $t0, 24($s2)
	lw $t0, 12($s0)
	sw $t0, 28($s2)
	
	add $s3, $zero, $zero
	setupLoop:
		beq $s3, 4, exitInitFunc
		
		lw $t5, 0($s2)
		add $t6, $t5, $s3
		andi $t6, $t6, 65535
		move $a0, $t6
		lw $a1, 4($s1)
		lw $a2, 12($s1)
		jal W_x
		move $s4, $v0
		
		lw $t5, 4($s2)
		add $t6, $t5, $s4
		andi $t6, $t6, 65535
		move $a0, $t6
		lw $a1, 20($s1)
		lw $a2, 28($s1)
		jal W_x
		move $s5, $v0
		
		lw $t5, 8($s2)
		add $t6, $t5, $s5
		andi $t6, $t6, 65535
		move $a0, $t6
		lw $a1, 0($s1)
		lw $a2, 8($s1)
		jal W_x
		move $s6, $v0
		
		
		lw $t5, 12($s2)
		add $t6, $t5, $s6
		andi $t6, $t6, 65535
		move $a0, $t6
		lw $a1, 16($s1)
		lw $a2, 24($s1)
		jal W_x
		move $s7, $v0
		# t0-1-2-3 are calculated 
		
		lw $t5, 0($s2)
		add $t6, $t5, $s7
		andi $t6, $t6, 65535
		sll $t5, $t6, 7
		srl $t7, $t6, 9
		or $t6, $t5, $t7
		andi $t6, $t6, 65535
		sw $t6, 0($s2)
		
		lw $t5, 4($s2)
		add $t6, $t5, $s4
		andi $t6, $t6, 65535
		srl $t5, $t6, 4
		sll $t7, $t6, 12
		or $t6, $t5, $t7
		andi $t6, $t6, 65535
		sw $t6, 4($s2)
		
		lw $t5, 8($s2)
		add $t6, $t5, $s5
		andi $t6, $t6, 65535
		sll $t5, $t6, 2
		srl $t7, $t6, 14
		or $t6, $t5, $t7
		andi $t6, $t6, 65535
		sw $t6, 8($s2)
		
		lw $t5, 12($s2)
		add $t6, $t5, $s6
		andi $t6, $t6, 65535
		srl $t5, $t6, 9
		sll $t7, $t6, 7
		or $t6, $t5, $t7
		andi $t6, $t6, 65535
		sw $t6, 12($s2)
		
		# now xor operations
		lw $t5, 16($s2)
		lw $t3, 12($s2)
		xor $t6, $t5, $t3
		sw $t6, 16($s2)
		
		lw $t5, 20($s2)
		lw $t3, 4($s2)
		xor $t6, $t5, $t3
		sw $t6, 20($s2)
		
		lw $t5, 24($s2)
		lw $t3, 8($s2)
		xor $t6, $t5, $t3
		sw $t6, 24($s2)
		
		lw $t5, 28($s2)
		lw $t3, 0($s2)
		xor $t6, $t5, $t3
		sw $t6, 28($s2)
		
		addi $s3, $s3, 1
		j setupLoop
		
	exitInitFunc:
		lw $ra, 0($sp)
		lw $s0, 4($sp)
		lw $s1, 8($sp)
		lw $s2, 12($sp)
		lw $s3, 16($sp)
		lw $s4, 20($sp) # it was sw before
		lw $s5, 24($sp)
		lw $s6, 28($sp)
		lw $s7, 32($sp)
		addi $sp, $sp, 36
		jr $ra

W_x:
	addi $sp, $sp -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	# s0 = X, s1 = A, s2 = B
	xor $a0, $s0, $s1 
	jal F_x
	xor $a0, $v0, $s2
	jal F_x
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	



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
	li $v0, 34
	syscall

	la $a0, newline		
	#add $a0, $zero, $t0        
    	li $v0, 4
    	syscall
	jr $ra
		
