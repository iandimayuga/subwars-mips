# main.asm
# Entry point for the game
.data
intro_art:
    .asciiz "
                                  _
                                 |  `-._
                       .---._    |       `-.
                      /       `-.|   _______|
                     |               `-.____`-.
           __        |         |`-.         |
          |  `-._    |          `-.|         `-._
          `-._``-._   \                           `-._
               `-. ``-.`-._                            `-.
                              __| |  | _ | |    |    | _ \ __|
                             __ | |  | _ { |  \ |  / |   /__ |
                             ___|____|___|__/`__|_,-_|_\_\___|
\n\n"
intro_string:
    .asciiz "Welcome to SUBWARS!!\n\nYou are Player 1 and Player 2, the top two Nuclear Submarine commanders in the Soviet Navy.\nIt is the year 1958, and Secretary Khrushchev has ordered a round of War Games.\nYou have both surfaced in the Atlantic Ocean just off the Ivory Coast.\nYour orders are to find and sink your comrade's submarine.\n\nThis is a turn-based game based on the concept of limited information.\nEach phase, Player 1 will give orders, followed by Player 2.\nThe phase will then commence, and when actions have been taken, the next phase will begin.\nYou must stay within an 8x8 grid from 0 N 0 E to 7 N 7 E.\nExplore the area and try to listen for your enemy.\nIf they use their engines while in front of you, you may detect them.\nTorpedo fire and pings can be heard by everyone.\nIf you are pointing directly at your enemy and fire a torpedo, you will be victorious!!\n\n"
map_string:
    .asciiz "Starting conditions are indicated below.\n
   0 E                         7 E
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |<P2| 7 N
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |   |
  +---+---+---+---+---+---+---+---+
  |   |   |   |   |   |   |   |   |
^ +---+---+---+---+---+---+---+---+
| |P1>|   |   |   |   |   |   |   | 0 N
N +---+---+---+---+---+---+---+---+
  E--->\n\n"

begin_string:
    .asciiz "PRESS ENTER TO SUBMERGE\n"

.text

main:
    # clear the console and print the welcome screen
    la $a0, console_clear_string
    jal print_string_function
    la $a0, intro_art
    jal print_string_function
    la $a0, intro_string
    jal print_string_function
    la $a0, map_string
    jal print_string_function
    la $a0, begin_string
    jal print_string_function

    # Wait for user to press enter
    li $v0, 5
    syscall

    # get the two structs and save them in s0 & s1
    la $s0, submarine_1_prototype
    la $s1, submarine_2_prototype

    # initialize loop counter
    li $s4, 1

main_loop:
    # if either sub has alive set to 0 then it is dead and the loop should end
    lw $t0, 52($s0)
    beq $t0, $zero, end_game
    lw $t0, 52($s1)
    beq $t0, $zero, end_game

    # generate alerts for player 1
    move $a0, $s0
    move $a1, $s1
    move $a2, $s4
    jal generate_alerts_function

    # get player 1 input and store it in s2
    li $v0, 5
    syscall
    move $s2, $v0

    # generate alerts for player 2
    move $a0, $s1
    move $a1, $s0
    move $a2, $s4
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

    # increment and loop
    addi $s4, $s4, 1
    j main_loop

end_game:
    move $a0, $s0
    move $a1, $s1
    jal generate_endgame_function 

    li $v0, 8
    syscall

    li $v0, 10
    syscall
