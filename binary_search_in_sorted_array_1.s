
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
Program_Summary_Msg : .asciz "Binary Search in sorted Array, in ascending order:\n - Input\n 1)Array length\n 2)Array elemets \n 3)Element to serach\n -Output\n 1)Index of the srach element in the array \n 2)-1, if the element is not found in array\n\n"

Input_Array_Len_Msg: .asciz "Enter array length->"
Input_Array_Element_Msg: .asciz "Input array elements\n"
Input_Single_Element_Msg: .asciz "Enter the element -> "
Search_Elem_Input_Msg: .asciz "Input the element to search -> "
Index_Found_Msg: .asciz "Index of search element:"
.align

array_length: .word 5
data_array: .word 9, 10, 25, 43, 100
search_element: .word 10
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
// Binary Search in sorted array, sorted in increasing order 
// Input (arg0 - R0) - length of array
// Input (arg1 - R1) - starting address of array
// Input (arg2 - R2) - element to search
// Output(ret_val - R3) - Index of the srach element in the array,
//                           -1, if the element is not found in array,
//=====================================================================================
/*
 int left = 0;
 int right = array_len - 1;
 int middle = 0;
 int index = -1;

 while(left <= right)
 {
  middle = ( left + right) / 2;

  if( array[ middle ] < search_element )
  {
   left = middle + 1;
   continue;
  }

  if( array[ middle ] > search_element )
  {
   right = middle - 1;
   continue;
  }

  index = middle + 1;
  break;
 }*/
SEARCH:
PUSH {R4, R5, R6, R7, SL, FP, LR}

MVN ret_val, #0 @initialize ret_val to -1

arg0 .req R0
arg1 .req R1
arg2 .req R2
left .req R4
right .req R5
middle .req R6

MOV left, #0 @left = 0
SUB right, arg0, #1 @right = array_len - 1

loop:
CMP left, right @loop till left <= right
BGT end_loop

@middle = ( left + right) / 2
ADD middle, left, right
LSR middle, #1

LDR R7, [arg1, middle, LSL#2] @load array[middle] i.e. [R7]<- [ [arg1] + 4 * [ middle ] ]

CMP R7, arg2 @compare array[middle] with search_element
BGT look_in_left_half @search_element < array[middle], look in left half
BEQ element_found @search_element == array[middle]

@search_element > array[middle], look in right half
@left = middle + 1
MOV left, middle
ADD left, #1
B loop

look_in_left_half:
@right = middle - 1
MOV right, middle
SUB right, #1
B loop

element_found:
@index = middle + 1
MOV ret_val, middle
ADD ret_val, #1
end_loop:

POP {R4, R5, R6, R7, SL, FP, PC}

.unreq arg0
.unreq arg1
.unreq arg2
.unreq ret_val
.end

