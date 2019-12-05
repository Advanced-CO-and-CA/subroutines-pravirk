
/******************************************************************************
* file: min_max.s
* author: Pravir
* Guide: Prof. Madhumutyam IITM, PACE
******************************************************************************/

/*
  Code to find minimum, maximum and toal number of elemets,
  in a set of positive elments
  */

  @ BSS section
      .bss
  @ DATA SECTION
      .data
Program_Summary_Msg : .asciz "Un sorted Array search:\n - Input\n 1)Array length\n 2)Array elemets \n 3)Element to serach\n -Output\n 1)Index of the srach element in the array \n 2)-1, if the element is not found in array\n\n"

Input_Array_Len_Msg: .asciz "Enter array length->"
Input_Array_Element_Msg: .asciz "Input array elements\n"
Input_Single_Element_Msg: .asciz "Enter the element -> "
Search_Elem_Input_Msg: .asciz "Input the element to search -> "
Index_Found_Msg: .asciz "Index of search element:"
.align

array_length: .word 0
data_array: .space 20
search_element: .word 0
index: .word 0


  @ TEXT section
      .text


.globl _main
.equ SWI_PrStr,0x69     @ Write a null-ending string 
.equ SWI_GetInt, 0x6c   @ Get int
.equ SWI_PrInt,0x6b     @ Write an Integer
.equ SWI_Exit, 0x11     @ Stop execution
.equ Stdout, 1          @ Set output target to be Stdout
.equ Stdin,  0

ret_val .req R3
_main:

@Print program intro
MOV R0, #Stdout
LDR R1, =Program_Summary_Msg
SWI SWI_PrStr

@Print message to input array length
MOV R0, #Stdout
LDR R1, =Input_Array_Len_Msg
SWI SWI_PrStr 

@Get array length and store in array_length
MOV R0, #Stdin
SWI SWI_GetInt
LDR R1, =array_length
STR R0, [R1]

@Print message to input array elemets
MOV R0, #Stdout
LDR R1, =Input_Array_Element_Msg
swi SWI_PrStr

@Start Code - to Store input elemets to the array
MOV R2, #0 @array index

LDR R3, =array_length @get the address of array_length
LDR R3, [R3] @get the length of array

LDR R4, =data_array @get the starting address of data_array

input_array_loop:
CMP R2, R3 @loop terminates when array index is equal to the length of the array
BEQ end_input_array_loop

@Print message to input single array element at a time
MOV R0, #Stdout
LDR R1, =Input_Single_Element_Msg
SWI SWI_PrStr

@Get the integers
MOV R0, #Stdin
SWI SWI_GetInt

@Store the input element in the array
STR R0, [R4, R2, LSL#2] @[R0]->[[R4] + 4 * [ R2 ]]

ADD R2, #1 @increment array index
B input_array_loop
end_input_array_loop:
@End Code - to Store input elemets to the array

@Print message to input search element
MOV R0, #Stdout
LDR R1, =Search_Elem_Input_Msg
SWI SWI_PrStr

@Get search_element
MOV R0, #Stdin
SWI SWI_GetInt
LDR R1, =search_element
STR R0, [R1]

LDR R0, =array_length @get the address of array_length
LDR R0, [R0] @get the length of array

LDR R1, =data_array @get the starting address of array_length

LDR R2, =search_element @get the address of search_element
LDR R2, [R2] @get the element to search in array

BL SEARCH @function call to get array index of the search_element

LDR R4, =index @ load address of index
STR ret_val, [R4]@Store index

MOV R0, #Stdout
LDR R1, = Index_Found_Msg
SWI SWI_PrStr

MOV R0, #Stdout
LDR R1, =index @ load address of index
LDR R1, [R1] @load index
SWI SWI_PrInt
 
SWI SWI_Exit

//==================================================================================
// Search in unordered array
// Input (arg0 - R0) - length of array
// Input (arg1 - R1) - starting address of array
// Input (arg2 - R2) - element to search
// Output(ret_val - R3) - Index of the srach element in the array,
//                           -1, if the element is not found in array,
//=====================================================================================

SEARCH:
PUSH {R4, R5, SL, FP, LR}

MVN ret_val, #0 @initialize ret_val to -1
MOV R4, #0 @initialize array index to 0

arg0 .req R0
arg1 .req R1
arg2 .req R2

loop:
CMP arg0, R4 @loop terminates when array index is equal to the length of the array
BEQ end_loop
LDR R5, [arg1, R4, LSL#2] @R5<- [ [R1] + 4 * [ R4 ] ]
ADD R4, #1 @increment array index
CMP R5, arg2 @compare array[index] with search_element, if equal move index to ret_val and end the loop
MOVEQ ret_val, R4
BEQ end_loop
B loop
end_loop:
POP {R4, R5, SL, FP, PC}

.unreq arg0
.unreq arg1
.unreq arg2
.unreq ret_val
.end

