# math.asm
# Vector Math and other mathematical utilities

add_function:
# vector add(vector v0, vector v1)
# {
#     // Allocate the resultant struct
#     vector sum;
#
#     // Add the components
#     sum.x = v0.x + v1.x;
#     sum.y = v0.y + v1.y;
#
#     // Return the struct
#     return sum;
# }
    jr

subtract_function:
# vector subtract(vector v0, vector v1)
# {
#     return add(v0, mult(v1, -1));
# }
    jr

mult_function:
# vector mult(vector v, int s)
# {
#     // Allocate the resultant struct
#     vector product;
#
#     // Multiply components by scalar
#     product.x = v.x * s;
#     product.y = v.y * s;
#
#     // Return the struct
#     return product;
# }
    jr

equals_function:
# bool equals(vector v0, vector v1)
# {
#     return v0.x == v1.x && v0.y == v1.y;
# }

# int dot(vector v0, vector v1)
# {
#     // Allocate the resultant int
#     int dotProduct;
#
#     // Multiply the components and add
#     dotProduct = v0.x * v1.x + v0.y * v1.y;
#
#     // Return the int
#     return dotProduct;
# }
    jr

collide_function:
# bool collide(vector initial, vector ray, vector target)
# {
#     // Subtract initial from target to get expected ray
#     vector expected = subtract(target, initial);
#
#     // Dot expected ray with actual ray
#     int dotProduct = dot(expected, ray);
#
#     // If product is equal to the product of lengths, vectors are parallel
#     // Compare dot product (squared) with product of lengths (squared)
#     return dotProduct * dotProduct == dot(expected, expected) * dot(ray, ray);
# }
    jr

left_function:
# vector left(vector v)
# {
#     // Allocate the resultant struct
#     vector leftTurn;
#
#     // Assign rotated values
#     leftTurn.x = -v.y;
#     leftTurn.y = v.x;
#
#     // Return the struct
#     return leftTurn;
# }
    jr

right_function:
# vector right(vector v)
# {
#     // Allocate the resultant struct
#     vector rightTurn;
#
#     // Assign rotated values
#     rightTurn.x = v.y;
#     rightTurn.y = -v.x;
#
#     // Return the struct
#     return rightTurn;
# }
    jr

manhattan_length_function:
# int manhattan_length(vector v)
# {
#     int x = v.x;
#     int y = v.y;
#     if (x < 0) x = -x;
#     if (y < 0) y = -y;
#     return x + y;
# }
    jr

square_length_function:
# int square_length(vector v)
# {
#     return dot(v, v);
# }
    jr

direction_function:
# char* direction(vector rotation)
# {
#     if (rotation.y > 0) return "north";
#     if (rotation.y < 0) return "south";
#     if (rotation.x > 0) return "east";
#     if (rotation.x < 0) return "west";
#
#     return "";
# }
    jr
