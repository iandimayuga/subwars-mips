/* output.h
 * Output generation based on player knowledge
 */

#ifndef OUTPUT_H
#define OUTPUT_H

#include "math.h"
#include "state.h"

// Print alerts at beginning of turn
void generate_alerts(submarine sub, submarine enemy);

// Print notifications at end of game
void generate_endgame(submarine A, submarine B);

// Prepare the player for their turn
void get_ready(submarine sub);

void alert_status(submarine sub);

void alert_motion(submarine sub, submarine enemy);

void alert_bounds(submarine sub);

void alert_pinger(submarine sub, submarine enemy);

void alert_pingee(submarine enemy);

void alert_fire(submarine sub, submarine enemy);

void notify_hit(submarine A, submarine B);

void notify_collide(submarine A, submarine B);

void notify_death(submarine sub);

void notify_victor(submarine A, submarine B);

#endif // OUTPUT_H
