# (a) I implimented the psuedo-random generation function
# (b) You can find it at line 532 which is under the bigRand label
# (c) It impliments a Linear Congruential Random (LCD) number generator.
# It takes an initial seed provided by the old rand function at the beginning of the program (line 30-34)
# and stores it in the seed variable in .data as a word (which is initially 0).
# Then it loads the seed in and uses variables c,a,m : (aX_i + c) mod m. Next, it stores the new
# seed in the seed variable for next use. We mod this by 7 so the final answer is between 0 and 7. 
# Finally it returns the random number in a0. I used this function to create the randomly generated
# coords for character, box and target. This can be found betwenn the lines 50 and 180. This is a recursive 
# sequence that uses the seed generated last time from its use to create a different seed every time.X is the
# sequence of seeds that are randomly generated with X_i being the current one being used.
#Citations of Research:
# https://asecuritysite.com/random/linear?val=2175143%2C3553%2C10653%2C1000000
# https://www.educative.io/answers/pseudo-random-number-using-the-linear-congruential-generator
.data
character:  .byte 0,0
box:        .byte 0,0
target:     .byte 0,0
seed: .word 0 #seed can end up having hugs values so we store it as a word for the extra space

victory: .string "\nYou have won, the box is on the target!\n"
restartQuestion: .string "\nYou are about to restart, hit the edge one more time to confirm."
restartCancel: .string "\nYou cancelled your restart"
invalidMove: .string "\nYou cannot move in this direction"
.globl main
.text

