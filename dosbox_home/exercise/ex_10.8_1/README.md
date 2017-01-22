# Exercise ex_10.8_1

## Description
Write a program that is able to calculate the integer factorization of
a number.

The algorithm work as follow:

  - 1: the dividend is initialized al the starting number and the divisor to 2
  - 2: perform the division
  - 3: if the rest is 0, then the divisor is a factor of the initial number and the result is copied into the dividend variable
  - 4: otherwise, the divisor is incremented of one unit
  - 5: if the rest is greater than 1 we should start again from 2
