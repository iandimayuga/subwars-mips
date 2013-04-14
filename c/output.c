/* output.c
 * Output generation based on player knowledge
 */

#include <stdio.h>

#include "math.h"
#include "output.h"

#define STATUS_ALERT "Captain! Our current position is %d N %d E, facing %s.\n"
#define MOTION_ALERT "Sonar alerts enemy sub in motion somewhere ahead!\n"
#define PINGER_ALERT "Sonar has determined enemy position at %d N %d E. However, the enemy has heard the ping as well!\n"
#define PINGEE_ALERT "A ping has been detected originating at %d N %d E!\n"
#define FIRE_AHEAD_ALERT "Torpedo launch detected originating ahead of us!\n"
#define FIRE_BEHIND_ALERT "Torpedo launch detected originating behind us!\n"
#define FIRE_TOWARD_ALERT "Sonar has confirmed torpedo was launched toward us but missed!\n"
#define FIRE_AWAY_ALERT "It was launched in entirely the wrong direction!\n"
#define BOUNDS_ALERT "Our orders prevent us from moving forward. We must turn!\n"

#define ENDGAME_NOTIFY "ENDGAME\n\n"
#define COLLIDE_NOTIFY "Both subs have collided!!\n"
#define HIT_NOTIFY "Player %d's torpedo has found its target!!\n"
#define DEATH_NOTIFY "Player %d's submarine has been sunk at %d N %d E, facing %s!\n"
#define VICTOR_NOTIFY "\nPlayer %d is victorious! Praise the motherland!\n"
#define DRAW_NOTIFY "\nThere was no victory this day.\n"

#define CONSOLE_CLEAR "\e[1;1H\e[2J"
#define PLAYER_READY "PLAYER %d PRESS ENTER TO CONTINUE\n"
#define PLAYER_MENU "\n0: Full Ahead\n1: Full Astern\n2: Turn to Port\n3: Turn to Starboard\n4: Ping\n5: Fire Ahead\n6: Do Nothing\n"
#define PLAYER_PROMPT "\nWhat are your orders, Captain? "

void generate_alerts(submarine sub, submarine enemy)
{
    // prompt player for ready
    get_ready(sub);

    // print current position and direction
    alert_status(sub);

    // alert if tried to move out of bounds
    alert_bounds(sub);

    // alert if enemy fired last phase
    alert_fire(sub, enemy);

    // alert if enemy moved or turned within vision last phase
    alert_motion(sub, enemy);

    // alert if enemy pinged
    alert_pingee(enemy);

    // alert the results from own ping last phase
    alert_pinger(sub, enemy);

    // give command menu and prompt for input
    printf(PLAYER_MENU);
    printf(PLAYER_PROMPT);
}

void generate_endgame(submarine A, submarine B)
{
    // clear the console for endgame
    printf(CONSOLE_CLEAR);
    printf(ENDGAME_NOTIFY);

    // notify if either sub hit the other with a torpedo
    notify_hit(A, B);

    // notify if either sub collided into the other
    notify_collide(A, B);

    // show death positions and directions
    notify_death(A);
    notify_death(B);

    // congratulate victor, if any
    notify_victor(A, B);
}

void get_ready(submarine sub)
{
    printf(CONSOLE_CLEAR);
    printf(PLAYER_READY, sub.player);
    while (true)
    {
        char c=getchar();
        if (c=='\n' || c==EOF) break;
    }
}

void alert_status(submarine sub)
{
    char* dir = direction(sub.rotation);

    printf(STATUS_ALERT, sub.position.y, sub.position.x, dir);
}

void alert_motion(submarine sub, submarine enemy)
{
    if (enemy.move || enemy.turn)
    {
        // subtract player position from enemy position for direction to enemy
        vector ray = subtract(enemy.position, sub.position);

        // compare direction to enemy with current rotation
        int prod = dot(ray, sub.rotation);

        // alert if facing enemy in motion
        if (prod > 0)
        {
            printf(MOTION_ALERT);
        }
    }
}

void alert_bounds(submarine sub)
{
    if (sub.bounds) printf(BOUNDS_ALERT);
}

void alert_pinger(submarine sub, submarine enemy)
{
    if (sub.ping)
        printf(PINGER_ALERT, enemy.position.y, enemy.position.x);
}

void alert_pingee(submarine enemy)
{
    if (enemy.ping)
        printf(PINGEE_ALERT, enemy.position.y, enemy.position.x);
}

void alert_fire(submarine sub, submarine enemy)
{
    if (enemy.fire)
    {
        // subtract player position from enemy position for direction to enemy
        vector ray = subtract(enemy.position, sub.position);

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

void notify_hit(submarine A, submarine B)
{
    if (!B.alive && A.fire) printf(HIT_NOTIFY, A.player);
    if (!A.alive && B.fire) printf(HIT_NOTIFY, B.player);
}

void notify_collide(submarine A, submarine B)
{
    // notify if either sub collided with the other
    if (A.collide || B.collide)
    {
        printf(COLLIDE_NOTIFY);
    }
}

void notify_death(submarine sub)
{
    char* dir = direction(sub.rotation);

    // notify if sub is no longer alive
    if (!sub.alive) printf(DEATH_NOTIFY, sub.player, sub.position.y, sub.position.x, dir);
}

void notify_victor(submarine A, submarine B)
{
    if (A.alive) printf(VICTOR_NOTIFY, A.player);
    else if (B.alive) printf(VICTOR_NOTIFY, B.player);
    else printf(DRAW_NOTIFY);
}
