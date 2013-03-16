/* math.h
 * Vector Math and other mathematical utilities
 */

#ifndef MATH_H
#define MATH_H

// two-dimensional data structure
typedef struct {
    int x;
    int y;
} vector;

// vector addition
vector add(vector v0, vector v1);

// vector-scalar multiplication
vector mult(vector v, int s);

// dot product
int dot(vector v0, vector v1);

#endif // MATH_H
