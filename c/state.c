/* state.c
 * Submarine state and knowledge
 */

#include "state.h"

//this assumes that subs are created in main and passed here to get initialized
void create_subs(submarine* A, submarine* B) {
    vector botLeft = {MAP_LEFT, MAP_BOTTOM};
    vector topRight = {MAP_RIGHT, MAP_TOP};
    vector right = {1, 0};
    vector left = {-1, 0};
    A->position = botLeft;
    A->rotation = right;
    B->position = topRight;
    B->rotation = left;
    A->move = B->move = false;
    A->fire = B->fire = false;
    A->alive = B->alive = true;
    A->ping = B->ping = false;
}

//alternate way to make a single sub, commented out since we aren't using it
/*
 *void create_sub(vector position, vector rotation){
 *    return submarine temp = {position, rotation, false, false, true};
 *}
 */

void reset_sub(submarine* sub) {
    sub->move = false;
    sub->fire = false;
    sub->ping = false;
}

void sub_move(submarine* sub) {
    // Check boundaries
    vector resultant = add(sub->position, sub->rotation);

    if (resultant.x >= MAP_LEFT &&
        resultant.x <= MAP_RIGHT &&
        resultant.y >= MAP_BOTTOM &&
        resultant.y <= MAP_TOP)
    {
        sub->move = true;
        sub->position = resultant;
    }
}

void sub_fire(submarine* sub, submarine* target){
    sub->fire = true;
    if (collide(sub->position, sub->rotation, target->position)) {
        target->alive = false;
    }
}

void sub_rotate_left(submarine* sub) {
    sub->rotation = left(sub->rotation);
}

void sub_rotate_right(submarine* sub) {
    sub->rotation = right(sub->rotation);
}

void sub_ping(submarine* sub) {
    sub->ping = true;
}

void evaluate_move(submarine* sub, int command)
{
    switch (command)
    {
        case 0:
            sub_move(sub);
            break;
        case 1:
            sub_rotate_left(sub);
            break;
        case 2:
            sub_rotate_right(sub);
            break;
    }
}

void evaluate_action(submarine* sub, submarine* enemy, int command)
{
    switch (command)
    {
        case 3:
            sub_ping(sub);
            break;
        case 4:
            sub_fire(sub, enemy);
            break;
    }
}
