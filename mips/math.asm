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

    bne $a0, $a2, equals_function_return # if first.x != second.x return false
    bne $a1, $a3, equals_function_return # if first.y != second.y return false

    addi $v0, $v0, 1 # equal = true

    equals_function_return:
        jr $ra

# dot product
dot_function: # a0,a1 = first vector; a2,a3 = second vector; v0 = return scalar
    mult $v0, $a0, $a2 # addend = first.x * second.x
    mult $t0, $a1, $a3 # addend = first.y * second.y
    add $v0, $v0, $t0 # product = addend + addend
    jr $ra

# raytrace collision
collide_function: # a0 -> initial vector; a1 -> ray vector; a2 -> target vector, v0 = return boolean
    addi $sp, $sp, -28 # allocate 7 words on stack: ra, s0-5
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    sw $s1, 8($sp)
    sw $s2, 12($sp)
    sw $s3, 16($sp)
    sw $s4, 20($sp)
    sw $s5, 24($sp)

    # load parameters from memory
    lw $s0, 0($a0) # initial.x
    lw $s1, 4($a0) # initial.y
    lw $s2, 0($a1) # ray.x
    lw $s3, 4($a1) # ray.y
    lw $s4, 0($a2) # target.x
    lw $s5, 4($a2) # target.y

    # subtract initial from target to get expected ray
    add $a0, $s4, $zero # first = target
    add $a1, $s5, $zero
    add $a2, $s0, $zero # second = initial
    add $a3, $s1, $zero
    jal subtract_function # v0,v1 = return vector

    # store return values
    add $s0, $v0, $zero # expected.x
    add $s1, $v1, $zero # expected.y

    # dot expected ray with actual ray
    add $a0, $s0, $zero # first = expected ray
    add $a1, $s1, $zero
    add $a2, $s2, $zero # second = ray
    add $a3, $s3, $zero
    jal dot_function # v0 = return scalar

    # if dot product is equal to the product of the lengths, vectors are parallel
    # compare dot product (squared) with product of lengths (squared)
    mult $s4, $v0, $v0 # dot product squared

    add $a0, $s0, $zero # vector = expected ray
    add $a1, $s1, $zero
    jal square_length_function # v0 = return scalar
    add $s5, $v0, $zero # expected length squared

    add $a0, $s2, $zero # vector = ray
    add $a1, $s3, $zero
    jal square_length_function # v0 = return scalar
    mult $s5, $s5, $v0 # expected length squared * ray length squared

    # condition check
    add $v0, $zero, $zero # collide = false
    bne $s4, $s5, collide_function_return # if dot squared != expected squared * ray squared return false
    addi $v0, $v0, 1 # collide = true

    collide_function_return:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        addi $sp, $sp, 28 # pop stack frame
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
