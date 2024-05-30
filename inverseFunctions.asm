.data
inverse_S_lookup:
    # Inverse S-box S0
    .byte 0xC, 0x3, 0x0, 0xA, 0xB, 0x4, 0x5, 0xF, 0x9, 0xE, 0x6, 0xD, 0x2, 0x7, 0x8, 0x1
    # Inverse S-box S1
    .byte 0xA, 0x7, 0x6, 0x9, 0x1, 0x2, 0xC, 0x5, 0x3, 0x4, 0x8, 0xF, 0xD, 0xE, 0xB, 0x0
    # Inverse S-box S2
    .byte 0x9, 0x2, 0xF, 0x8, 0x0, 0xC, 0x3, 0x6, 0x4, 0xD, 0x1, 0xE, 0x7, 0xB, 0xA, 0x5
    # Inverse S-box S3
    .byte 0xB, 0x5, 0x4, 0xF, 0xC, 0x6, 0x9, 0x0, 0xD, 0x3, 0xE, 0x8, 0x1, 0xA, 0x2, 0x7

.text
.globl main

main:

    	li   $a0, 0xf562
    	jal  inverse_S
    
    	li $a0, 0x4f
    	jal inverse_P

	li $a0, 0x1111
	jal inverse_L
	
	li $a0, 0x1516
	jal inverse_F
	
	li $a0, 0xf0ad
	li $a1, 0xcccc
	li $a2, 0xdddd
	jal inverse_W

    	li   $v0, 10            # Exit syscall
    	syscall

inverse_S:
    	# Input: $a0 = 16-bit input X
    	# Output: $v0 = 16-bit output S^-1(X)

    	addi $sp, $sp, -24
    	sw   $ra, 20($sp)
    	sw   $t0, 16($sp)
    	sw   $t1, 12($sp)
    	sw   $t2, 8($sp)
    	sw   $t3, 4($sp)
    	sw   $t4, 0($sp)

    	la   $t4, inverse_S_lookup

    	andi $t3, $a0, 0xF    # x3
    	srl  $a0, $a0, 4
    	andi $t2, $a0, 0xF    # x2
    	srl  $a0, $a0, 4
    	andi $t1, $a0, 0xF    # x1
    	srl  $a0, $a0, 4
    	andi $t0, $a0, 0xF    # x0

    	add  $t3, $t4, $t3
    	lb   $t3, 48($t3)        # S3^-1(x3)

    	add  $t2, $t4, $t2
    	lb   $t2, 32($t2)        # S2^-1(x2)

    	add  $t1, $t4, $t1
    	lb   $t1, 16($t1)        # S1^-1(x1)

    	add  $t0, $t4, $t0
    	lb   $t0, 0($t0)         # S0^-1(x0)

    	move $v0, $t0
    	sll  $v0, $v0, 4
    	or   $v0, $v0, $t1
    	sll  $v0, $v0, 4
    	or   $v0, $v0, $t2
    	sll  $v0, $v0, 4
    	or   $v0, $v0, $t3

    	# Restore registers from the stack
    	lw   $t4, 0($sp)
    	lw   $t3, 4($sp)
    	lw   $t2, 8($sp)
    	lw   $t1, 12($sp)
    	lw   $t0, 16($sp)
    	lw   $ra, 20($sp)
    	addi $sp, $sp, 24

    	jr   $ra                # Return from function


inverse_P:
	
	addi $sp, $sp, -8
    	sw   $ra, 0($sp)
    	sw   $t0, 4($sp)
	
	li $v0, 0
	
	#5 to 0
	sll $t0, $a0, 5
	andi $t0, $t0, 0x80
	or $v0, $v0, $t0
	
	#7 to 1
	sll $t0, $a0, 6
	andi $t0, $t0, 0x40
	or $v0, $v0, $t0
	
	#3 to 2
	sll $t0, $a0, 1
	andi $t0, $t0, 0x20
	or $v0, $v0, $t0
	
	#4 to 3
	sll $t0, $a0, 1
	andi $t0, $t0, 0x10
	or $v0, $v0, $t0
	
	#2 to 4
	srl $t0, $a0, 2
	andi $t0, $t0, 0x08
	or $v0, $v0, $t0
	
	#6 to 5
	sll $t0, $a0, 1
	andi $t0, $t0, 0x04
	or $v0, $v0, $t0
	
	#1 to 6
	srl $t0, $a0, 5
	andi $t0, $t0, 0x02
	or $v0, $v0, $t0
	
	#0 to 7
	srl $t0, $a0, 7
	andi $t0, $t0, 0x01
	or $v0, $v0, $t0
	

    	lw   $t0, 4($sp)
    	lw   $ra, 0($sp)
    	addi $sp, $sp, 8
	
	jr $ra
	
	
inverse_L:
	addi $sp, $sp, -20
    	sw   $ra, 0($sp)
    	sw   $t0, 4($sp)
    	sw   $t1, 8($sp)
    	sw   $t2, 12($sp)
    	sw   $t3, 16($sp)
	
	#circular shift to left by 10
	
	sll $t0, $a0, 10
	srl $t1, $a0, 6
	or $t0, $t0, $t1	#Y <<< 10
	andi $t0, $t0, 0xffff
	
	#circular shift to right by 10
	
	srl $t1, $a0, 10
	sll $t2, $a0, 6
	or $t1, $t1, $t2	#Y >>> 10
	andi $t1, $t1, 0xffff
	
	xor $t2, $a0, $t0
	xor $t2, $t2, $t1	#Y ^ Y <<< 10 ^ Y >>> 10 = Z
	
	#circular shift left by 4
	
	sll $t0, $t2, 4
	srl $t1, $t2, 12
	or $t0, $t0, $t1	#Z <<< 4
	andi $t0, $t0, 0xffff
	
	#circular shift right by 4
	
	srl $t1, $t2, 4
	sll $t3, $t2, 12
	or $t1, $t1, $t3	#Z >>> 4
	andi $t1, $t1, 0xffff
	
	xor $v0, $t2, $t0
	xor $v0, $v0, $t1

	lw   $t3, 16($sp)
	lw   $t2, 12($sp)
	lw   $t1, 8($sp)
	lw   $t0, 4($sp)
    	lw   $ra, 0($sp)
    	addi $sp, $sp, 20
	
	jr $ra


inverse_F:
	
	addi $sp, $sp, -8
    	sw   $ra, 0($sp)
    	sw   $t0, 4($sp)
	
	
	jal inverse_L
	move $a0, $v0
	
	jal inverse_S
	
	move $t0, $v0	#Z
	
	andi $a0, $t0, 0xff
	
	jal inverse_P
	
	sll $v0, $v0, 8
	srl $t0, $t0, 8
	or $v0, $v0, $t0
	
	
	lw   $t0, 4($sp)
    	lw   $ra, 0($sp)
    	addi $sp, $sp, 8
	jr $ra
	
inverse_W:
	
	# a0 is X a1 is A a2 is B
	addi $sp, $sp, -4
    	sw   $ra, 0($sp)
	
	jal inverse_F
	
	xor $a0, $v0, $a2
	
	jal inverse_F
	
	xor $v0, $v0, $a1
	
	lw   $ra, 0($sp)
    	addi $sp, $sp, 4
	
	jr $ra