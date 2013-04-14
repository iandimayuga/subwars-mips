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

// vector subtraction (v0 - v1)
vector subtract(vector v0, vector v1);

// vector-scalar multiplication
vector mult(vector v, int s);

// vector equality
bool equals(vector v0, vector v1);

// dot product
int dot(vector v0, vector v1);

// raytrace collision
bool collide(vector initial, vector ray, vector target);

// 90-degree counter-clockwise rotation
vector left(vector v);

// 90-degree clockwise rotation
vector right(vector v);

// Length of vector measured along axes (x + y)
int manhattanLength(vector v);

// Squared length of vector
int squareLength(vector v);

// Cardinal direction names
char* direction(vector rotation);

#endif // MATH_H
