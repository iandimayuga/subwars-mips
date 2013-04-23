# output.c
# Output generation based on player knowledge

generate_alerts_function:
# void generate_alerts(submarine sub, submarine enemy)
# {
#     // prompt player for ready
#     get_ready(sub);
# 
#     // print informational graphics
#     alert_graphic(sub);
# 
#     // print current position and direction
#     alert_status(sub);
# 
#     // alert if tried to move out of bounds
#     alert_bounds(sub);
# 
#     // alert if enemy fired last phase
#     alert_fire(sub, enemy);
# 
#     // alert if enemy moved or turned within vision last phase
#     alert_motion(sub, enemy);
# 
#     // alert if enemy pinged
#     alert_pingee(enemy);
# 
#     // alert the results from own ping last phase
#     alert_pinger(sub, enemy);
# 
#     // give command menu and prompt for input
#     printf(PLAYER_MENU);
#     printf(PLAYER_PROMPT);
# }
    jr $ra

generate_endgame_function:
# void generate_endgame(submarine A, submarine B)
# {
#     // clear the console for endgame
#     printf(CONSOLE_CLEAR);
#     printf(ENDGAME_NOTIFY);
# 
#     // notify if either sub hit the other with a torpedo
#     notify_hit(A, B);
# 
#     // notify if either sub collided into the other
#     notify_collide(A, B);
# 
#     // show death positions and directions
#     notify_death(A);
#     notify_death(B);
# 
#     // congratulate victor, if any
#     notify_victor(A, B);
# }
    jr $ra

get_ready_function:
# void get_ready(submarine sub)
# {
#     printf(CONSOLE_CLEAR);
#     printf(PLAYER_READY, sub.player);
#     while (true)
#     {
#         char c=getchar();
#         if (c=='\n' || c==EOF) break;
#     }
# }
    jr $ra

alert_status_function:
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
