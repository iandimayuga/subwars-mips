/* output.h
 * Output generation based on player knowledge
 */

#ifndef OUTPUT_H
#define OUTPUT_H

#include "math.h"
#include "state.h"

#define DETECT_DISTANCE 5

// Print alerts at beginning of turn
void generate_alerts(submarine sub, submarine enemy);

// Print notifications at end of game
void generate_endgame(submarine A, submarine B);

// Prepare the player for their turn
void get_ready(submarine sub);

void alert_graphic(submarine sub);

void alert_status(submarine sub);

void alert_motion(submarine sub, submarine enemy);

void alert_bounds(submarine sub);

void alert_pinger(submarine sub, submarine enemy);

void alert_pingee(submarine enemy);

void alert_fire(submarine sub, submarine enemy);

void notify_hit(submarine A, submarine B);

void notify_collide(submarine A, submarine B);

void notify_death(submarine sub);

void notify_victor(submarine A, submarine B);

#define STATUS_ALERT "Captain! Our current position is %d N %d E, facing %s.\n"
#define MOTION_ALERT "Sonar alerts enemy sub in motion somewhere ahead, within %d units!\n"
#define PINGER_ALERT "Sonar has determined enemy position at %d N %d E. However, the enemy has heard the ping as well!\n"
#define PINGEE_ALERT "A ping has been detected originating at %d N %d E!\n"
#define FIRE_AHEAD_ALERT "Torpedo launch detected originating ahead of us!\n"
#define FIRE_BEHIND_ALERT "Torpedo launch detected originating behind us!\n"
#define FIRE_TOWARD_ALERT "Sonar has confirmed torpedo was launched toward us but missed!\n"
#define FIRE_AWAY_ALERT "It was launched in entirely the wrong direction!\n"
#define BOUNDS_ALERT "Our orders prohibit us from moving that way. We must go a different way!\n"

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

#define COMPASS_0 "           North\n"
#define COMPASS_1 "             ^\n"
#define COMPASS_2 "      West <   > East\n"
#define COMPASS_3 "             v\n"
#define COMPASS_4 "           South\n"

#define GRAPHIC_WEST_0 "          Starboard\n"
#define GRAPHIC_WEST_1 "             __\n"
#define GRAPHIC_WEST_2 "          __|~ |___\n"
#define GRAPHIC_WEST_3 "  Ahead  ( ==      `- Astern\n"
#define GRAPHIC_WEST_4 "\n"
#define GRAPHIC_WEST_5 "            Port\n"

#define GRAPHIC_EAST_0 "            Port\n"
#define GRAPHIC_EAST_1 "              __\n"
#define GRAPHIC_EAST_2 "          ___| ~|__\n"
#define GRAPHIC_EAST_3 " Astern -'      == )  Ahead\n"
#define GRAPHIC_EAST_4 "\n"
#define GRAPHIC_EAST_5 "          Starboard\n"

#define GRAPHIC_NORTH_0 "           Ahead\n"
#define GRAPHIC_NORTH_1 "\n"
#define GRAPHIC_NORTH_2 "             --\n"
#define GRAPHIC_NORTH_3 "            |  |\n"
#define GRAPHIC_NORTH_4 "     Port  ||()|| Starboard\n"
#define GRAPHIC_NORTH_5 "            |  |\n"
#define GRAPHIC_NORTH_6 "            |  |\n"
#define GRAPHIC_NORTH_7 "             /\\\n"
#define GRAPHIC_NORTH_8 "           Astern\n"

#define GRAPHIC_SOUTH_0 "           Astern\n"
#define GRAPHIC_SOUTH_1 "             \\/\n"
#define GRAPHIC_SOUTH_2 "            |  |\n"
#define GRAPHIC_SOUTH_3 "            |  |\n"
#define GRAPHIC_SOUTH_4 " Starboard ||()||  Port\n"
#define GRAPHIC_SOUTH_5 "            |  |\n"
#define GRAPHIC_SOUTH_6 "             --\n"
#define GRAPHIC_SOUTH_7 "\n"
#define GRAPHIC_SOUTH_8 "           Ahead\n"

#endif // OUTPUT_H
