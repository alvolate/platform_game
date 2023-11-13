#####################################################################
#
# CSCB58 Winter 2023 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Name, Student Number, UTorID, official email
# Taeyang Kim, 1008064210, kimtaeya, taeyang.kim@mail.utoronto.ca
#
# Bitmap Display Configuration:
# - Unit width in pixels: 4 (update this as needed)
# - Unit height in pixels: 4 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3 (choose the one the applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. A. Health/score [2 marks]
# 2. B. Fail Condition [1 mark]
# 3. C. Win condition [1 mark]
# 4. D. Moving objects [2 marks]
# 5. G. Different levels [2 marks]
# 6. K. Double Jumps	[1 mark]
# 2+1+1+2+2+1 = 9 marks
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#https://play.library.utoronto.ca/watch/5554cf9eda653ee2d65219cc6e16ff9e
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#yes
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

# Define constants for the screen parameters
.eqv HEIGHT 256
.eqv ADDRESS_BASE 0x10008000
.eqv ADDRESS_LOST 0x10008F40
.eqv COLOR_RED 0xff0000
.eqv COLOR_BLACK 0x000000     # Black color (all bits set to 0)
.eqv COLOR_GREY 0x808080
.eqv COLOR_WHITE 0xFFFFFF
.eqv COLOR_YELLOW 0xFFFF00
.eqv COLOR_BLUE 0x0000FF
.eqv COLOR_ORANGE 0xFFA500
.data
BASE_ADDRESS: 	.word 0x10008000    # Base address of the screen buffer
END_ADDRESS:	.word 0x1000F000
WIDTH: 		.word 256                  # Width of the screen in pixels
PIXEL_SIZE: 	.word 4               # Size of each pixel in bytes

HEARTH_ADDRESS: .word 0x10008010

enemy_direction:.word 1
enemy_location:	.word 28

current_Health:	.word 3
current_Stage:	.word 1
Score:		.word 200
# Define constant for the color 


#Stage value
STAGE_ADDRESS: 	.word 0X10008090
STAGE_1: 	.word 0x1000A000
STAGE_2:	.word 0x1000A54C
STAGE_3: 	.word 0x1000A000
STAGE_1_CLEAR: 	.word 0x10009FF0
STAGE_2_CLEAR:	.word 0x1000A5A0
STAGE_3_CLEAR: 	.word 0x1000A3B8

#Enemies 
STAGE_1_ENEMY: 	.word 0x10009C48
STAGE_2_ENEMY: 	.word 0x1000A268

playerX:	.word 05
playerY:	.word 31
doubleJump: 	.word 0
jump:		.word 0

playerX_Stage_1:	.word 05
playerY_Stage_1:	.word 31

playerX_Stage_2:	.word 50
playerY_Stage_2:	.word 44

.text

restart:
	li $t0, 3
	la $t1, current_Health
	sw $t0,0($t1)
	li $t0, 200
	la $t1, Score
	sw $t0,0($t1)
	li $t0, 1
	la $t1, current_Stage
	sw $t0,0($t1)

reset:
	li $t0, 0
	la $t1, playerX
	sw $t0,0($t1)
	la $t1, playerY
	sw $t0,0($t1)
	
	
clear_screen:
	lw $t0, BASE_ADDRESS
	lw $t1, END_ADDRESS
	li $t2, COLOR_BLACK
	
clear_loop:
    sw $t2, 0($t0)     # Store the value in memory at the current address
    addi $t0, $t0, 4  # Increment the address by 4 bytes
    ble $t0, $t1, clear_loop # Repeat until all bytes have been cleared

	
start:
	jal draw_stage_letter
	jal draw_health_1
	jal getStageLocation
	jal playerLocation
	j main2
	
getStageLocation:
	beq $s1, 1, getStageLocation_1
	beq $s1 ,2 ,getStageLocation_2
getStageLocation_1:
	la $t0, playerX
	lw $t1, playerX_Stage_1
	sw $t1,0($t0)
	la $t0, playerY
	lw $t1, playerY_Stage_1
	sw $t1,0($t0)
	jr $ra
getStageLocation_2:
	la $t0, playerX
	lw $t1, playerX_Stage_2
	sw $t1,0($t0)
	la $t0, playerY
	lw $t1, playerY_Stage_2
	sw $t1,0($t0)
	jr $ra

draw_health_1:
	lw $t0, HEARTH_ADDRESS
	li $t1, COLOR_RED
	lw $s0, current_Health
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	blt $s0,2,draw_grey_health_2

