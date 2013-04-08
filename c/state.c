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
    A->player = 1;
    B->player = 2;
    A->position = botLeft;
    A->rotation = right;
    B->position = topRight;
    B->rotation = left;

    reset_flags(A);
    reset_flags(B);

    A->alive = B->alive = true;
}

void reset_flags(submarine* sub) {
    sub->move = false;
    sub->turn = false;
    sub->ping = false;
    sub->fire = false;
    sub->bounds = false;
}

void sub_move(submarine* sub) {
    // Check boundaries
    vector resultant = add(sub->position, sub->rotation);

    if (resultant.x >= MAP_LEFT &&
        resultant.x <= MAP_RIGHT &&
        resultant.y >= MAP_BOTTOM &&
        resultant.y <= MAP_TOP)
    {
        // Move if sub would stay in-bounds
        sub->move = true;
        sub->position = resultant;
    } else {
        // Notify otherwise, but do not move
        sub->bounds = true;
    }
}

void check_collision(submarine* A, submarine* B)
{
    if (equals(A->position, B->position)) {
        // A and B occupy the same point in space
        A->collide = B->collide = true;
    } else if (A->move && B->move) {
        // check to see if they may have passed through each other (if they have both moved and are facing away from each other)

        // subtract B from A
        vector displacement = add(A->position, mult(B->position, -1));

        if (equals(A->rotation, displacement) && equals(B->rotation, mult(displacement, -1)))
        {
            // A and B passed through each other this turn
            A->collide = B->collide = true;
        }
    }

    // Any collision results in death of both parties
    if (A->collide || B->collide) A->alive = B->alive = false;
}

void sub_fire(submarine* sub, submarine* target){
    sub->fire = true;
    if (collide(sub->position, sub->rotation, target->position)) {
        target->alive = false;
    }
}

void sub_rotate_left(submarine* sub) {
    sub->turn = true;
    sub->rotation = left(sub->rotation);
}

void sub_rotate_right(submarine* sub) {
    sub->turn = true;
    sub->rotation = right(sub->rotation);
}

void sub_ping(submarine* sub) {
    sub->ping = true;
}

void evaluate_motion(submarine* sub, int command)
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
