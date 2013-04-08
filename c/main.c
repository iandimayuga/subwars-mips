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
    submarine player1 = {};
    submarine player2 = {};
    create_subs(&player1, &player2);

    while (player1.alive && player2.alive)
    {
        int command1, command2;
        // Generate alerts for player 1
        generate_alerts(1, player1, player2);

        // prompt player 1 for input
        scanf("%d", &command1);
        getchar();

        generate_alerts(2, player2, player1);

        // prompt player 2 for input
        scanf("%d", &command2);
        getchar();

        // reset the action flags
        reset_sub(&player1);
        reset_sub(&player2);

        // evaluate the move commands first
        evaluate_move(&player1, command1);
        evaluate_move(&player2, command2);

        // evaluate actions (fires, pings)
        evaluate_action(&player1, &player2, command1);
        evaluate_action(&player2, &player1, command2);
    }

    if (!player1.alive) printf("Player 1's submarine has been sunk at %d N %d E!\n", player1.position.y, player1.position.x);
    if (!player2.alive) printf("Player 2's submarine has been sunk at %d N %d E!\n", player2.position.y, player2.position.x);

    return 0;
}
