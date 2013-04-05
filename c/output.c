/* output.c
 * Output generation based on player knowledge
 */

#include <stdio.h>
#include "output.h"

#define STATUS_ALERT "Captain! Our current position is %d N %d E, facing %s.\n"
#define MOTION_ALERT "Sonar alerts enemy sub in motion somewhere in front of us!\n"
#define PINGER_ALERT "Sonar has determined enemy position at %d N %d E. However, the enemy has heard the ping as well!\n"
#define PINGEE_ALERT "A ping has been detected originating at %d N %d E!\n"
#define FIRE_AHEAD_ALERT "Torpedo launch detected ahead of us!\n"
#define FIRE_BEHIND_ALERT "Torpedo launch detected behind us!\n"
#define FIRE_TOWARD_ALERT "Sonar has confirmed torpedo was launched toward us but missed!\n"
#define FIRE_AWAY_ALERT "It was launched in entirely the wrong direction!\n"
#define CONSOLE_CLEAR "\n\n\n\n\n\n\n\n"
#define PLAYER_READY "PLAYER %d PRESS ENTER TO CONTINUE\n"
#define PLAYER_PROMPT "\n0: Move Forward\n1: Turn Left\n2: Turn Right\n3: Ping\n4: Fire Ahead\n\nWhat are your orders, Captain?"

void generate_alerts(int player, submarine sub, submarine enemy)
{
    get_ready(player);
    alert_status(sub);
    alert_fire(sub, enemy);
    alert_motion(sub, enemy);
    alert_pingee(enemy);
    alert_pinger(enemy);
    printf(PLAYER_PROMPT);
}

void get_ready(int player)
{
    printf(CONSOLE_CLEAR);
    printf(PLAYER_READY, player);
    while (getchar() != '\n');
}

void alert_status(submarine sub)
{
    char* direction;
    if (sub.rotation.x == 1) direction = "east";
    if (sub.rotation.x == -1) direction = "west";
    if (sub.rotation.y == 1) direction = "north";
    if (sub.rotation.y == -1) direction = "south";

    printf(STATUS_ALERT, sub.position.x, sub.position.y, direction);
}

void alert_motion(submarine sub, submarine enemy)
{
    if (enemy.move)
    {
        // subtract player position from enemy position for direction to enemy
        vector ray = add(enemy.position, mult(sub.position, -1));

        // compare direction to enemy with current rotation
        int prod = dot(ray, sub.rotation);

        // alert if facing enemy in motion
        if (prod > 0)
        {
            printf(MOTION_ALERT);
        }
    }
}

void alert_pinger(submarine enemy)
{
    printf(PINGER_ALERT, enemy.position.x, enemy.position.y);
}

void alert_pingee(submarine enemy)
{
    printf(PINGEE_ALERT, enemy.position.x, enemy.position.y);
}

void alert_fire(submarine sub, submarine enemy)
{
    if (enemy.fire)
    {
        // subtract player position from enemy position for direction to enemy
        vector ray = add(enemy.position, mult(sub.position, -1));

        // compare direction to enemy with current rotation
        int prod = dot(ray, sub.rotation);

        // alert direction to enemy
        if (prod >= 0)
        {
            printf(FIRE_AHEAD_ALERT);
        } else {
            printf(FIRE_BEHIND_ALERT);
        }

        // reverse ray to compare with torpedo launch
        ray = mult(ray, -1);

        // compare direction from enemy to player against enemy rotation
        prod = dot(ray, enemy.rotation);

        // alert if torpedo went toward or away from player
        if (prod > 0)
        {
            printf(FIRE_TOWARD_ALERT);
        } else {
            printf(FIRE_AWAY_ALERT);
        }
    }
}
