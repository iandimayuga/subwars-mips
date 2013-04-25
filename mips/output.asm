# output.c
# Output generation based on player knowledge

.data

status_alert_string_0:
    .asciiz "Captain! Our current position is "
status_alert_string_1:
    .asciiz " N "
status_alert_string_2:
    .asciiz " E, facing "
status_alert_string_3:
    .asciiz ".\n"

motion_alert_string_0:
    .asciiz "Sonar alerts enemy sub in motion somewhere ahead, within "
motion_alert_string_1:
    .asciiz " units!\n"

pinger_alert_string_0:
    .asciiz "Sonar has determined enemy position at "
pinger_alert_string_1:
    .asciiz " N "
pinger_alert_string_2:
    .asciiz " E. However, the enemy has heard the ping as well!\n"

pingee_alert_string_0:
    .asciiz "A ping has been detected originating at "
pingee_alert_string_1:
    .asciiz " N "
pingee_alert_string_2:
    .asciiz " E!\n"

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

hit_notify_string_0:
    .asciiz "Player "
hit_notify_string_1:
    .asciiz "'s torpedo has found its target!!\n"

death_notify_string_0:
    .asciiz "Player "
death_notify_string_1:
    .asciiz "'s submarine has been sunk at "
death_notify_string_2:
    .asciiz " N "
death_notify_string_3:
    .asciiz " E, facing "
death_notify_string_4:
    .asciiz "!\n"

victor_notify_string_0:
    .asciiz "\nPlayer "
victor_notify_string_1:
    .asciiz " is victorious! Praise the motherland!\n"

draw_notify_string:
    .asciiz "\nThere was no victory this day.\n"

console_clear_string:
    .asciiz "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

player_ready_string_0:
    .asciiz "PLAYER "
player_ready_string_1:
    .asciiz " PRESS ENTER TO BEGIN PHASE "
player_ready_string_2:
    .asciiz "\n"

player_menu_string:
    .asciiz "\n0: Full Ahead\n1: Full Astern\n2: Turn to Port\n3: Turn to Starboard\n4: Ping\n5: Fire Ahead\n6: Do Nothing\n\n"

player_prompt_string:
    .asciiz "What are your orders, Captain?\n> "

compass_string:
    .asciiz "           North\n             ^\n      West <   > East\n             v\n           South\n\n"

graphic_west_string:
    .asciiz "          Starboard\n             __\n          __|~ |___\n  Ahead  ( ==      `- Astern\n\n            Port\n\n"

graphic_east_string:
    .asciiz "            Port\n              __\n          ___| ~|__\n Astern -'      == )  Ahead\n\n          Starboard\n\n"

graphic_north_string:
    .asciiz "           Ahead\n\n             --\n            |  |\n     Port  ||()|| Starboard\n            |  |\n            |  |\n             /\\n           Astern\n\n"

graphic_south_string:
    .asciiz "           Astern\n             \/\n            |  |\n            |  |\n Starboard ||()||  Port\n            |  |\n             --\n\n           Ahead\n\n"

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

generate_alerts_function: # a0 -> submarine struct; a1 -> enemy submarine struct; a2 = phase integer
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s registers
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # prompt player for ready
    add $a0, $s0, $zero # player sub
    add $a1, $a2, $zero # phase number
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
    add $a0, $s0, $zero # player sub
    add $a1, $s1, $zero # enemy sub
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
    add $a0, $s1, $zero # sub B
    add $a1, $s0, $zero # sub A
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
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s registers
    add $s0, $a0, $zero # sub A
    add $s1, $a1, $zero # phase number

    la $a0, console_clear_string
    jal print_string_function

    addi $sp, $sp, -20 # 5 argument words
    la $t0, player_ready_string_0
    sw $t0, 0($sp)
    lw $t1, 4($s0) # player int
    sw $t1, 4($sp)
    la $t0, player_ready_string_1
    sw $t0, 8($sp)
    add $t1, $s1, $zero # phase number
    sw $t1, 12($sp)
    la $t0, player_ready_string_2
    sw $t0, 16($sp)

    li $a0, 20
    jal printf_function
    addi $sp, $sp, 20 # pop arguments

    li $v0, 5 # receive input
    syscall

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    lw $s1, 8($sp)
    addi $sp, $sp, 12 # pop stack frame
    jr $ra

