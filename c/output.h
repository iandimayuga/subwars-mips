/* output.h
 * Output generation based on player knowledge
 */

#ifndef OUTPUT_H
#define OUTPUT_H

#include "math.h"
#include "state.h"

void generate_alerts(int player, submarine sub, submarine enemy);

void get_ready(int player);

void alert_motion(submarine sub, submarine enemy);

void alert_pinger(submarine enemy);

void alert_pingee(submarine enemy);

void alert_fire(submarine sub, submarine enemy);

#endif // OUTPUT_H
