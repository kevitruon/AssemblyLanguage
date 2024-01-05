# Truong, Kevin
# ktruon13
# Lab3 :ASCII-risks (Asterisks)
# CSE 12, Spring 21

# -----------
# DESCRIPTION
# In this lab, the user enters a number of rows in the pyramid. The program
# will print the pyramid with numbers and *'s .
# -----------
# FILES
# -
# Lab3.asm
# This file includes the assembly code of the lab.
# -----------
# INSTRUCTIONS
# This program is intended to be run using the MIPS Assembler and Runtime Simulator
# (MARS). Enter the test case as a program argument and run using MARS.

	.text
	.globl main
main:

prompt: nop
	li	$v0,4		#print start
	la	$a0, start	#syscall code = 4
	syscall
	
rows:	nop
	li 	$v0,5		#Take user input to get numbers of rows
	syscall
	
	move	$t0, $zero	#initialize count = 1
	subi	$t1,$v0,1	#target value = input-1
	addi	$t7,$v0,-1	#number of rows saved to $t7
	
	
pause:	nop
	li   	$t2, 0		#initialize $t2(i) as 0 for loop1
	li	$t3, 0 		#initialize $t3(j) as 0 for loop2
	bge  	$v0, 1, loop	#if greater than 1 jump to loop1
	blez 	$v0, errorM	#Checks if input($v0)<=0
	
loop:	nop			#prints tab before count
	bge	$t3, $t1,loopy	#break if j>target value
	addi	$t3, $t3,1	#j++
	li	$v0,4		#syscall=4(string)
	la	$a0, tab	#print tab
	syscall
	j	loop		#jump back to loop
loopy:
	addi	$t0,$t0,1	#count++
	li	$v0,1		#syscall=1(int)
	move	$a0,$t0		#print count
	syscall
	
	
	li	$v0,4		#syscall=4(string)
	la	$a0, newLine	#print newLine
	syscall
	subi	$t1,$t1,1
	j	loop1		#jump back to loop1
	
loop1:	nop
	bge	$t2,$t7,exit	#Exit loop if i is greater than rows
	addi 	$t2,$t2,1	#i++
	
	li	$t3, 0 		#initialize $t3(j) as 0 for loop2
	j	loop2		#jump to loop2
	
l2exit:
	addi	$t0, $t0,1	#count++
	li	$v0,1		#syscall=1(int)
	move	$a0,$t0		#print count
	syscall
	
	li	$t4,0		#initailize $t4(k) as 0 for loop3
	j	loop3		#jump to loop3
	
l3exit:
	li	$t5,0		#initialize $t5(l) as 0 for loop4
	subi	$t6,$t2,1	#saving $t6 as i-1
	j	loop4		#jump to loop4
l4exit:
	li	$v0,4		#syscall=4(string)
	la	$a0, tab	#print tab
	syscall
	
	addi	$t0,$t0,1	#count++
	li	$v0,1		#syscall=1(int)
	move	$a0,$t0		#print count
	syscall
	
	
	li	$v0,4		#syscall=4(string)
	la	$a0, newLine	#print newLine
	syscall
	subi	$t1,$t1,1
	j	loop1		#jump back to loop1
	
loop2:	nop			#prints tab before count
	bge	$t3, $t1,l2exit	#break if j>target value
	addi	$t3, $t3,1	#j++
	li	$v0,4		#syscall=4(string)
	la	$a0, tab	#print tab
	syscall
	j	loop2		#jump back to loop2
	
loop3:	nop			#first half of triangle
	bge	$t4,$t2,l3exit	#break if $t4>$t2
	addi 	$t4,$t4,1	#k++
	
	li	$v0,4		#syscall=4(string)
	la	$a0, tab	#print tab
	syscall
	
	li	$v0,4		#syscall=4(string)
	la	$a0, star	#print star
	syscall
	
	j	loop3		#jump back to loop3
	
loop4:	nop			#second half of triangle
	bge	$t5,$t6,l4exit 	#break if l>(i-1)
	addi 	$t5,$t5,1	#l++
	
	li	$v0,4		#syscall=4(string)
	la	$a0, tab	#print tab
	syscall
	
	li	$v0,4		#syscall=4(string)
	la	$a0, star	#print star
	syscall
	
	j	loop4		#jump back to loop4
	
	
errorM: nop
	li	$v0,4		#syscall=4(string)
	la	$a0,error	#print error
	syscall
	j	prompt		#jump to prompt
	
exit:				#break out of loops
    
 
	.data			#start of data
	
start:	.asciiz "Enter the number of rows:\t"
error:	.asciiz "Enter the height of the pattern (must be greater than 0): Invalid Entry! \n"
tab:	.asciiz "\t"
newLine:.asciiz	"\n"
star:	.asciiz "*"
