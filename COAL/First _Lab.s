#task 1
li a0, 5 #a
li a1, 10 #b
li a2, 20 #c
add a3, a0,a1 #d | result
add a3, a3, a2 #d | result

#task 2 (a)
li s1, 2 #b
li s2, 3 #c
#a = b-c
sub s0,s1,s2 #s0 | result

#task 2 (b)
li s4, 20 #g
li s5, 30 #h
li s6, 20 #i
li s7, 10 #j
#f = (g+h)-(i+j)
add s3, s4, s5 #f = (g+h)
add a0, s6, s7 #temp = (i+j)
sub s3, s3, a0 #f = f-temp

#task 3
li t0, 3 
li t1, -17
mul t3, t0, t1 #t3 = 3x-17

#task 4
li s8, -50
li s9, 3
div s10, s8, s9 #s10 = s8/s9 | s10 = -50/3 | quotient
rem s11, s8, s9 #s11 = -50/3 | remainder
