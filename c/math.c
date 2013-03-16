/* math.c
 * Vector Math and other mathematical utilities
 */

#include "math.h"

vector add(vector v0, vector v1)
{
    // Allocate the resultant struct
    vector sum;

    // Add the components
    sum.x = v0.x + v1.x;
    sum.y = v0.y + v1.y;

    // Return the struct
    return sum;
}

vector mult(vector v, int s)
{
    // Allocate the resultant struct
    vector product;

    // Multiply components by scalar
    product.x = v.x * s;
    product.y = v.y * s;

    // Return the struct
    return product;
}

int dot(vector v0, vector v1)
{
    // Allocate the resultant int
    int dotProduct;

    // Multiply the components and add
    dotProduct = v0.x * v1.x + v0.y * v1.y;

    // Return the int
    return dotProduct;
}
