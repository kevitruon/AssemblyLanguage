# Kevin Truong
# ktruon13
# Spring 2021 CSE12
# Lab4: Functions and Graphics

######################################################
# Macros made for you (you will need to use these)
######################################################

# Macro that stores the value in %reg on the stack 
#	and moves the stack pointer.
.macro push(%reg)
	subi $sp $sp 4
	sw %reg 0($sp)
.end_macro 

# Macro takes the value on the top of the stack and 
#	loads it into %reg then moves the stack pointer.
.macro pop(%reg)
	lw %reg 0($sp)
	addi $sp $sp 4	
.end_macro

#################################################
# Macros for you to fill in (you will need these)
#################################################

# Macro that takes as input coordinates in the format
#	(0x00XX00YY) and returns x and y separately.
# args: 
#	%input: register containing 0x00XX00YY
#	%x: register to store 0x000000XX in
#	%y: register to store 0x000000YY in
.macro getCoordinates(%input %x %y)
	# YOUR CODE HERE
	srl %x, %input,16	#formatting %input into %x
	and %y, %input,0xFF 	#formatting %input into %y
	
.end_macro

# Macro that takes Coordinates in (%x,%y) where
#	%x = 0x000000XX and %y= 0x000000YY and
#	returns %output = (0x00XX00YY)
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store 0x00XX00YY in
.macro formatCoordinates(%output %x %y)
	# YOUR CODE HERE
	sll %output, %x, 16		#shift %x over 16 bits
	add %output, %output, %y	#add %y onto %output
.end_macro 

# Macro that converts pixel coordinate to address
# 	  output = origin + 4 * (x + 128 * y)
# 	where origin = 0xFFFF0000 is the memory address
# 	corresponding to the point (0, 0), i.e. the memory
# 	address storing the color of the the top left pixel.
# args: 
#	%x: register containing 0x000000XX
#	%y: register containing 0x000000YY
#	%output: register to store memory address in
.macro getPixelAddress(%output %x %y)
	# YOUR CODE HERE
	mul %output, %y, 0x80			#using given formula for output
	add %output, %output, %x
	mul %output, %output, 4
	add %output, %output, 0xFFFF0000
.end_macro


.text
# prevent this file from being run as main
li $v0 10 
syscall

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#  Subroutines defined below
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#*****************************************************
# Clear_bitmap: Given a color, will fill the bitmap 
#	display with that color.
# -----------------------------------------------------
# Inputs:
#	$a0 = Color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
clear_bitmap: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	la $t0, 0xFFFF0000			#loading origin into $t0
	la $t1, 0x007F007F                      #Address of (127,127)
     	getCoordinates($t1 $t2 $t3)             #Spliting 0x007F007F into 0x0000007F into $t2 and $t3
     	getPixelAddress($t4 $t2 $t3)           	#Pixel address of point(127,127) saved into $t4
	loop1: 
	     bgt $t0 $t4 endLoop                #break out of loop when at the last pixel
	     sw $a0 ($t0)                       #print the color of the background one pixel at a time
	     addi $t0 $t0 4                     #move to next pixel address
	     j loop1				#loop back
	endLoop:			
 	     jr $ra
#*****************************************************
# draw_pixel: Given a coordinate in $a0, sets corresponding 
#	value in memory to the color given by $a1
# -----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#		$a1 = color of pixel in format (0x00RRGGBB)
#	Outputs:
#		No register outputs
#*****************************************************
draw_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	
	lw $t0 0xFFFF0000				#load origin into $t0
        getCoordinates($a0 $t1 $t2)                 	#Stores x-coordinate into $t1 and y-coordinate into $t2
        getPixelAddress($t3 $t1 $t2)             	#get pixel address and save into $t3
        sw $a1 ($t3)                                	#prints color into pixel address
	
	pop($t3)
        pop($t2)
        pop($t1)
        pop($t0)
     
	jr $ra
	
	