main:
    R:
    #creating initial seed using old rand
    jal rand #call rand (inital seed)
    mv x10, a0 #move the value in a0 to t5
    la x14, seed #load address of seed
    sw x10, 0(x14) #store t5 into seed (initial seed)
    #Resetting the board
    li a0, 0x000000
    li a1, 0 #x
    li a2, 0 #y
    li t4, 8
    Reset:
        beq a2, t4, ENDING #if row number hits end then exit
        Reset1:
            beq a1, t4, continue #if column number hits the end
            jal setLED
            addi a1, a1, 1
            j Reset1
        continue:
        addi a2, a2, 1
        li a1, 0
        j Reset
    ENDING:
    
    #CHARACTER COORDS -------------------------------------------------
    #character y
    jal bigRand #run the funtion to generate a random number to character to a0
    mv t1, a0 #move the number into t1
    
    li t2, 0 #checker variable for loop
    loop:
        bne t1, t2, END #if random number != 0 then leave
        jal bigRand
        mv t1, a0
        j loop 
    END:   
    la a2, character #load the address of the character
    sb t1, 0(a2) #store the byte of the number into first byte of character
    
    #character x
    jal bigRand #run the funtion to generate a random number to character
    mv t3, a0 #move the number into t3
    li t2, 0 #checker variable for loop
    loop2:
        bne t3, t2, END2 #if random number != 0 then leave
        jal bigRand
        mv t3, a0
        j loop2
    END2:   
    la a2, character
    sb t3, 1(a2)   
    
    #BOX COORDS -----------------------------------------------------
    
    #box y
    jal bigRand #run the funtion to generate a random number
    mv t1, a0 #move the number into t1
    la a3, character #load the address for the character coords
    lb t4, 0(a3) #store the byte of the y coord of character in t4
    li t2, 0 #checker variables for loop
    li t6, 1
    li a5, 6
    whileLoopY: 
        bne t1, t4, loopIfIllegal #if ychar != ybox then check if box = 0
        jal bigRand
        mv t1, a0
        j whileLoopY
    loopIfIllegal:
        bne t1, t2, ONEY #if random number != 0 then check if 1
        jal bigRand
        mv t1, a0
        j whileLoopY #if rand number = 0, then start from the beginning again
    ONEY:
        bne t1, t6, SIXY #if random number != 1 then check for 6
        jal bigRand
        mv t1, a0
        j whileLoopY #if rand number = 1, then start from the beginning again
    SIXY:
        bne t1, a5, END3 #if random number != 6 then leave
        addi t1, t1, -1
        j END3
    END3:   
    la a2, box #load the address of the character
    sb t1, 0(a2) #store the byte of the number into first byte of character
    
    #box x
    jal bigRand #run the funtion to generate a random number to character
    mv t3, a0 #move the number into t3
    li t2, 0 #checker variable for loop
    loop4:
        bne t3, t2, ONEX #if random number != 0 then check for 1
        jal bigRand
        mv t3, a0
        j loop4
    ONEX:
        bne t3, t6, SIXX 
        jal bigRand
        mv t3, a0
        j loop4
    SIXX:
        bne t3, a5, END4
        addi t3, t3, -1
        j END4
    END4:   
    la a2, box #load the address of the character
    sb t3, 1(a2) #store the byte of the number into first byte of character 
    #TARGET COORDS -----------------------------------------------------
    #target y
    jal bigRand #run the funtion to generate a random number to character to a0
    mv t1, a0 #move the number into t1
    la a3, character #load the address for the character coords
    lb t4, 0(a3) #store the byte of the y coord of character in t4
    li t2, 0 #checker variable for loop
    whileLoopY2: 
        bne t1, t4, loopIfZero2 #if x character != x box then check if box = 0
        jal bigRand
        mv t1, a0
        j whileLoopY2
    loopIfZero2:
        bne t1, t2, END5 #if random number != 0 then leave
        jal bigRand
        mv t1, a0
        j whileLoopY2 #if rand number = 0, then start from the beginning again
    END5:   
    la a2, target #load the address of the character
    sb t1, 0(a2) #store the byte of the number into first byte of character
    #target x
    jal bigRand #run the funtion to generate a random number to character to a0
    mv t1, a0 #move the number into t1
    la a3, box #load the address for the box coords
    lb t4, 1(a3) #store the byte of the y coord of character in t4
    li t2, 0 #checker variable for loop
    whileLoopY3: 
        bne t1, t4, loopIfZero3 #if x character != x box then check if box = 0
        jal bigRand
        mv t1, a0
        j whileLoopY3
    loopIfZero3:
        bne t1, t2, END6 #if random number != 0 then leave
        jal bigRand
        mv t1, a0
        j whileLoopY3 #if rand number = 0, then start from the beginning again
    END6:   
    la a2, target #load the address of the character
    sb t1, 1(a2) #store the byte of the number into first byte of character
    
    #WALL LEDS (RED) --------------------------------------------
    # first row 
    li a0, 0xFF0000 #red color
    li a1, 0 # x coord
    li a2, 0 # y coord
    li t3, 8 # checker for end of first row
    wallLoop1:
        beq a1, t3, ENDW1 #check if we are at end of loop
        jal setLED
        addi a1, a1, 1
        j wallLoop1
    ENDW1:
    # last row 
    li a0, 0xFF0000 #red color
    li a1, 0 # x coord
    li a2, 7 # y coord
    li t3, 8 # checker for end of first row
    wallLoop2:
        beq a1, t3, ENDW2 #check if we are at end of loop
        jal setLED
        addi a1, a1, 1
        j wallLoop2
    ENDW2:
    #left wall
    li a0, 0xFF0000 #red color
    li a1, 0 # x coord
    li a2, 0 # y coord
    li t3, 8 # checker for end of left column
    wallLoop3:
        beq a2, t3, ENDW3 #check if we are at end of loop
        jal setLED
        addi a2, a2, 1
        j wallLoop3
    ENDW3:
    #right wall
    li a0, 0xFF0000 #red color
    li a1, 7 # x coord
    li a2, 0 # y coord
    li t4, 8 # checker for end of left column
    wallLoop4:
        beq a2, t4, ENDW4 #check if we are at end of loop
        jal setLED
        addi a2, a2, 1
        j wallLoop4
    ENDW4:
    #PLAYER STARTING (BLUE) ------------------------------------
    la t1, character
    li a0, 0x0000FF
    lb a1, 1(t1)
    lb a2, 0(t1)
    jal setLED
    #BOX STARTING (PURPLE) ------------------------------------
    la t1, box
    li a0, 0x800080
    lb a1, 1(t1)
    lb a2, 0(t1)
    jal setLED
    #TARGET STARTING (GREEN) ------------------------------------
    la t1, target
    li a0, 0x00FF00
    lb a1, 1(t1)
    lb a2, 0(t1)
    jal setLED
    
    li x22, 0
    GAME:
        jal pollDpad #ask for Dpad input
        la x29, character # load address of character coords into x1
        #DOWN MOVEMENT ----------------------------------------------
        li t5, 1 #down movement checker variable
        DOWN:
            bne a0, t5, skip1 #if its not down input then skip
            lb x2, 0(x29) #y coord of character into x2
            lb x3, 1(x29) #x coord of character into x3
            mv x4, x2 #copy y coord of char to x4
            addi x4, x4, 1 #ychar+1
            mv x15, x4
            li x5, 7 #edge checker
            beq x4, x5, invalid #if char y+1 = 7 then no move
            la x6, box #store address to box in x6
            lb x7, 0(x6) # ybox
            lb x8, 1(x6) # xbox
            mv x9, x7 #copy ybox to x9
            addi x9, x9, 1 #ybox + 1
            mv x16, x9
            bne x8, x3, CMOVE #if xbox != xchar
            bne x4, x7, CMOVE #if ybox != ychar+1
            beq x9, x5, invalid #if ybox+1 = 7
            #changing both char and box coords
            sb x4, 0(x29) #store ychar+1 into ychar
            sb x9, 0(x6) #store ybox+1 into ybox
            #set old location to black (clear)
            li a0, 0x000000
            lb a1, 1(x29)
            mv a2, x2
            jal setLED
            # char to new spot
            li a0, 0x0000FF
            lb a1, 1(x29)
            lb a2, 0(x29)
            jal setLED
            #box move
            la x20, box
            li a0, 0x800080
            lb a1, 1(x20)
            lb a2, 0(x20)
            jal setLED
            j skip1
            invalid:
                li a7, 4
                la a0, invalidMove
                ecall
                j skip1
            CMOVE:
                la x29, character
                sb x4, 0(x29) #store ybox (space in front of char) into ychar
                li a0, 0x000000
                lb a1, 1(x29)
                mv a2, x2
                jal setLED
                la x29, character
                li a0, 0x0000FF
                lb a1, 1(x29)
                lb a2, 0(x29)
                jal setLED
                li x18, 1
                beq x22, x18, CAN
                li x22, 0                  
        skip1:
            
        #RIGHT MOVEMENT ----------------------------------------------
        li t5, 3 #RIGHT movement checker variable
        RIGHT:
            bne a0, t5, skip2 #if its not down input then skip
            lb x2, 0(x29) #y coord of character into x2
            lb x3, 1(x29) #x coord of character into x3
            mv x4, x3 #copy x coord of char to x4
            addi x4, x4, 1 #xchar+1
            li x5, 7 #edge checker
            beq x4, x5, invalid2 #if char x+1 = 7 then no move
            la x6, box #store address to box in x6
            lb x7, 0(x6) # ybox
            lb x8, 1(x6) # xbox
            mv x9, x8 #copy xbox to x9
            addi x9, x9, 1 #xbox + 1
            bne x7, x2, CMOVE2 #if ybox != ychar
            bne x8, x4, CMOVE2 #if xbox != xchar+1
            beq x9, x5, invalid2 #if xbox+1 = 7
            #changing both char and box coords
            sb x8, 1(x29) #store xbox into xchar
            sb x9, 1(x6) #store xbox+1 into xbox
            #set old location to black (clear)
            la x1, character
            li a0, 0x000000
            mv a1, x3
            lb a2, 0(x29)
            jal setLED
            # switch to new spot
            li a0, 0x0000FF
            lb a1, 1(x29)
            lb a2, 0(x29)
            jal setLED
            #box move
            la x21, box
            li a0, 0x800080
            lb a1, 1(x21)
            lb a2, 0(x21)
            jal setLED
            j skip2
            invalid2:
                li a7, 4
                la a0, invalidMove
                ecall
                j skip2
            CMOVE2:
                la x29, character
                sb x4, 1(x29) #store xbox (space in front of char) into xchar
                li a0, 0x000000
                mv a1, x3
                lb a2, 0(x29)
                jal setLED
                la x29, character
                li a0, 0x0000FF
                lb a1, 1(x29)
                lb a2, 0(x29)
                jal setLED
                li x18, 1
                beq x22, x18, CAN      
                li x22, 0              
        skip2:
        #UP MOVEMENT ----------------------------------------------
        li t5, 0 #UP movement checker variable
        UP:
            bne a0, t5, skip3 #if its not down input then skip
            lb x2, 0(x29) #y coord of character into x2
            lb x3, 1(x29) #x coord of character into x3
            mv x4, x2 #copy y coord of char to x4
            li x12, 1
            sub x4, x4, x12 #ychar-1
            mv x15, x4   
            li x5, 0 #edge checker
            beq x4, x5, RESTART #if char y-1 = 0 then no move
            la x6, box #store address to box in x6
            lb x7, 0(x6) # ybox
            lb x8, 1(x6) # xbox
            mv x9, x7 #copy ybox to x9
            sub x9, x9, x12 #ybox-1
            mv x16, x9
            bne x8, x3, CMOVE3 #if xbox != xchar
            bne x4, x7, CMOVE3 #if ybox != ychar+1
            beq x9, x5, skip3 #if ybox-1 = 0
            #changing both char and box coords
            sb x4, 0(x29) #store ychar-1 into ychar
            sb x9, 0(x6) #store ybox-1 into ybox
            #set old location to black (clear)
            li a0, 0x000000
            lb a1, 1(x29)
            mv a2, x2
            jal setLED
            # char to new spot
            li a0, 0x0000FF
            lb a1, 1(x29)
            lb a2, 0(x29)
            jal setLED
            #box move
            la x23, box
            li a0, 0x800080
            lb a1, 1(x23)
            lb a2, 0(x23)
            jal setLED
            CMOVE3:
                la x29, character
                sb x4, 0(x29) #store ybox (space in front of char) into ychar
                li a0, 0x000000
                lb a1, 1(x29)
                mv a2, x2
                jal setLED
                la x29, character
                li a0, 0x0000FF
                lb a1, 1(x29)
                lb a2, 0(x29)
                jal setLED
                j skip3
            RESTART:
                addi x22, x22, 1 #add 1 to restart counter if player hits top edge
                li x18, 1
                bne  x22, x18, skip3
                li a7, 4
                la a0, restartQuestion
                ecall                      
        skip3:   
        #LEFT MOVEMENT ----------------------------------------------
        li t5, 2 #RIGHT movement checker variable
        LEFT:
            bne a0, t5, skip4 #if its not down input then skip
            lb x2, 0(x29) #y coord of character into x2
            lb x3, 1(x29) #x coord of character into x3
            mv x4, x3 #copy x coord of char to x4
            li x12, 1
            sub x4, x4, x12 #xchar-1
            li x5, 0 #edge checker
            beq x4, x5, invalid3 #if char x+1 = 7 then no move
            la x6, box #store address to box in x6
            lb x7, 0(x6) # ybox
            lb x8, 1(x6) # xbox
            mv x9, x8 #copy xbox to x9
            sub x9, x9, x12 #xbox-1
            bne x7, x2, CMOVE4 #if ybox != ychar
            bne x8, x4, CMOVE4 #if xbox != xchar-1
            beq x9, x5, invalid3 #if xbox-1 = 0
            #changing both char and box coords
            sb x8, 1(x29) #store xbox into xchar
            sb x9, 1(x6) #store xbox-1 into xbox
            #set old location to black (clear)
            la x29, character
            li a0, 0x000000
            mv a1, x3
            lb a2, 0(x29)
            jal setLED
            # redraw character to new spot
            li a0, 0x0000FF
            lb a1, 1(x29)
            lb a2, 0(x29)
            jal setLED
            #box move
            la x24, box
            li a0, 0x800080
            lb a1, 1(x24)
            lb a2, 0(x24)
            jal setLED
            j skip4
            invalid3:
                li a7, 4
                la a0, invalidMove
                ecall
                j skip4
            CMOVE4:
                la x1, character
                sb x4, 1(x29) #store xbox (space in front of char) into xchar
                li a0, 0x000000
                mv a1, x3
                lb a2, 0(x29)
                jal setLED
                la x29, character
                li a0, 0x0000FF
                lb a1, 1(x29)
                lb a2, 0(x29)
                jal setLED
                li x18, 1
                beq x22, x18, CAN      
                li x22, 0
        skip4:
        
        la x12, character
        lb x13, 1(x12) #xchar
        lb x14 0(x12) #ychar
        la x15, target
        lb x16, 1(x15) #xtarget
        lb x17, 0(x15) #ytarget
        beq x16, x12, BYE #if xchar != xtarget then skip
        beq x17, x14, BYE #if ychar != ytarget then skip
        li a0, 0x00FF00
        mv a1, x16
        mv a2, x17
        jal setLED
        BYE: 
        li x23, 2 #check if x22 = 2 (player wants to restart)
        beq x22, x23, RES
        la x25, box
        lb x26, 1(x25) #xbox
        lb x27, 0(x25) #ybox
        la x28, target
        lb x29, 1(x28) #xtarget
        lb x30, 0(x28) #ytarget
        bne x26, x29, GAME #check if target coords = box coords
        bne x27, x30, GAME #if not then keep playing
        li a7, 4
        la a0, victory #send victory message
        ecall
        j R #return to reset
        
        RES:
            j R #restarting if x22 = 2
        CAN:
            li, x22, 0 #if x22 = 1 and we cancel
            li a7, 4
            la a0, restartCancel
            ecall
            j GAME
