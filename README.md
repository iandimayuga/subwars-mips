subwars-mips
============

Submarine Warfare Simulator in MIPS - EECS 314 Computer Architecture Semester Project

Implementation
--------------

The C implementation (found in "./c") was used for debugging and game design.

Subsequently, we have manually "compiled" the C implementation into MIPS assembly code (found in "./mips") for submission.

Installation
------------
Run qtSpim and load the MIPS assembly files in the following order:

1. mips/main.asm

2. mips/output.asm

3. mips/state.asm

4. mips/math.asm

Then begin the simulation.

Gameplay
--------
Opening splash and instructions:

                                      _
                                     |  `-._
                           .---._    |       `-.
                          /       `-.|   _______|
                         |               `-.____`-.
               __        |         |`-.         |
              |  `-._    |          `-.|         `-._
              `-._``-._   \                           `-._
                   `-. ``-.`-._                            `-.
                                  __| |  | _ | |    |    | _ \ __|
                                 __ | |  | _ { |  \ |  / |   /__ |
                                 ___|____|___|__/`__|_,-_|_\_\___|


    Welcome to SUBWARS!!

    You are Player 1 and Player 2, the top two Nuclear Submarine commanders in the Soviet Navy.
    It is the year 1958, and Secretary Khrushchev has ordered a round of War Games.
    You have both surfaced in the Atlantic Ocean just off the Ivory Coast.
    Your orders are to find and sink your comrade's submarine.

    This is a turn-based game based on the concept of limited information.
    Each phase, Player 1 will give orders, followed by Player 2.
    The phase will then commence, and when actions have been taken, the next phase will begin.
    You must stay within an 8x8 grid from 0 N 0 E to 7 N 7 E.
    Explore the area and try to listen for your enemy.
    If they use their engines while in front of you, you may detect them.
    Torpedo fire and pings can be heard by everyone.
    If you are pointing directly at your enemy and fire a torpedo, you will be victorious!!

    Starting conditions are indicated below:

       0 E                         7 E
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |<P2| 7 N
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |   |
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |   |
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |   |
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |   |
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |   |
      +---+---+---+---+---+---+---+---+
      |   |   |   |   |   |   |   |   |
    ^ +---+---+---+---+---+---+---+---+
    | |P1>|   |   |   |   |   |   |   | 0 N
    N +---+---+---+---+---+---+---+---+
      E--->

    PRESS ENTER TO SUBMERGE
