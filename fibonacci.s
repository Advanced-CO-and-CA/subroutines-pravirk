
/******************************************************************************
* file: min_max.s
* author: Pravir
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Code to find fibonacci number, corresponding to an integer > 2
 Input 1)Number N > 2
 Output 1)Fibonacci(N)
  */

  @ BSS section
      .bss
  @ DATA SECTION
      .data
Program_Summary_Msg : .asciz "Prints the fibonacci number, corresponding to an integer > 2\n"
Input_Integer_Msg: .asciz "Enter the integer->"
Fibonacci_Num_Msg: .asciz "Fibonacci number is:"

.align

num: .word 5
fibonacci_num: .word 0


  @ TEXT section
      .text


.globl _main
.equ SWI_PrStr,0x69     @ Write a null-ending string 
.equ SWI_GetInt, 0x6c   @ Get int
.equ SWI_PrInt,0x6b     @ Write an Integer
.equ SWI_Exit, 0x11     @ Stop execution
.equ Stdout, 1          @ Set output target to be Stdout
.equ Stdin,  0

fibonacci_n .req R1
index .req R4
_main:

@Print program intro
MOV R0, #Stdout
LDR R1, =Program_Summary_Msg
SWI SWI_PrStr

@Print message to input the num
MOV R0, #Stdout
LDR R1, =Input_Integer_Msg
SWI SWI_PrStr

@Get num and store in num
MOV R0, #Stdin
SWI SWI_GetInt
LDR R1, =num
STR R0, [R1]

@Actual fibonacci calculation works from 3rd element, hence sustract 2
SUB R0, #2
@Store a copy into index register
MOV index, R0

@Push 1,1 of the sequence to the stack
MOV R1, #1
PUSH {R1}
PUSH {R1}

@function call to get fibonacci number
BL FIBONACCI 

LDR R4, =fibonacci_num @load address of fibonacci_num
STR fibonacci_n, [R4]@Store fibonacci_num

MOV R0, #Stdout
LDR R1, = Fibonacci_Num_Msg
SWI SWI_PrStr

MOV R0, #Stdout
LDR R1, =fibonacci_num @load address of fibonacci_num
LDR R1, [R1] @load fibonacci_num
SWI SWI_PrInt
 
SWI SWI_Exit

//==================================================================================
//Subroutine to find the Nth fibonacci number in sequence(number passed through register),
//implementation using stack
//=====================================================================================

FIBONACCI: @

arg .req R0
fibonacci_n_1 .req R2
fibonacci_n_2 .req R3

@Pop top 2 elements from stack which are effectively Fibonacci(n-1) and Fibonacci(n-2)
POP {fibonacci_n_1}
POP {fibonacci_n_2}

@Push the Link register content to keep track of the return address from the subroutine
PUSH {LR}

@Add the results of the previous 2 iterations - Fibonacci(n-1) + Fibonacci(n-2)
ADD fibonacci_n, fibonacci_n_1, fibonacci_n_2

@Pushing Fibonacci(n-1) to stack
PUSH {fibonacci_n_1};

@Push the result computed in the current iteration - Fibonacci(n) to the stack
PUSH {fibonacci_n};                        

@Decrement the loop counter R0 to perform this sequence of operations N times
SUBS index, index, #1

@Branch to DONE if complete
BEQ DONE

@Recursively call the subroutine FIBONACCI
BL FIBONACCI

DONE:
@Pop the first element from the stack which is required result
POP {fibonacci_n}
POP {fibonacci_n_1}

@As each LR address is stored on stack, perform these steps to calculate return address to the main program
@Increment the Stack pointer by (no. of times the Fibonacci sequence ran - 1)*4 bytes to point it to the return address to main */
SUB R5, arg, #1
LSL R5, #2
ADD SP, R5

@Pop the result to PC, return
POP {PC}
.end