alert_status_function: # a0 -> submarine struct
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    # save parameter to s register
    add $s0, $a0, $zero # player sub

    addi $sp, $sp, -20 # 5 argument words
    la $t0, status_alert_string_0
    sw $t0, 0($sp)
    lw $t1, 12($s0) # position.y
    sw $t1, 4($sp)
    la $t0, status_alert_string_1
    sw $t0, 8($sp)
    lw $t1, 8($s0) # position.x
    sw $t1, 12($sp)
    la $t0, status_alert_string_2
    sw $t0, 16($sp)

    li $a0, 20
    jal printf_function
    addi $sp, $sp, 20 # pop arguments

    # print direction string
    lw $a0, 16($s0) # rotation.x
    lw $a1, 20($s0) # rotation.y
    jal direction_function

    add $a0, $v0, $zero # direction string
    jal print_string_function

    la $a0, status_alert_string_3
    jal print_string_function

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8 # pop stack frame
    jr $ra

alert_motion_function: # a0 -> submarine struct; a1 -> enemy submarine struct
    addi $sp, $sp, -20 # allocate 5 words on stack: ra, s0-3
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    # save parameters to s register
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # if enemy has moved or turned, check for detection
    lw $t0, 24($s1) # enemy->move flag
    bne $t0, $zero, alert_motion_function_detect
    lw $t0, 32($s1) # enemy->turn flag
    bne $t0, $zero, alert_motion_function_detect

    # else just return
    j alert_motion_function_return

    alert_motion_function_detect:
        # find direction to enemy by subtracting player position from enemy position
        lw $a0, 8($s1) # enemy->position.x
        lw $a1, 12($s1) # enemy->position.y
        lw $a2, 8($s0) # player->position.x
        lw $a3, 12($s0) # player->position.y
        jal subtract_function

        # save ray
        add $s2, $v0, $zero # ray.x
        add $s3, $v1, $zero # ray.y

        # compare current rotation with direction to enemy
        add $a0, $s2, $zero # ray.x
        add $a1, $s3, $zero # ray.y
        lw $a2, 16($s0) # player->rotation.x
        lw $a3, 20($s0) # player->rotation.y
        jal dot_function

        # if 0 >= product, enemy is not in front of sub
        slt $t0, $zero, $v0
        beq $t0, $zero, alert_motion_function_return

        # find manhattan distance to enemy
        add $a0, $s2, $zero # ray.x
        add $a1, $s3, $zero # ray.y
        jal manhattan_length_function

        # if manhattan distance <= 5 then motion has been detected
        li $t0, 5 # detection distance
        slt $t0, $t0, $v0 # check if 5 < distance
        bne $t0, $zero, alert_motion_function_return

    # print motion alert
    addi $sp, $sp, -12 # 3 argument words
    la $t0, motion_alert_string_0
    sw $t0, 0($sp)
    li $t1, 5 # detection distance
    sw $t1, 4($sp)
    la $t0, motion_alert_string_1
    sw $t0, 8($sp)

    li $a0, 12
    jal printf_function
    addi $sp, $sp, 12 # pop arguments

    alert_motion_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        addi $sp, $sp, 20 # pop stack frame
        jr $ra

alert_bounds_function: # a0 -> submarine struct
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    # save submarine pointer to s register
    add $s0, $a0, $zero # player sub

    # check whether player attempted to move out of bounds
    lw $t0, 44($s0) # bounds flag
    beq $t0, $zero, alert_bounds_function_return

    # print bounds alert
    la $a0, bounds_alert_string
    jal print_string_function

    alert_bounds_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        addi $sp, $sp, 8 # pop stack frame
        jr $ra

alert_pinger_function: # a0 -> submarine struct; a1 -> enemy submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s register
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # check if player pinged
    lw $t0, 36($s0) # ping flag
    beq $t0, $zero, alert_pinger_function_return

    # print enemy position information
    addi $sp, $sp, -20 # 5 argument words
    la $t0, pinger_alert_string_0
    sw $t0, 0($sp)
    lw $t1, 12($s1) # enemy->position.y
    sw $t1, 4($sp)
    la $t0, pinger_alert_string_1
    sw $t0, 8($sp)
    lw $t1, 8($s1) # enemy->position.x
    sw $t1, 12($sp)
    la $t0, pinger_alert_string_2
    sw $t0, 16($sp)

    li $a0, 20
    jal printf_function
    addi $sp, $sp, 20 # pop arguments

    alert_pinger_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

