/* state.h
 * Submarine state and knowledge
 */

#ifndef STATE_H
#define STATE_H

#include "math.h"

// Submarine state structure (~19 bytes)
typedef struct submarine {
    vector position; // 8 bytes
    vector rotation; // 8 bytes
	bool moving; // 1 byte, this assumes we only have forward and stop
	bool fire; // 1 byte, did the sub fire last turn
	bool alive; // 1 byte
	bool ping; // 1 byte
	submarine &other_sub; // not sure what the size is
	//as stands I don't think that we need to store data about the other sub in the struct
} submarine;

//resets the booleans moving, fire and ping after each round
void reset_sub(submarine sub);

//initialize two submarine structs at the start of the game
void create_subs(submarine A, submarine B);

//move the passed submarine
void sub_move(submarine sub);

//rotate the passed submarine
void sub_rotate_left(submarine sub);

void sub_rotate_right(submarine sub);

//set the passed submarine to fire
void sub_fire(submarine sub);

void sub_ping(submarine sub);

#endif // STATE_H
