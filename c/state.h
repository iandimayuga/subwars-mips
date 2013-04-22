/* state.h
 * Submarine state and knowledge
 */

#ifndef STATE_H
#define STATE_H

#include "math.h"

#define MAP_BOTTOM 0
#define MAP_TOP 7
#define MAP_LEFT 0
#define MAP_RIGHT 7

// Submarine state structure (21 bytes, or 44 if bools take up a full word)
typedef struct submarine {
    int player;
    vector position; // 8 bytes
    vector rotation; // 8 bytes
    bool move; // 1 byte, did the sub move
    bool turn; // 1 byte, did the sub turn
    bool ping; // 1 byte
    bool fire; // 1 byte, did the sub fire last turn
    bool bounds; // 1 byte, did the sub attempt to leave the bounds of the map
    bool collide; // 1 byte, have the subs collided
    bool alive; // 1 byte
} submarine;

//resets the action flags before each phase execution
void reset_flags(submarine* sub);

//initialize two submarine structs at the start of the game
void create_subs(submarine* A, submarine* B);

//check if collision has occurred between subs and sink them if necessary
void check_collision(submarine* A, submarine* B);

//move the submarine
void sub_move(submarine* sub, bool dir);

//rotate the submarine
void sub_rotate_left(submarine* sub);
void sub_rotate_right(submarine* sub);

//fire the submarine's torpedo and check for hit
void sub_fire(submarine* sub, submarine* target);

//apply the ping action
void sub_ping(submarine* sub);

//applies a movement command to a player's sub
void evaluate_motion(submarine* sub, int command);

//applies an action command to a player's sub
void evaluate_action(submarine* sub, submarine* enemy, int command);

#endif // STATE_H