draw_health_2:
	addi $t0, $t0,16
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	blt $s0,3,draw_grey_health_3
draw_health_3:
	addi $t0, $t0,16
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	jr $ra
	
draw_grey_health_2:
	lw $t0, HEARTH_ADDRESS
	li $t1, COLOR_GREY
	addi $t0, $t0,16
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	
draw_grey_health_3:
	lw $t0, HEARTH_ADDRESS
	addi $t0, $t0,32
	li $t1, COLOR_GREY
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 260($t0)
	sw $t1, 264($t0)
	sw $t1, 516($t0)
	jr $ra


################  DRAW NUMBER  ################
DrawNum: # void DrawNum(int num, int x, int y);
	# Guaranteed not to modify $aX

	# Address Calculations
	li $t0, 256
	mul $t0, $a1, 64
	add $t0, $t0, $a2
	mul $t0, $t0, 4
	addi $t0, $t0, ADDRESS_BASE
	
	# Colours
	li $t1, COLOR_BLACK
	li $t2, COLOR_GREY
	
	beq $a0, 1, DrawNumOne
	beq $a0, 2, DrawNumTwo
	beq $a0, 3, DrawNumThree
	beq $a0, 4, DrawNumFour
	beq $a0, 5, DrawNumFive
	beq $a0, 6, DrawNumSix
	beq $a0, 7, DrawNumSeven
	beq $a0, 8, DrawNumEight
	beq $a0, 9, DrawNumNine
DrawNumZero:
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumOne:
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	j DrawNumExit
DrawNumTwo:
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	j DrawNumExit
DrawNumThree:
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumFour:
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	j DrawNumExit
DrawNumFive:
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumSix:
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumSeven:
	sw $t2, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumEight:
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumNine:
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t2, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t2, 12($t0)
	addi $t0, $t0, HEIGHT
	sw $t1, 0($t0)
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t1, 12($t0)
	j DrawNumExit
DrawNumExit:
	jr $ra


	
draw_score:
	move $s7, $ra
	li $a1, 4
	li $a2, 15
	lw $s3, Score
DrawScoreLoop:
	div $s3, $s3, 10
	mfhi $a0
	jal DrawNum
DrawScoreLoopUpdate:
	addi $a2, $a2, -5
	blt $a2, 0, DrawScoreExit
	j DrawScoreLoop
DrawScoreExit:
	jr $s7
	


draw_stage_letter:
	lw $t0, STAGE_ADDRESS
	li $t1, COLOR_WHITE
	#S
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1032($t0)
	sw $t1, 1028($t0)
	sw $t1, 1024($t0)
	#T
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 276($t0)
	sw $t1, 532($t0)	
	sw $t1, 788($t0)
	sw $t1,1044($t0)
	#A
	sw $t1 32($t0)
	sw $t1 36($t0)
	sw $t1 40($t0)
	sw $t1 288($t0)
	sw $t1 296($t0)
	sw $t1 544($t0)
	sw $t1 552($t0)
	sw $t1 800($t0)
	sw $t1 804($t0)
	sw $t1 808($t0)
	sw $t1 1056($t0)
	sw $t1 1064($t0)
	#G
	sw $t1 48($t0)
	sw $t1 52($t0)
	sw $t1 56($t0)
	sw $t1 304($t0)
	sw $t1 560($t0)
	sw $t1 568($t0)
	sw $t1 816($t0)
	sw $t1 824($t0)
	sw $t1 1072($t0)
	sw $t1 1076($t0)
	sw $t1 1080($t0)
	#E
	sw $t1 64($t0)
	sw $t1 68($t0)	
	sw $t1 72($t0)
	sw $t1 320($t0)
	sw $t1 576($t0)
	sw $t1 580($t0)
	sw $t1 584($t0)
	sw $t1 832($t0)
	sw $t1 1088($t0)
	sw $t1 1092($t0)
	sw $t1 1096($t0)
	lw $s1, current_Stage
	beq $s1,1, draw_one
	beq $s1,2,draw_two
	j draw_three
	
draw_one:
	sw $t1 88($t0)
	sw $t1 344($t0)
	sw $t1 600($t0)
	sw $t1 856($t0)
	sw $t1 1112($t0)
	jr $ra

draw_two:
	sw $t1 88($t0)
	sw $t1 92($t0)
	sw $t1 96($t0)
	sw $t1 352($t0)
	sw $t1 608($t0)
	sw $t1 604($t0)
	sw $t1 600($t0)
	sw $t1 856($t0)
	sw $t1 1112($t0)
	sw $t1 1116($t0)
	sw $t1 1120($t0)
	jr $ra