exit:
    li a7, 10
    ecall
    
    
# --- HELPER FUNCTIONS ---
# Feel free to use (or modify) them however you see fit

#psudeo random number generator.
bigRand:
    la a0, seed
    lw x9, 0(a0) #move the seed into x1
    li, x2, 6223 # a value for algorithm
    li x3, 21212 # c value for algorithm
    li x4, 93 #m value for algorithm
    mul x9, x9, x2 # multiply seed by a
    add x9, x9, x3 # add c to the seed
    remu x9, x9, x4 #mod calculated value by 7 
    sw x9, 0(a0) #move calculated value into seed variable
    li x22, 7
    remu x9, x9, x22 #mod calculated value by 7 
    mv a0, x9 #move final value to a0
    jr ra #return a0
    
# Takes in a number in a0, and returns a (sort of) (okay no really) random 
# number from 0 to this number (exclusive)
rand:
    mv t0, a0
    li a7, 30
    ecall
    remu a0, a0, t0
    jr ra
    
# Takes in an RGB color in a0, an x-coordinate in a1, and a y-coordinate
# in a2. Then it sets the led at (x, y) to the given color.
setLED:
    li t1, LED_MATRIX_0_WIDTH
    mul t0, a2, t1
    add t0, t0, a1
    li t1, 4
    mul t0, t0, t1
    li t1, LED_MATRIX_0_BASE
    add t0, t1, t0
    sw a0, (0)t0
    jr ra
    
# Polls the d-pad input until a button is pressed, then returns a number
# representing the button that was pressed in a0.
# The possible return values are:
# 0: UP
# 1: DOWN
# 2: LEFT
# 3: RIGHT
pollDpad:
    mv a0, zero
    li t1, 4
pollLoop:
    bge a0, t1, pollLoopEnd
    li t2, D_PAD_0_BASE
    slli t3, a0, 2
    add t2, t2, t3
    lw t3, (0)t2
    bnez t3, pollRelease
    addi a0, a0, 1
    j pollLoop
pollLoopEnd:
    j pollDpad
pollRelease:
    lw t3, (0)t2
    bnez t3, pollRelease
pollExit:
    jr ra