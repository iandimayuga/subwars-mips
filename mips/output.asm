# output.c
# Output generation based on player knowledge

.data

status_alert_string:
    .asciiz "Captain! Our current position is %d N %d E, facing %s.\n"
motion_alert_string:
    .asciiz "Sonar alerts enemy sub in motion somewhere ahead, within %d units!\n"
pinger_alert_string:
    .asciiz "Sonar has determined enemy position at %d N %d E. However, the enemy has heard the ping as well!\n"
pingee_alert_string:
    .asciiz "A ping has been detected originating at %d N %d E!\n"
fire_ahead_alert_string:
    .asciiz "Torpedo launch detected originating ahead of us!\n"
fire_behind_alert_string:
    .asciiz "Torpedo launch detected originating behind us!\n"
fire_toward_alert_string:
    .asciiz "Sonar has confirmed torpedo was launched toward us but missed!\n"
fire_away_alert_string:
    .asciiz "It was launched in entirely the wrong direction!\n"
bounds_alert_string:
    .asciiz "Our orders prohibit us from moving that way. We must go a different way!\n"

endgame_notify_string:
    .asciiz "ENDGAME\n\n"
collide_notify_string:
    .asciiz "Both subs have collided!!\n"
hit_notify_string:
    .asciiz "Player %d's torpedo has found its target!!\n"
death_notify_string:
    .asciiz "Player %d's submarine has been sunk at %d N %d E, facing %s!\n"
victor_notify_string:
    .asciiz "\nPlayer %d is victorious! Praise the motherland!\n"
draw_notify_string:
    .asciiz "\nThere was no victory this day.\n"

console_clear_string:
    .asciiz "\e[1;1H\e[2J"

player_ready_string_0:
    .asciiz "PLAYER "
player_ready_string_1:
    .asciiz " PRESS ENTER TO CONTINUE\n"

player_menu_string:
    .asciiz "\n0: Full Ahead\n1: Full Astern\n2: Turn to Port\n3: Turn to Starboard\n4: Ping\n5: Fire Ahead\n6: Do Nothing\n"
player_prompt_string:
    .asciiz "\nWhat are your orders, Captain? "

.text

print_string_function: # a0 -> string to print
    li $v0, 4 # print string
    syscall
    jr $ra

# prints an alternation of strings and integers from the stack
# each word in the stack frame is either a string pointer or an integer, starting with a string
printf_function: # a0 = arglist size in bytes; sp -> first string address; sp + 4 -> first integer
    add $t0, $sp, $zero # save stack pointer

    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save start pointer
    add $s0, $t0, $zero # current byte (original stack pointer)
    # save arglist end pointer
    add $s1, $s0, $a0 # start byte + arglist size

    printf_function_loop:
        # if we have reached the end, return
        beq $s0, $s1, printf_function_return

        lw $a0, 0($s0)
        li $v0, 4 # print string
        syscall

        # increment current byte
        addi $s0, $s0, 4

        # if we have reached the end, return
        beq $s0, $s1, printf_function_return

        lw $a0, 0($s0)
        li $v0, 1 # print integer
        syscall

        # increment current byte
        addi $s0, $s0, 4

        # loop
        j printf_function_loop

    printf_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

generate_alerts_function: # a0 -> submarine struct; a1 -> enemy submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s registers
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # prompt player for ready
    add $a0, $s0, $zero # player sub
    jal get_ready_function

    # print informational graphics
    add $a0, $s0, $zero # player sub
    jal alert_graphic_function

    # print current position and direction
    add $a0, $s0, $zero # player sub
    jal alert_status_function

    # alert if tried to move out of bounds
    add $a0, $s0, $zero # player sub
    jal alert_bounds_function

    # alert if enemy fired last phase
    add $a0, $s0, $zero # player sub
    add $a1, $s1, $zero # enemy sub
    jal alert_fire_function

    # alert if enemy moved or turned within vision last phase
    add $a0, $s0, $zero # player sub
    add $a1, $s1, $zero # enemy sub
    jal alert_motion_function

    # alert if enemy pinged
    add $a0, $s1, $zero # enemy sub
    jal alert_pingee_function

    # alert the results from own ping last phase
    add $a0, $s0, $zero # player sub
    add $a1, $s1, $zero # enemy sub
    jal alert_pinger_function

    # give command menu and prompt for input
    la $a0, player_menu_string
    jal print_string_function
    la $a0, player_prompt_string
    jal print_string_function

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12 # pop stack frame
    jr $ra