#*****************************************************
# get_pixel:
#  Given a coordinate, returns the color of that pixel	
#-----------------------------------------------------
#	Inputs:
#		$a0 = coordinates of pixel in format (0x00XX00YY)
#	Outputs:
#		Returns pixel color in $v0 in format (0x00RRGGBB)
#*****************************************************
get_pixel: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	
	lw $t0 0xFFFF0000
        getCoordinates($a0 $t1 $t2)                    	#Stores x into $t1 and y into $t2
        getPixelAddress($t3 $t1 $t2)               	#get pixel address
        lw $v0 ($t3)                                   	#load the pixel color into $v0           
     
        pop($t3)
        pop($t2)
        pop($t1)
        pop($t0)
      
	jr $ra

#*****************************************************
# draw_horizontal_line: Draws a horizontal line
# ----------------------------------------------------
# Inputs:
#	$a0 = y-coordinate in format (0x000000YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_horizontal_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
	push($t0)
	push($t1)
	push($t2)
	
	lw $t0 0xFFFF0000
	la $t1 0x00000000                                 # x-coordinate
	drawHorizontalLoop:
	     	beq $t1 128 horizontalLoopEnd                #end loop after coloring 128 pixels
	     	getPixelAddress($t2 $t1 $a0)             #get pixel address
	     	sw $a1 ($t2)                                 #save pixel ccolor into pixel address
	     	addi $t1 $t1 1                               #increment the x position
	     	j drawHorizontalLoop
	horizontalLoopEnd:
		pop($t2)
	     	pop($t1)
	     	pop($t0)
 		jr $ra


#*****************************************************
# draw_vertical_line: Draws a vertical line
# ----------------------------------------------------
# Inputs:
#	$a0 = x-coordinate in format (0x000000XX)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_vertical_line: nop
	# YOUR CODE HERE, only use t registers (and a, v where appropriate)
 	lw $t0 0xFFFF0000
	la $t1 0x00000000                               # y-coordinate
	drawVerticalLoop:
	     beq $t1 128 verticalLoopEnd                #end loop after coloring 128 pixels
	     getPixelAddress($t2 $a0 $t1)           	#get pixel address
	     sw $a1 ($t2)                               #save pixel color into pixel address
	     addi $t1 $t1 1                             #increment the y position
	     j drawVerticalLoop
	verticalLoopEnd:
	
 	     jr $ra


#*****************************************************
# draw_crosshair: Draws a horizontal and a vertical 
#	line of given color which intersect at given (x, y).
#	The pixel at (x, y) should be the same color before 
#	and after running this function.
# -----------------------------------------------------
# Inputs:
#	$a0 = (x, y) coords of intersection in format (0x00XX00YY)
#	$a1 = color in format (0x00RRGGBB) 
# Outputs:
#	No register outputs
#*****************************************************
draw_crosshair: nop
	push($ra)
	
	# HINT: Store the pixel color at $a0 before drawing the horizontal and 
	# vertical lines, then afterwards, restore the color of the pixel at $a0 to 
	# give the appearance of the center being transparent.
	
	# Note: Remember to use push and pop in this function to save your t-registers
	# before calling any of the above subroutines.  Otherwise your t-registers 
	# may be overwritten.  
	
	# YOUR CODE HERE, only use t0-t7 registers (and a, v where appropriate)
	push($ra)
	push($t0)
	push($t1)
	push($t2)
	push($t3)
	push($t4)
	push($t5)
	move $t5 $sp

	move $t0 $a0  			# store 0x00XX00YY in t0
	move $t1 $a1  			# store 0x00RRGGBB in t1
	getCoordinates($a0 $t2 $t3)  	# store x and y in t2 and t3 respectively

	lw $t0 0xFFFF0000		
        getPixelAddress($t4 $t2 $t3) 	#getting intersection point
        lw $t6 ($t4)			#storing color of intersection point

	move $a0 $t3			#drawing horizontal line of crosshair
	move $a1 $t1
	jal draw_horizontal_line

	move $a0 $t2			#drawing vertical line of crosshair
	move $a1 $t1
	jal draw_vertical_line

        sw $t6 ($t4)			#printing original color at intersection point

	move $sp $t5
	pop($t5)
	pop($t4)
	pop($t3)
	pop($t2)
	pop($t1)
	pop($t0)
	pop($ra)
	jr $ra
