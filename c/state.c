/* state.c
 * Submarine state and knowledge
 */

#include "state.h"

//this assumes that subs are created in main and passed here to get initialized
void create_subs(submarine A, submarine B) {
        vector botLeft = {0, 0};
        vector topRight = {10, 10};
        vector right = {1, 0};
        vector left = {-1, 0};
        A.position = botLeft;
        A.rotation = right;
        B.position = topRight;
        B.rotation = left;
        A.moving = B.moving = false;
        A.fire = B.fire = false;
        A.alive = B.alive = true;
        A.ping = B.ping = false;
}

//alternate way to make a single sub, commented out since we aren't using it
/*
 *void create_sub(vector position, vector rotation){
 *    return submarine temp = {position, rotation, false, false, true};
 *}
 */

void reset_sub(submarine sub) {
	sub.moving = false;
	sub.fire = false;
	sub.ping = false;
}

//this method assumes that you issue a move forward command every turn
void sub_move(submarine sub) {
	sub.moving = true;
	sub.position = add(sub.position, sub.rotation);
}

void sub_fire(submarine sub, submarine target){
	sub.fire = true;
	if (collide(sub.position, sub.rotation, target.position)) {
		target.alive = false;
	}
}

void sub_rotate_left(submarine sub) {
	left(sub.rotation);
}

void sub_rotate_right(submarine sub) {
	right(sub.rotation);
}

void sub_ping(submarine sub) {
	sub.ping = true;
}