alert_pingee_function: # a0 -> submarine struct; a1 -> enemy submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s register
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # check if enemy pinged
    lw $t0, 36($s1) # enemy->ping flag
    beq $t0, $zero, alert_pingee_function_return

    # print enemy position information
    addi $sp, $sp, -20 # 5 argument words
    la $t0, pingee_alert_string_0
    sw $t0, 0($sp)
    lw $t1, 12($s1) # enemy->position.y
    sw $t1, 4($sp)
    la $t0, pingee_alert_string_1
    sw $t0, 8($sp)
    lw $t1, 8($s1) # enemy->position.x
    sw $t1, 12($sp)
    la $t0, pingee_alert_string_2
    sw $t0, 16($sp)

    li $a0, 20
    jal printf_function
    addi $sp, $sp, 20 # pop arguments

    alert_pingee_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

alert_fire_function: # a0 -> submarine struct; a1 -> enemy submarine struct
    addi $sp, $sp, -20 # allocate 5 words on stack: ra, s0-3
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    # save parameters to s register
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # check if enemy fired
    lw $t0, 40($s1) # enemy->fire flag
    beq $t0, $zero, alert_fire_function_return

    # find direction to enemy by subtracting player position from enemy position
    lw $a0, 8($s1) # enemy->position.x
    lw $a1, 12($s1) # enemy->position.y
    lw $a2, 8($s0) # player->position.x
    lw $a3, 12($s0) # player->position.y
    jal subtract_function

    # save ray
    add $s2, $v0, $zero # ray.x
    add $s3, $v1, $zero # ray.y

    # compare current rotation with direction to enemy
    add $a0, $s2, $zero # ray.x
    add $a1, $s3, $zero # ray.y
    lw $a2, 16($s0) # player->rotation.x
    lw $a3, 20($s0) # player->rotation.y
    jal dot_function

    # if 0 < prod the torpedo originated ahead of the sub
    slt $t0, $zero, $v0
    beq $t0, $zero, alert_fire_function_behind

    # torpedo originated ahead of the sub
    la $a0, fire_ahead_alert_string
    jal print_string_function
    j alert_fire_function_torpedo

    alert_fire_function_behind:
        # torpedo originated behind sub
        la $a0, fire_behind_alert_string
        jal print_string_function

    alert_fire_function_torpedo:
    # detect what direction the torpedo was headed
    # reverse the ray to compare with launch direction
    sub $a0, $zero, $s2 # - ray.x
    sub $a1, $zero, $s3 # - ray.y

    # compare enemy rotation with direction towards player
    lw $a2, 16($s1) # enemy->rotation.x
    lw $a3, 20($s1) # enemy->rotation.y
    jal dot_function

    # if 0 < prod the torpedo was fired toward the player
    slt $t0, $zero, $v0
    beq $t0, $zero, alert_fire_function_behind

    # torpedo fired toward player
    la $a0, fire_toward_alert_string
    jal print_string_function
    j alert_fire_function_return

    alert_fire_function_away:
        # torpedo fired away from player
        la $a0, fire_away_alert_string
        jal print_string_function

    alert_fire_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        addi $sp, $sp, 20 # pop stack frame
        jr $ra

notify_hit_function: # a0 -> submarine struct; a1 -> enemy submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s register
    add $s0, $a0, $zero # player sub
    add $s1, $a1, $zero # enemy sub

    # if enemy is not alive, player may have scored a hit
    lw $t0, 52($s1) # enemy->alive flag
    bne $t0, $zero, notify_hit_function_return # otherwise, return

    # if player has fired, player has scored a hit
    lw $t0, 40($s0) # player->fire flag
    beq $t0, $zero, notify_hit_function_return # otherwise, return

    # notify hit for player
    addi $sp, $sp, -12 # 3 argument words
    la $t0, hit_notify_string_0
    sw $t0, 0($sp)
    lw $t1, 4($s0) # player int
    sw $t1, 4($sp)
    la $t0, hit_notify_string_1
    sw $t0, 8($sp)

    li $a0, 12
    jal printf_function
    addi $sp, $sp, 12 # pop arguments

    notify_hit_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra

notify_collide_function: # a0 -> submarine struct; a1 -> submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s register
    add $s0, $a0, $zero # sub A
    add $s1, $a1, $zero # sub B

    # if either has collided with the other, they are both sunk
    lw $t0, 48($s0) # A->collide flag
    bne $t0, $zero, notify_collide_function_true
    lw $t0, 48($s1) # B->collide flag
    bne $t0, $zero, notify_collide_function_true

    j notify_collide_function_return

    notify_collide_function_true:
        # print collision notification
        la $a0, collide_notify_string
        jal print_string_function

    notify_collide_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra
    jr $ra