generate_endgame_function: # a0 -> submarine struct; a1 -> submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s registers
    add $s0, $a0, $zero # sub A
    add $s1, $a1, $zero # sub B

    # clear the console for endgame
    la $a0, console_clear_string
    jal print_string_function
    la $a0, endgame_notify_string
    jal print_string_function

    # notify if either sub hit the other with a torpedo
    add $a0, $s0, $zero # sub A
    add $a1, $s1, $zero # sub B
    jal notify_hit_function

    # notify if either sub collided into the other
    add $a0, $s0, $zero # sub A
    add $a1, $s1, $zero # sub B
    jal notify_collide_function

    # show death positions and directions
    add $a0, $s0, $zero # sub A
    jal notify_death_function
    add $a0, $s1, $zero # sub B
    jal notify_death_function

    # congratulate victor, if any
    add $a0, $s0, $zero # sub A
    add $a1, $s1, $zero # sub B
    jal notify_victor_function

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12 # pop stack frame
    jr $ra

get_ready_function: # a0 -> submarine struct
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    # save parameter to s register
    add $s0, $a0, $zero # sub A

    la $a0, console_clear_string
    jal print_string_function

    addi $sp, $sp, -12 # 3 words
    la $t0, player_ready_string_0
    sw $t0, 0($sp)
    li $t1, 4($s0) # player int
    sw $t1, 4($sp)
    la $t0, player_ready_string_1
    sw $t0, 8($sp)

    li $a0, 12
    jal printf_function
    addi $sp, $sp, 12

    li $v0, 8 # receive input
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8 # pop stack frame
    jr $ra

alert_status_function: # a0 -> submarine struct
# void alert_status(submarine sub)
# {
#     char* dir = direction(sub.rotation);
#
#     printf(STATUS_ALERT, sub.position.y, sub.position.x, dir);
# }
    jr $ra

alert_motion_function:
# void alert_motion(submarine sub, submarine enemy)
# {
#     if (enemy.move || enemy.turn)
#     {
#         // subtract player position from enemy position for direction to enemy
#         vector ray = subtract(enemy.position, sub.position);
#
#         // compare direction to enemy with current rotation
#         int prod = dot(ray, sub.rotation);
#
#         // alert if facing enemy in motion (does not detect directly to the side)
#         if (prod > 0 && manhattan_length(ray) <= DETECT_DISTANCE)
#         {
#             printf(MOTION_ALERT, DETECT_DISTANCE);
#         }
#     }
# }
    jr $ra

alert_bounds_function:
# void alert_bounds(submarine sub)
# {
#     if (sub.bounds) printf(BOUNDS_ALERT);
# }
    jr $ra

alert_pinger_function:
# void alert_pinger(submarine sub, submarine enemy)
# {
#     if (sub.ping)
#         printf(PINGER_ALERT, enemy.position.y, enemy.position.x);
# }
    jr $ra

alert_pingee_function:
# void alert_pingee(submarine enemy)
# {
#     if (enemy.ping)
#         printf(PINGEE_ALERT, enemy.position.y, enemy.position.x);
# }
    jr $ra

