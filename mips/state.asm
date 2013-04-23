# state.asm
# Submarine state and knowledge

.data
# Submarine state structure (56 bytes)
# 0:    (4) int size = 56
# 4:    (4) int player
# 8:    (8) vector position
# 16:   (8) vector rotation
# 24:   (4) flag move
# 28:   (4) flag reverse
# 32:   (4) flag turn
# 36:   (4) flag ping
# 40:   (4) flag fire
# 44:   (4) flag bounds
# 48:   (4) flag collide
# 52:   (4) flag alive

submarine_1_prototype:
    .word   52, 1, 0,0, 1,0, 0, 0, 0, 0, 0, 0, 0, 1

submarine_2_prototype:
    .word   52, 2, 7,7, -1,0, 0, 0, 0, 0, 0, 0, 0, 1

.text

# Set phase-specific flags back to zero in preparation for the next command evaluation
reset_flags_function: # a0 -> submarine struct
    sw $zero, 24($a0) # move = false
    sw $zero, 28($a0) # reverse = false
    sw $zero, 32($a0) # turn = false
    sw $zero, 36($a0) # ping = false
    sw $zero, 40($a0) # fire = false
    sw $zero, 44($a0) # bounds = false
    jr $ra

# Move the sub forwards or backwards
sub_move_function: # a0 -> submarine struct; a1 = forward boolean
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # save parameters to s registers
    add $s0, $a0, $zero
    add $s1, $a1, $zero

    # find resultant vector of motion
    lw $a0, 8($s0) # position.x
    lw $a1, 12($s0) # position.y
    lw $a2, 16($s0) # rotation.x
    lw $a3, 20($s0) # rotation.y

    # check direction
    beq $s1, $zero, sub_move_function_backward

    # add the vectors to move forward
    jal add_function
    j sub_move_function_resultant

    sub_move_function_backward:
        # set sub's reverse flag
        addi $t0, $zero, 1
        sw $t0, 28($s0) # reverse flag

        # subtract the vectors to move backward
        jal subtract_function

    sub_move_function_resultant:
        # save resultant and move to bounds check
        add $t0, $v0, $zero # resultant.x
        add $t1, $v1, $zero # resultant.y
        j sub_move_function_boundscheck

    sub_move_function_boundscheck:
        # ensure sub stays within bounds
        slti $t2, $t0, 0 # check if x < 0
        bne $t2, $zero, sub_move_function_outbounds
        slti $t2, $t0, 8 # check if x < 8
        beq $t2, $zero, sub_move_function_outbounds
        slti $t2, $t1, 0 # check if y < 0
        bne $t2, $zero, sub_move_function_outbounds
        slti $t2, $t1, 8 # check if y < 8
        beq $t2, $zero, sub_move_function_outbounds

    # set sub's position to valid resultant
    sw $t0, 8($s0) # position.x
    sw $t1, 12($s0) # position.y

    # set sub's move flag
    addi $t0, $zero, 1
    sw $t0, 24($s0) # move flag

    j sub_move_function_return

    sub_move_function_outbounds:
        # set sub's bounds flag to true and do not change position
        addi $t0, $zero, 1
        sw $t0, 44($s0) # bounds flag

    sub_move_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

