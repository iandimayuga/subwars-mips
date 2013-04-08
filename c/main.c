/* main.c
 * Entry point for game
 */

#include <stdio.h>
#include "math.h"
#include "state.h"
#include "output.h"

int main()
{
    // intimidate players
    printf("Hello World! My name is Joseph Stalin.\nMy submarine fleet has been launched to dominate your MIPS.\n");
    printf("PRESS ENTER TO BEGIN");
    while (true)
    {
        char c=getchar();
        if (c=='\n' || c==EOF) break;
    }

    // initialize submarines
    submarine sub1 = {};
    submarine sub2 = {};
    create_subs(&sub1, &sub2);

    while (sub1.alive && sub2.alive)
    {
        int command1, command2;
        // Generate alerts for player 1
        generate_alerts(sub1, sub2);

        // prompt player 1 for input
        scanf("%d", &command1);
        getchar();

        generate_alerts(sub2, sub1);

        // prompt player 2 for input
        scanf("%d", &command2);
        getchar();

        // reset the action flags
        reset_flags(&sub1);
        reset_flags(&sub2);

        // evaluate the motion commands first
        evaluate_motion(&sub1, command1);
        evaluate_motion(&sub2, command2);

        // check if subs collided
        check_collision(&sub1, &sub2);

        // evaluate actions (fires, pings)
        evaluate_action(&sub1, &sub2, command1);
        evaluate_action(&sub2, &sub1, command2);

        // Check for submarine collision
    }

    // print endgame text
    generate_endgame(sub1, sub2);

    return 0;
}