alert_fire_function:
# void alert_fire(submarine sub, submarine enemy)
# {
#     if (enemy.fire)
#     {
#         // subtract player position from enemy position for direction to enemy
#         vector ray = subtract(enemy.position, sub.position);
#
#         // compare direction to enemy with current rotation
#         int prod = dot(ray, sub.rotation);
#
#         // alert direction to enemy
#         if (prod >= 0)
#         {
#             printf(FIRE_AHEAD_ALERT);
#         } else {
#             printf(FIRE_BEHIND_ALERT);
#         }
#
#         // reverse ray to compare with torpedo launch
#         ray = mult(ray, -1);
#
#         // compare direction from enemy to player against enemy rotation
#         prod = dot(ray, enemy.rotation);
#
#         // alert if torpedo went toward or away from player
#         if (prod > 0)
#         {
#             printf(FIRE_TOWARD_ALERT);
#         } else {
#             printf(FIRE_AWAY_ALERT);
#         }
#     }
# }
    jr $ra

notify_hit_function:
# void notify_hit(submarine A, submarine B)
# {
#     if (!B.alive && A.fire) printf(HIT_NOTIFY, A.player);
#     if (!A.alive && B.fire) printf(HIT_NOTIFY, B.player);
# }
    jr $ra

notify_collide_function:
# void notify_collide(submarine A, submarine B)
# {
#     // notify if either sub collided with the other
#     if (A.collide || B.collide)
#     {
#         printf(COLLIDE_NOTIFY);
#     }
# }
    jr $ra

notify_death_function:
# void notify_death(submarine sub)
# {
#     char* dir = direction(sub.rotation);
#
#     // notify if sub is no longer alive
#     if (!sub.alive) printf(DEATH_NOTIFY, sub.player, sub.position.y, sub.position.x, dir);
# }
    jr $ra

notify_victor_function:
# void notify_victor(submarine A, submarine B)
# {
#     if (A.alive) printf(VICTOR_NOTIFY, A.player);
#     else if (B.alive) printf(VICTOR_NOTIFY, B.player);
#     else printf(DRAW_NOTIFY);
# }
    jr $ra

alert_graphic_function:
# void alert_graphic(submarine sub)
# {
#     printf("%s%s%s%s%s\n", COMPASS_0, COMPASS_1, COMPASS_2, COMPASS_3, COMPASS_4);
#     if (sub.rotation.y > 0) printf("%s%s%s%s%s%s%s%s%s\n",
#         GRAPHIC_NORTH_0,
#         GRAPHIC_NORTH_1,
#         GRAPHIC_NORTH_2,
#         GRAPHIC_NORTH_3,
#         GRAPHIC_NORTH_4,
#         GRAPHIC_NORTH_5,
#         GRAPHIC_NORTH_6,
#         GRAPHIC_NORTH_7,
#         GRAPHIC_NORTH_8);
#     else if (sub.rotation.y < 0) printf("%s%s%s%s%s%s%s%s%s\n",
#         GRAPHIC_SOUTH_0,
#         GRAPHIC_SOUTH_1,
#         GRAPHIC_SOUTH_2,
#         GRAPHIC_SOUTH_3,
#         GRAPHIC_SOUTH_4,
#         GRAPHIC_SOUTH_5,
#         GRAPHIC_SOUTH_6,
#         GRAPHIC_SOUTH_7,
#         GRAPHIC_SOUTH_8);
#     else if (sub.rotation.x > 0) printf("%s%s%s%s%s%s\n",
#         GRAPHIC_EAST_0,
#         GRAPHIC_EAST_1,
#         GRAPHIC_EAST_2,
#         GRAPHIC_EAST_3,
#         GRAPHIC_EAST_4,
#         GRAPHIC_EAST_5);
#     else if (sub.rotation.x < 0) printf("%s%s%s%s%s%s\n",
#         GRAPHIC_WEST_0,
#         GRAPHIC_WEST_1,
#         GRAPHIC_WEST_2,
#         GRAPHIC_WEST_3,
#         GRAPHIC_WEST_4,
#         GRAPHIC_WEST_5);
# }
    jr $ra