draw_three:
	sw $t1 88($t0)
	sw $t1 92($t0)
	sw $t1 96($t0)
	sw $t1 352($t0)
	sw $t1 608($t0)
	sw $t1 604($t0)
	sw $t1 600($t0)
	sw $t1 864($t0)
	sw $t1 1112($t0)
	sw $t1 1116($t0)
	sw $t1 1120($t0)
	jr $ra
	

draw_stage:
	beq $s1,1,draw_stage_1
	beq $s1,2,draw_stage_2
	j draw_stage_3
	
draw_stage_1:
	add $sp,$sp,-4
	sw $ra, 0($sp)
	lw $t0, STAGE_1
	jal draw_platform_1
	addi $t0, $t0 -100
	jal draw_platform_1
	addi $t0, $t0 -600
	jal draw_platform_1
	jal draw_stage_clear_platform_1
	lw $t1,0($sp)
	addi $sp,$sp,4
	jr $t1

draw_stage_2:
	add $sp,$sp,-4
	sw $ra,0($sp)
	lw $t0, STAGE_2
	jal draw_platform_1
	addi $t0, $t0,180
	jal draw_platform_1
	addi $t0, $t0,1280
	jal draw_platform_1
	addi $t0, $t0,340
	jal draw_platform_1
	addi $t0, $t0,340
	jal draw_platform_1
	jal draw_stage_clear_platform_2
	lw $t1,0($sp)
	addi $sp,$sp,4
	jr $t1
	
	
draw_stage_3:
	add $sp,$sp,-4
	sw $ra,0($sp)
	lw $t0, STAGE_3
	jal draw_platform_1
	addi $t0, $t0 -160
	jal draw_platform_1
	addi $t0, $t0 640
	jal draw_stage_clear_platform_3
	lw $t1,0($sp)
	addi $sp,$sp,4
	jr $t1
	

draw_platform_1:#length 5
	li $t1 COLOR_RED
	sw $t1, 0($t0) # row 1f
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 12($t0)
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 28($t0)
	sw $t1, 32($t0)
	sw $t1, 36($t0)
	sw $t1, 40($t0)
	sw $t1, 44($t0)
	sw $t1, 48($t0)
	sw $t1, 52($t0)
	sw $t1, 56($t0)
	sw $t1, 60($t0)
	sw $t1, 64($t0)
	sw $t1, 68($t0)
	sw $t1, 72($t0)
	sw $t1, 76($t0)
	sw $t1, 80($t0)
	jr $ra


draw_stage_clear_platform_1:
	li $t1, COLOR_YELLOW
	lw $t0, STAGE_1_CLEAR
	sw $t1, 0($t0) 
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	jr $ra
	
draw_stage_clear_platform_2:
	li $t1, COLOR_YELLOW
	lw $t0, STAGE_2_CLEAR
	sw $t1, 0($t0) 
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	jr $ra

draw_stage_clear_platform_3:
	li $t1, COLOR_YELLOW
	lw $t0, STAGE_3_CLEAR
	sw $t1, 0($t0) 
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	jr $ra
	
#draw enemies



main:
	li $v0, 32
	li $a0, 400
	syscall
	lw $t0, jump
	beq $t0,1,playerJump2
	bgtz $t0,playerJump
	j checkBelow
	
main2:
	#update score
	lw $t1, Score
	la $t2, Score
	addi $t1,$t1,-1
	sw $t1,0($t2)
	jal draw_score
	jal draw_stage
	jal draw_enemies
	jal colorPlayer
	
	#key pressed
	li $t9, 0xffff0000
	lw $t8, 0($t9)
	beq $t8,1, keypress_happened
	
	j main

draw_enemies:	
	beq $s1,2,draw_enemies_level_2

draw_enemies_level_1:
	li $t1, COLOR_ORANGE
	lw $t0, STAGE_1_ENEMY
	lw $t2, enemy_direction
	add $t0,$t0,$s2
	
	
	sw $t1, 0($t0) 
	sw $t1, 4($t0)
	sw $t1, -256($t0)
	sw $t1, -252($t0)
	sw $t1, 356($t0)
	sw $t1, 360($t0)
	sw $t1, 612($t0)
	sw $t1, 616($t0)
	li $t1, COLOR_BLACK
	sw $t1, -4($t0)
	sw $t1, 8($t0)
	sw $t1, -260($t0)
	sw $t1, -248($t0)
	sw $t1, 352($t0)
	sw $t1, 364($t0)
	sw $t1, 608($t0)
	sw $t1, 620($t0)
	j update_enemy

