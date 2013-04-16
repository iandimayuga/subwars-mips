# math.asm
# Vector Math and other mathematical utilities

.text

# vector addition
add_function: # a0,a1 = first vector; a2,a3 = second vector; v0,v1 = return vector
    add $v0, $a0, $a2 # result.x = first.x + second.x
    add $v1, $a1, $a3 # result.y = first.y + second.y
    jr $ra

# vector subtraction (first - second)
subtract_function: # a0,a1 = first vector; a2,a3 = second vector; v0,v1 = return vector
    sub $v0, $a0, $a2 # result.x = first.x - second.x
    sub $v1, $a1, $a3 # result.y = first.y - second.y
    jr $ra

# vector-scalar multiplication
mult_function: # a0,a1 = vector; a2 = scalar; v0,v1 = return vector
    mult $v0, $a0, $a2 # result.x = vector.x * scalar
    mult $v1, $a1, $a2 # result.y = vector.y * scalar
    jr $ra

# vector equality
equals_function: # a0,a1 = first vector; a2,a3 = second vector; v0 = return boolean
    add $v0, $zero, $zero # equal = false

    bne $a0, $a2, equals_function_return # if first.x != second.x return 0
    bne $a1, $a3, equals_function_return # if first.y != second.y return 0

    addi $v0, $v0, 1 # equal = true

    equals_function_return:
        jr $ra

# dot product
dot_function: # a0,a1 = first vector; a2,a3 = second vector; v0 = return scalar
    mult $v0, $a0, $a2 # addend = first.x * second.x
    mult $t0, $a1, $a3 # addend = first.y * second.y
    add $v0, $v0, $t0 # product = addend + addend
    jr $ra

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
    jr $ra

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
    jr $ra

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
    jr $ra

manhattan_length_function:
# int manhattan_length(vector v)
# {
#     int x = v.x;
#     int y = v.y;
#     if (x < 0) x = -x;
#     if (y < 0) y = -y;
#     return x + y;
# }
    jr $ra

square_length_function:
# int square_length(vector v)
# {
#     return dot(v, v);
# }
    jr $ra

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
    jr $ra