# Check if collision has occurred between submarines and sink them if necessary
check_collision_function: # a0 -> submarine struct; a1 -> submarine struct
    addi $sp, $sp, -20 # allocate 5 words on stack: ra, s0-3
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)

    # save sub pointers to s registers
    add $s0, $a0, $zero
    add $s1, $a1, $zero

    # check to see if they occupy the same position in space
    lw $a0, 8($s0) # A->position.x
    lw $a1, 12($s0) # A->position.y
    lw $a2, 8($s1) # B->position.x
    lw $a3, 12($s1) # B->position.y
    jal equals_function

    # if positions are equal, there is a collision
    bne $v0, $zero, check_collision_function_true

    # check to see if they pass through each other
    # (i.e. they have both moved and are facing away from each other)
    lw $t0, 24($s0) # A->move flag
    lw $t1, 24($s1) # B->move flag
    and $t0, $t0, $t1

    # if either has not moved, they can't have passed through each other
    beq $t0, $zero, check_collision_function_return

    # find the target displacement for a collision
    lw $a0, 8($s0) # A->position.x
    lw $a1, 12($s0) # A->position.y
    lw $a2, 8($s1) # B->position.x
    lw $a3, 12($s1) # B->position.y
    jal subtract_function

    add $s2, $v0, $zero # displacement.x
    add $s3, $v1, $zero # displacement.y

    # determine A's motion direction
    lw $a0, 16($s0) # A->rotation.x
    lw $a1, 20($s0) # A->rotation.y

    # check if A moved backwards
    lw $t0, 28($s0) # A->reverse flag
    beq $t0, $zero, check_collision_function_A

    # A reversed, so reflect that in its motion vector
    addi $a2, $zero, -1
    jal mult_function

    add $a0, $v0, $zero # motionA.x
    add $a1, $v1, $zero # motionA.y

    check_collision_function_A:
        # check if A's motion originated from B's current position
        add $a2, $s2, $zero # displacement.x
        add $a3, $s3, $zero # displacement.y
        jal equals_function

        # if it did not, then there was no collision
        beq $v0, $zero, check_collision_function_return

    # determine B's motion direction
    lw $a0, 16($s1) # B->rotation.x
    lw $a1, 20($s1) # B->rotation.y

    # check if B moved forwards
    lw $t0, 28($s1) # B->reverse flag
    bne $t0, $zero, check_collision_function_B

    # B did not reverse,
    # but we must reverse its motion vector because B's target displacement is in the other direction
    addi $a2, $zero, -1
    jal mult_function

    add $a0, $v0, $zero # motionB.x
    add $a1, $v1, $zero # motionB.y

    check_collision_function_B:
        # check if B's motion originated from A's current position
        add $a2, $s2, $zero # displacement.x
        add $a3, $s3, $zero # displacement.y
        jal equals_function

        # if it did not, then there was no collision
        beq $v0, $zero, check_collision_function_return

    check_collision_function_true:
        addi $t0, $zero, 1
        sw $t0, 48($s0) # A->collide = true
        sw $t0, 48($s1) # B->collide = true
        sw $zero, 52($s0) # A->alive = false
        sw $zero, 52($s0) # B->alive = false

    check_collision_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        addi $sp, $sp, 20 # pop stack frame
        jr $ra

# fire the submarine's torpedo and check for hit, sinking target if necessary
sub_fire_function: # a0 -> player submarine struct; a1 -> target submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)

    # save submarine pointers to s registers
    add $s0, $a0, $zero
    add $s1, $a1, $zero

    # set sub->fire to true
    addi $t0, $zero, 1
    sw $t0, 40($s0) # fire flag

    # raytrace check for torpedo hit
    addi $a0, $s0, 8 # &(sub->position)
    addi $a1, $s0, 16 # &(sub->rotation)
    addi $a2, $s1, 8 # &(target->position)
    jal collide_function

    # if no collision, return
    beq $v0, $zero, sub_fire_function_return

    sub_fire_function_hit:
        # set target's alive flag to false
        sw $zero, 52($s1) # alive flag

    sub_fire_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

# rotate sub 90 degrees counterclockwise
sub_rotate_left_function: # a0 -> submarine struct
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    # save submarine pointer to s register
    add $s0, $a0, $zero

    # pass rotation vector
    lw $a0, 16($s0) # rotation.x
    lw $a1, 20($s0) # rotation.y
    jal left_function

    # set turn flag
    addi $t0, $zero, 1
    sw $t0, 32($s0) # turn flag

    # store new rotation vector
    sw $v0, 16($s0) # rotation.x
    sw $v1, 20($s0) # rotation.y

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8 # pop stack frame
    jr $ra

# rotate sub 90 degrees clockwise
sub_rotate_right_function: # a0 -> submarine struct
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)

    # save submarine pointer to s register
    add $s0, $a0, $zero

    # pass rotation vector
    lw $a0, 16($s0) # rotation.x
    lw $a1, 20($s0) # rotation.y
    jal right_function

    # set turn flag
    addi $t0, $zero, 1
    sw $t0, 32($s0) # turn flag

    # store new rotation vector
    sw $v0, 16($s0) # rotation.x
    sw $v1, 20($s0) # rotation.y

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8 # pop stack frame
    jr $ra

# set ping flag to true
sub_ping_function: # a0 -> submarine struct
    # set ping flag
    addi $t0, $zero, 1
    sw $t0, 36($a0) # ping flag
    jr $ra

evaluate_motion_function:
    # void evaluate_motion(submarine* sub, int command)
    # {
    #     switch (command)
    #     {
    #         case 0:
    #             sub_move(sub, true);
    #             break;
    #         case 1:
    #             sub_move(sub, false);
    #             break;
    #         case 2:
    #             sub_rotate_left(sub);
    #             break;
    #         case 3:
    #             sub_rotate_right(sub);
    #             break;
    #     }
    # }
    jr $ra

evaluate_action_function:
    # void evaluate_action(submarine* sub, submarine* enemy, int command)
    # {
    #     switch (command)
    #     {
    #         case 4:
    #             sub_ping(sub);
    #             break;
    #         case 5:
    #             sub_fire(sub, enemy);
    #             break;
    #     }
    # }
    jr $ra
