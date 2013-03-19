/* state.c
 * Submarine state and knowledge
 */

#include "state.h"

//this assumes that subs are created in main and passed here to get initialized
void create_subs(submarine A, submarine B) {
	A = {/*inline vector declaration*/,/*vector*/, false, false, true, &B};
	B = {/*vector*/, /*vector*/, false, false, true, &A};
}

void reset_sub(submarine sub) {
	B.moving = false;
	B.fire = false;
	B.ping = false;
}

//this method assumes that you issue a move forward command every turn
void sub_move(submarine sub) {
	sub.moving = true;
	/* TODO: vector math here */
}

void sub_fire(submarine sub){
	sub.fire = true;
	struct submarine *other = sub.other_sub;
	if collision(sub.position, sub.rotation, (other)->position) {
		(other)->alive = false;
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
