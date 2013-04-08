#include <stdio.h>

int main(void)
{
    char decision[4];

    printf( "Welcome to Subwars\n");
    printf( "Input action (move, turn, fire, ping)\n" );
    scanf( "%s", decision ); 
    
    if (strcmp (decision, "move") == 0)
    {
        char move_direction [256];  //perhaps define up top
        printf( "Do you want to move 'forward' or 'backward'?\n");
        scanf ( "%s", move_direction);

        if (strcmp (move_direction, "forward") == 0)
        {
            printf ("You are moving forward\n");
        }

        else if (strcmp (decision, "backward") == 0)
        {
            printf ("You are moving backwards\n");
        }

        else
        {
            printf ("You have input an invalid input\n"); 
        }    
    }

    else if (strcmp (decision, "turn") == 0)
    {
        char rotation [256];
        printf ("What amount do you wish to turn? ('left', 'right', 'full')\n");
        scanf ( "%s", rotation);

        if (strcmp (rotation, "left") == 0)
        {
            printf ("Turned Left\n");
        }

        else if (strcmp (rotation, "right") == 0)
        {
            printf ("Turned Right\n");
        }

        else if (strcmp (rotation, "full") == 0)
        {
            printf ("Turned 180 Degrees\n");
        }

        else
        {
            printf ("You have input and incorrect statement\n");    
        }
    }
    
    else if (strcmp (decision, "fire") == 0)
    {
        printf ("You have fired\n");
    }

    else if (strcmp (decision, "ping") == 0)
    {
        printf ("You have pinged\n");
    }

    else 
    {
        printf ("You have input an incorrect statement... SORRY\n"); 
    }

}
