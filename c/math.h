/* math.h
 * Vector Math and other mathematical utilities
 */

#ifndef MATH_H
#define MATH_H

#include <stdbool.h>

// two-dimensional data structure (8 bytes)
typedef struct vector {
    int x; // 4 bytes
    int y; // 4 bytes
} vector;

// vector addition
vector add(vector v0, vector v1);

// vector-scalar multiplication
vector mult(vector v, int s);

// dot product
int dot(vector v0, vector v1);

// raytrace collision
bool collide(vector initial, vector ray, vector target);

// 90-degree counter-clockwise rotation
vector left(vector v);

// 90-degree clockwise rotation
vector right(vector v);

#endif // MATH_H
