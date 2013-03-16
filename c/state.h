/* state.h
 * Submarine state and knowledge
 */

#ifndef STATE_H
#define STATE_H

#include "math.h"

typedef struct submarine {
    vector position; // 8 bytes
    vector rotation; // 8 bytes
} submarine;

#endif // STATE_H
