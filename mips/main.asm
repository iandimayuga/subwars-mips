# main.asm
# Entry point for the game
.data
stalin_string:
    .asciiz "Hello World! My name is Joseph Stalin.\nMy submarine fleet has been launched to dominate your MIPS.\n"
enter_to_begin:
    .asciiz "PRESS ENTER TO BEGIN\n"

.text

main:
    # clear the console and print the welcome screen
    la $a0, console_clear_string
    jal print_string_function
    la $a0, stalin_string
    jal print_string_function
    la $a0, enter_to_begin
    jal print_string_function

    #I just chose to skip the loop here and wait for them to press enter
    li $v0, 8
    syscall

    # get the two structs and save them in s0 & s1
    la $s0, submarine_1_prototype
    la $s1, submarine_2_prototype

main_loop:
    # if either sub has alive set to 0 then it is dead and the loop should end
    lw $t0, 52($s0)
    beq $t0, $zero, end_game
    lw $t0, 52($s1)
    beq $t0, $zero, end_game

    # generate alerts for player 1
    move $a0, $s0
    move $a1, $s1
    jal generate_alerts_function

    # get player 1 input and store it in s2
    li $v0, 5
    syscall
    move $s2, $v0

    # generate alerts for player 2
    move $a0, $s1
    move $a1, $s0
    jal generate_alerts_function

    # get player 2 input and store it in s3
    li $v0, 5
    syscall
    move $s3, $v0
    
    # reset the flags for sub 2 and then 1
    move $a0, $s0
    jal reset_flags_function
    move $a0, $s1
    jal reset_flags_function

    # evaluate motion for both subs
    move $a0, $s0
    move $a1, $s2
    jal evaluate_motion_function
    # now load in sub 2 and the action
    move $a0, $s1
    move $a1, $s3
    jal evaluate_motion_function

    # check the sub collision
    move $a0, $s0
    move $a1, $s1
    jal check_collision_function

    # evaluate action
    move $a0, $s0
    move $a1, $s1
    move $a2, $s2
    jal evaluate_action_function
    # evaluate action for sub 2 and action
    move $a0, $s1
    move $a1, $s0
    move $a2, $s3
    jal evaluate_action_function

    j main_loop

end_game:
    move $a0, $s0
    move $a1, $s1
    jal generate_endgame_function 

    li $v0, 8
    syscall

    li $v0, 10
    syscall