draw_enemies_level_2:
	li $t1, COLOR_ORANGE
	lw $t0, STAGE_2_ENEMY
	lw $t2, enemy_direction
	add $t0,$t0,$s2
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, -256($t0)
	sw $t1, -252($t0)
	
	sw $t1, 1536($t0)
	sw $t1, 1540($t0)
	sw $t1, 1792($t0)
	sw $t1, 1796($t0)
	
	li $t1, COLOR_BLACK
	sw $t1, -4($t0)
	sw $t1, 8($t0)
	sw $t1, -260($t0)
	sw $t1, -248($t0)
	sw $t1, 1532($t0)
	sw $t1, 1544($t0)
	sw $t1, 1788($t0)
	sw $t1, 1800($t0)
	
	
	j update_enemy
	
update_enemy:
	mul $t2,$t2,4
	add $s2,$s2,$t2
	beq $s2,32, change_direction
	beq $s2,0, change_direction
	jr $ra
	
change_direction:
	lw $t2,enemy_direction
	neg $t2,$t2

	la $t3,enemy_direction
	sw $t2,0($t3)
	jr $ra
	

colorPlayer:
	move $t7 $ra
	jal playerLocation
	li $t3, COLOR_ORANGE
	lw $t4,0($s4)
	beq $t3,$t4,heart_lost
	lw $t4,4($s4)
	beq $t3,$t4,heart_lost
	lw $t4,-256($s4)
	beq $t3,$t4,heart_lost
	lw $t4,-252($s4)
	beq $t3,$t4,heart_lost
      	li $t2, COLOR_BLUE
    	sw $t2,0($s4)
	sw $t2,4($s4)
	sw $t2,-256($s4)
	sw $t2,-252($s4)
    	# Continue execution of function1
    	# ...
    	jr $t7               # Return to the caller (could be the main function or another function)
    
playerLocation:
	lw $t3, playerY
	lw $t4, playerX
	mul $t3,$t3,64
	add $t3,$t3,$t4
	mul $t3,$t3,4
	addi $s4, $t3,ADDRESS_BASE
	jr $ra
	
playerJump:
	la $t0 ,playerY
	lw $t1 ,playerY
	addi $t1,$t1,-1
	sw $t1,0($t0)
playerJump2:
	la $t0 ,jump
	lw $t1 ,jump
	addi $t1, $t1,-1
	sw $t1,0($t0)
	li $t2, COLOR_BLACK
	sw $t2,0($s4)
	sw $t2,4($s4)
	jal playerLocation
	j main2

	
checkBelow:
	jal playerLocation
	li $t1,COLOR_YELLOW
	lw $t2, 256($s4)
	beq $t2,$t1, nextStage
	
	li $t1,COLOR_RED
	bne $t2,$t1, checkBelow2
	li $t4, 0
	la $t5, doubleJump 
	sw $t4,0($t5)
	j main2
	
checkBelow2:
	lw $t2, 260($s4)
	bne $t2,$t1, respond_to_x
	li $t4, 0
	la $t5, doubleJump 
	sw $t4,0($t5)
	j main2
		
keypress_happened:
	lw $t2, 4($t9)
	beq $t2,0x61,respond_to_a
	beq $t2,0x64,respond_to_d
	beq $t2,0x77,respond_to_w
	beq $t2,0x78,respond_to_x
	beq $t2,0x70,restart #p
	j main

respond_to_a:
	la $t0 ,playerX
	lw $t1 ,playerX
	addi $t1,$t1,-1
	blt $t1,0,main
	li $t2, COLOR_BLACK
	sw $t2,4($s4)
	sw $t2,-252($s4)
	sw $t1,0($t0)
	jal playerLocation
	j main
	
respond_to_w:
	la $t0 ,doubleJump
	lw $t1 ,doubleJump
	addi $t1, $t1,1
	bge $t1,4, main
	sw $t1,0($t0)
	la $t0 ,jump
	lw $t1 ,jump
	addi $t1, $t1,4
	sw $t1,0($t0)
	li $t2, COLOR_BLACK
	sw $t2,0($s4)
	sw $t2,4($s4)
	la $t0 ,playerY
	lw $t1 ,playerY
	addi $t1,$t1,-1
	sw $t1,0($t0)
	jal playerLocation
	j main

