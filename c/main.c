/* main.c
 * Entry point for game
 */

#include <stdio.h>
#include "math.h"
#include "state.h"

int main()
{
    // intimidate players
    printf("Hello World! My name is Joseph Stalin.\nMy submarine fleet has been launched to dominate your MIPS.\n");

    // initialize submarines
    submarine player1 = {};
    submarine player2 = {};
    create_subs(&player1, &player2);

    // output current state for player 1
    printf("Player 1 position = %d,%d\n", player1.position.x, player1.position.y);
    printf("Player 1 rotation = %d,%d\n", player1.rotation.x, player1.rotation.y);

    // prompt users for input
    int command1, command2;
    printf("Player 1 input: ");
    scanf("%d", &command1);

    // output current state for player 2
    printf("Player 2 position = %d,%d\n", player2.position.x, player2.position.y);
    printf("Player 2 rotation = %d,%d\n", player2.rotation.x, player2.rotation.y);

    // prompt player 2 for input
    printf("Player 2 input: ");
    scanf("%d", &command2);

    // evaluate the move commands first
    evaluate_move(&player1, command1);
    evaluate_move(&player2, command2);

    // evaluate actions (fires, pings)
    evaluate_action(&player1, &player2, command1);
    evaluate_action(&player2, &player1, command2);

    // output current state for player 1
    printf("Player 1 position = %d,%d\n", player1.position.x, player1.position.y);
    printf("Player 1 rotation = %d,%d\n", player1.rotation.x, player1.rotation.y);

    if (player1.ping) printf("Player 1 pinged!\n");
    if (player1.fire) printf("Player 1 fired!\n");
    if (!player1.alive) printf("Player 1 dead.\n");

    // output current state for player 2
    printf("Player 2 position = %d,%d\n", player2.position.x, player2.position.y);
    printf("Player 2 rotation = %d,%d\n", player2.rotation.x, player2.rotation.y);

    if (player2.ping) printf("Player 2 pinged!\n");
    if (player2.fire) printf("Player 2 fired!\n");
    if (!player2.alive) printf("Player 2 dead.\n");

    return 0;
}
