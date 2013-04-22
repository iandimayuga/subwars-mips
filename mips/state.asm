# state.asm
# Submarine state and knowledge

.data
# Submarine state structure (52 bytes)
# 0:    (4) int size = 52
# 4:    (4) int player
# 8:    (8) vector position
# 16:   (8) vector rotation
# 24:   (4) flag move
# 28:   (4) flag turn
# 32:   (4) flag ping
# 36:   (4) flag fire
# 40:   (4) flag bounds
# 44:   (4) flag collide
# 48:   (4) flag alive

submarine_1_prototype:
    .word   52, 1, 0,0, 1,0, 0, 0, 0, 0, 0, 0, 1

submarine_2_prototype:
    .word   52, 2, 7,7, -1,0, 0, 0, 0, 0, 0, 0, 1

.text

# Set phase-specific flags back to zero in preparation for the next command evaluation
reset_flags_function: # a0 -> submarine struct
    sw $zero, 24($a0) # move = false
    sw $zero, 28($a0) # turn = false
    sw $zero, 32($a0) # ping = false
    sw $zero, 36($a0) # fire = false
    sw $zero, 40($a0) # bounds = false
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
        j sub_move_function_return

    sub_move_function_outbounds:
        # set sub's bounds flag to true and do not change position
        addi $t0, $zero, 1
        sw $t0, 40($s0) # bounds

    sub_move_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

check_collision_function:
    # void check_collision(submarine* A, submarine* B)
    # {
    #     if (equals(A->position, B->position)) {
    #         // A and B occupy the same point in space
    #         A->collide = B->collide = true;
    #     } else if (A->move && B->move) {
    #         // check to see if they may have passed through each other (if they have both moved and are facing away from each other)
    #
    #         // subtract B from A
    #         vector displacement = subtract(A->position, B->position);
    #
    #         if (equals(A->rotation, displacement) && equals(B->rotation, mult(displacement, -1)))
    #         {
    #             // A and B passed through each other this turn
    #             A->collide = B->collide = true;
    #         }
    #     }
    #
    #     // Any collision results in death of both parties
    #     if (A->collide || B->collide) A->alive = B->alive = false;
    # }
    jr $ra

sub_fire_function:
    # void sub_fire(submarine* sub, submarine* target){
    #     sub->fire = true;
    #     if (collide(sub->position, sub->rotation, target->position)) {
    #         target->alive = false;
    #     }
    # }
    jr $ra

sub_rotate_left_function:
    # void sub_rotate_left(submarine* sub) {
    #     sub->turn = true;
    #     sub->rotation = left(sub->rotation);
    # }
    jr $ra

sub_rotate_right_function:
    # void sub_rotate_right(submarine* sub) {
    #     sub->turn = true;
    #     sub->rotation = right(sub->rotation);
    # }
    jr $ra

sub_ping_function:
    # void sub_ping(submarine* sub) {
    #     sub->ping = true;
    # }
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
