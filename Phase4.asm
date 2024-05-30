.data
plainText: .space 100
plainTextInWords: .space 400


.text
main:	
	#get the input
	li $v0, 8
	la $a0, plainText
	li $a1, 99
	syscall
	
	#convert .byte to .word
	la $a0, plainText
	la $a1, plainTextInWords
	jal storeAsWord
	
	
	la $a0, plainTextInWords
	jal printArray
		
finish:		
	j exit
exit:
      	li $v0, 10
      	syscall

storeAsWord:
	addi $sp, $sp, -16
    	sw $ra, 12($sp)
    	sw $s0, 8($sp)
    	sw $s1, 4($sp)
    	sw $s2, 0($sp)
    	
	move $s0, $a0
	move $s1, $a1
	
	storeChar:
		lb $s2, 0($s0)
		beqz $s2, exit_storeChar
		sw $s2, 0($s1)
		addi $s0, $s0, 1
		addi $s1, $s1, 4
		j storeChar
	exit_storeChar:
		lw $s1, 0($sp)
		lw $s1, 4($sp)
    		lw $s0, 8($sp)
    		lw $ra, 12($sp)
    		addi $sp, $sp, 16
		jr $ra
	



printArray:
    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $s1, 0($sp)

    move $s0, $a0

printLoop:
    lw $s1, 0($s0)
    beqz $s1, end_printLoop

    addi $s0, $s0, 4
    move $a0, $s1
    jal printHex

    j printLoop

end_printLoop:
    lw $s1, 0($sp)
    lw $s0, 4($sp)
    lw $ra, 8($sp)
    addi $sp, $sp, 12

    jr $ra

printHex:
    li $v0, 11
    syscall

    jr $ra