notify_death_function: # a0 -> submarine struct
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    # save submarine pointer to s register
    add $s0, $a0, $zero # player sub

    lw $t0, 52($s0) # alive flag
    bne $t0, $zero, notify_death_function_return

    addi $sp, $sp, -28 # 7 argument words
    la $t0, death_notify_string_0
    sw $t0, 0($sp)
    lw $t1, 4($s0) # player int
    sw $t1, 4($sp)
    la $t0, death_notify_string_1
    sw $t0, 8($sp)
    lw $t1, 12($s0) # position.y
    sw $t1, 12($sp)
    la $t0, death_notify_string_2
    sw $t0, 16($sp)
    lw $t1, 8($s0) # position.x
    sw $t1, 20($sp)
    la $t0, death_notify_string_3
    sw $t0, 24($sp)

    li $a0, 28
    jal printf_function
    addi $sp, $sp, 28 # pop arguments

    # print direction string
    lw $a0, 16($s0) # rotation.x
    lw $a1, 20($s0) # rotation.y
    jal direction_function

    add $a0, $v0, $zero # direction string
    jal print_string_function

    la $a0, death_notify_string_4
    jal print_string_function

    notify_death_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        addi $sp, $sp, 8 # pop stack frame
        jr $ra

notify_victor_function: # a0 -> submarine struct; a1 -> submarine struct
    addi $sp, $sp, -12 # allocate 3 words on stack: ra, s0-1
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    # save parameters to s register
    add $s0, $a0, $zero # sub A
    add $s1, $a1, $zero # sub B

    # if A is alive, A is the victor
    lw $t0, 52($s0) # A->alive flag
    beq $t0, $zero, notify_victor_function_B # otherwise, check B

    # declare A victorious
    addi $sp, $sp, -12 # 3 argument words
    la $t0, victor_notify_string_0
    sw $t0, 0($sp)
    lw $t1, 4($s0) # A->player int
    sw $t1, 4($sp)
    la $t0, victor_notify_string_1
    sw $t0, 8($sp)

    li $a0, 12
    jal printf_function
    addi $sp, $sp, 12 # pop arguments

    j notify_victor_function_return

    notify_victor_function_B:
        # if B is alive, B is the victor
        lw $t0, 52($s1) # B->alive flag
        beq $t0, $zero, notify_victor_function_draw # otherwise, draw

        # declare B victorious
        addi $sp, $sp, -12 # 3 argument words
        la $t0, victor_notify_string_0
        sw $t0, 0($sp)
        lw $t1, 4($s1) # B->player int
        sw $t1, 4($sp)
        la $t0, victor_notify_string_1
        sw $t0, 8($sp)

        li $a0, 12
        jal printf_function
        addi $sp, $sp, 12 # pop arguments

    j notify_victor_function_return

    notify_victor_function_draw:
        # print draw notification
        la $a0, draw_notify_string
        jal print_string_function

    notify_victor_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        addi $sp, $sp, 12 # pop stack frame
        jr $ra
    jr $ra

alert_graphic_function: # a0 -> submarine struct
# void alert_graphic(submarine sub)
# {
#     printf("%s%s%s%s%s\n", COMPASS_0, COMPASS_1, COMPASS_2, COMPASS_3, COMPASS_4);
    addi $sp, $sp, -8 # allocate 2 words on stack: ra, s0
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    # save submarine pointer to s register
    add $s0, $a0, $zero # player sub

    # print the compass
    la $a0, compass_string
    jal print_string_function

    # get the current rotation
    lw $t1, 16($s0) # rotation.x
    lw $t2, 20($s0) # rotation.y

    la $a0, graphic_east_string
    slt $t0, $zero, $t1 # x > 0
    bne $t0, $zero, alert_graphic_function_print

    la $a0, graphic_north_string
    slt $t0, $zero, $t2 # y > 0
    bne $t0, $zero, alert_graphic_function_print

    la $a0, graphic_west_string
    slt $t0, $t1, $zero # x < 0
    bne $t0, $zero, alert_graphic_function_print

    la $a0, graphic_south_string
    slt $t0, $t2, $zero # y < 0
    bne $t0, $zero, alert_graphic_function_print

    alert_graphic_function_print:
        jal print_string_function

    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8 # pop stack frame
    jr $ra