respond_to_x:
	la $t0 ,playerY
	lw $t1 ,playerY
	addi $t1,$t1,1
	bgt $t1,64, playerLost
	li $t2, COLOR_BLACK
	sw $t2,-256($s4)
	sw $t2,-252($s4)
	sw $t1,0($t0)
	jal playerLocation
	j main2
			
respond_to_d:
	la $t0 ,playerX
	lw $t1 ,playerX
	addi $t1,$t1,1
	bgt $t1,64,main
	li $t2, COLOR_BLACK
	sw $t2,0($s4)
	sw $t2,-256($s4)
	sw $t1,0($t0)
	jal playerLocation
	
	j main

heart_lost:
	la $t0, current_Health
	addi $s0,$s0, -1
	beq $s0, 0, playerLost
	sw $s0, 0($t0)
	jal draw_health_1
	j main
	

nextStage:
	addi $s1,$s1, 1
	la $t0, current_Stage
	beq $s1,4, playerWon
	sw $s1,0($t0)
	la $t0, Score
	lw $t1,Score
	addi $t1 ,$t1,300
	sw $t1,0($t0)
	lw $t0, BASE_ADDRESS
	lw $t1, END_ADDRESS
stage_loop:
    	sb $t4, 0($t0)     # Store the value in memory at the current address
    	addi $t0, $t0, 4  # Increment the address by 4 bytes
    	ble $t0, $t1, stage_loop# Repeat until all bytes have been cleared
	
	j reset

playerLost:
	jal draw_you
	j draw_lost

draw_you:
	li $t1, COLOR_WHITE
	li $t0, ADDRESS_LOST
	#Y
	sw $t1, 0($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 264($t0)
	sw $t1, 512 ($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 772($t0)
	sw $t1, 1028($t0)
	#O
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 272($t0)
	sw $t1, 280($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	#U
	sw $t1, 32($t0)
	sw $t1, 40($t0)
	sw $t1, 288($t0)
	sw $t1, 296($t0)
	sw $t1, 544($t0)
	sw $t1, 552($t0)
	sw $t1, 800($t0)
	sw $t1, 808($t0)
	sw $t1, 1056($t0)
	sw $t1, 1060($t0)
	sw $t1, 1064($t0)
	jr $ra

draw_lost:
	addi $t0,$t0, 52
	#L
	sw $t1, 0($t0)
	sw $t1, 256($t0)
	sw $t1, 512 ($t0)
	sw $t1, 768($t0)
	sw $t1, 1024($t0)
	sw $t1, 1028($t0)
	sw $t1, 1032($t0)
	#O
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 272($t0)
	sw $t1, 280($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	#S
	addi $t0, $t0, 32
	sw $t1, 0($t0)
	sw $t1, 4($t0)
	sw $t1, 8($t0)
	sw $t1, 256($t0)
	sw $t1, 512($t0)
	sw $t1, 516($t0)
	sw $t1, 520($t0)
	sw $t1, 776($t0)
	sw $t1, 1032($t0)
	sw $t1, 1028($t0)
	sw $t1, 1024($t0)
	#T
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 276($t0)
	sw $t1, 532($t0)	
	sw $t1, 788($t0)
	sw $t1,1044($t0)
	j end

playerWon:
	jal draw_you
	j draw_won

draw_won:
	addi $t0,$t0, 52
	#W
	sw $t1, 8($t0)
	sw $t1, 16($t0)
	sw $t1, 24($t0)
	sw $t1, 264($t0)
	sw $t1, 272($t0)
	sw $t1, 280($t0)
	sw $t1, 520($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)
	sw $t1, 776($t0)
	sw $t1, 792($t0)
	sw $t1, 784($t0)
	sw $t1, 1032($t0)
	sw $t1, 1036($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	#O
	addi $t0, $t0, 16
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 272($t0)
	sw $t1, 280($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1, 1040($t0)
	sw $t1, 1044($t0)
	sw $t1, 1048($t0)
	#N
	addi $t0, $t0, 16
	sw $t1, 16($t0)
	sw $t1, 20($t0)
	sw $t1, 24($t0)
	sw $t1, 272($t0)
	sw $t1, 280($t0)
	sw $t1, 528($t0)
	sw $t1, 536($t0)	
	sw $t1, 784($t0)
	sw $t1, 792($t0)
	sw $t1,1040($t0)
	sw $t1, 1048($t0)
	j end
	
end:
