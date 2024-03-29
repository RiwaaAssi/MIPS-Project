.data
    file: .asciiz "C:\\Users\\Dell\\Desktop\\BZU\\ENCS\\ENCS4370\\Tool\\calendar.txt"
    colom: .asciiz ":"
    error_msg: .asciiz "There was an error opening the file.\n"
    error_input: .asciiz "Your Entered Value unvaild\n"
    space_line:"==============================================\n"
    newline: .asciiz "\n"
    welcome: .asciiz "\n\nWelcome to Calendar Program\nChoose one from the menu .e.g (1,2..,5)\n"
    welcome_choice_one: .asciiz "1. View calendar for a day.\n"
    welcome_choice_two: .asciiz "2. View statistics.\n"
    welcome_choice_three: .asciiz "3. Add new appointment.\n"
    welcome_choice_four: .asciiz "4. Delete appointment\n"
    welcome_choice_five: .asciiz "5. Exit.\n"
    choice_one_options: .asciiz "Choose one of the following: .e.g(1,2,3):\n1. per day\n2. per set of days\n3. A given slot in a given day.\n"
    choice_one_op_one: .asciiz "Enter the number of day per mouth .e.g. (1,..31)\n"
    choice_one_op_two: .asciiz "Enter the set of day per mouth.e.g.1,2..\n"
    choice_one_op_three_part1: .asciiz "Enter the number day per mouth.(1,..31)\n"
    choice_one_op_three_start_slot: .asciiz "\nEnter the start hour of the slot\n"
    choice_one_op_three_end_slot: .asciiz "\nEnter the end hour of the slot\n"
    not_found_msg: .asciiz "\nThe day you want does not found in your Calendar\n"
    space: .asciiz "  "
    buffer: .space 256
    per_day_buffer: .space 256
    get_Days_buffer: .space 256
    choice_two_options: .asciiz "Choose one of the following: .e.g(1,2,3):\n1. Number of lectures (in Hours)\n2. Number of OH (in Hours)\n3. Number of Meetings (in Hours)\n4. Average of Lectures per day\n5. Ratio between Number of Lectures and Number of OH\n"
    avg: .asciiz "The average of Lectures per day equals:\n"
    ratio: .asciiz "The ratio between L and OH equals:\n"
    conflict_msg: .asciiz "Sorry,Conflict is happend\n "
    buffer_size: .word 200  # Adjust the size based on your buffer
    day_number: .asciiz "Enter the Day Number:"
    slot_buffer: .space 10  # Adjust the size based on your input requirements
    type_prompt: .asciiz "Enter appointment type (L/OH/M): "
    type_buffer: .space 10  # Adjust the size based on your input requirements
    slot_number: .asciiz "Enter number of slots"
    not_found_slot: .asciiz "\nThe Slot you want does not found in this day\n\n"
    empty_day_msg: .asciiz "\n\nYour Day is Empty!\n\n"
    resulted_buffer: .space 256
    new_slot_buffer: .space 256
    buffer_new: .space 256
    deleted_buffer: .space 256
    no_deleted_msg: "\nThe Slot does not Exist!!\n\n"
.text
.globl main
main:
 #------------------ Open the file------------------------
    li $v0, 13               # System call code for open file
    la $a0, file             # Load the file name into $a0
    li $a1, 0                # Flags: 0 for read-only
    syscall    
    move $s0, $v0            # Save the file descriptor in $s0
    bnez $v0, read           # If $v0 is not 0, continue to read
    # Error handling
    li $v0, 4                # System call code for print_str
    la $a0, error_msg        # Load the address of the error message
    syscall
    j close_file             # Jump to close the file and exit
    
read:     
    # Read the file line by line
    li $v0, 14               # System call code for read file
    move $a0, $s0            # File descriptor
    la $a1, buffer           # Buffer to store the line
    li $a2, 256             # Maximum number of characters to read
    syscall
    
# Print the line
  #  li $v0, 4                # System call code for print_str
  #  la $a0, buffer           # Load the address of the buffer
  #  syscall
   
close_file:
    # Close the file
    li $v0, 16               # System call code for close file
    move $a0, $s0            # File descriptor
    syscall
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
 #------------------ Printing the Menu ---------------------

    li $v0,4
    la $a0, welcome
    syscall
    
    li $v0,4
    la $a0, welcome_choice_one
    syscall
    
    li $v0,4
    la $a0, welcome_choice_two
    syscall
    
    li $v0,4
    la $a0, welcome_choice_three
    syscall
    
    li $v0,4
    la $a0, welcome_choice_four
    syscall
    
    li $v0,4
    la $a0, welcome_choice_five
    syscall
     
 # Reading the Chosen Value 
    li $v0,5
    syscall

 
 # Empty the Buffer from Previous Values    
   la $a0, per_day_buffer
   li $a1, 256
   jal empty_buffer
   
 # Possible Chosen Value    
    li $t1,1
    li $t2,2
    li $t3,3
    li $t4,4
    li $t5,5
    move $s4,$v0
    
    beq $s4,$t1,print_fun 
 
    beq $s4,$t2,state
    
    beq $s4,$t3,addition
    
    beq $s4,$t4,delete

    beq $s4,$t5,exit

    
    la $a0,error_input
    li $v0, 4
    syscall
    
    j main
  
exit:
    # Exit
    li $v0, 10               # System call code for exit
    syscall

 
  
############################################################# Choice One Function ######################################################          
print_fun:
start:  
#Priting the Choices of Option One
    la $a0,space_line
    li $v0, 4
    syscall
    
    la $a0,choice_one_options
    li $v0, 4
    syscall
    
#Read the Choice 
    li $v0, 5
    syscall
  
#Comparing the Readed Value 
    li $t1 ,1 
    li $t2, 2
    li $t3, 3
    
    beq $v0, $t1, choice_one
    beq $v0, $t2, choice_two
    beq $v0, $t3, choice_three
    
    la $a0,error_input
    li $v0, 4
    syscall
    j start
 
#================================================  Option One  ==============================================  
choice_one:
#Printing the Choices of Option One 
start_choice_one:
    la $a0,space_line
    li $v0, 4
    syscall
    
    la $a0,choice_one_op_one
    li $v0, 4
    syscall
    
#Read the Choice
    li $v0, 5
    syscall  
    
#Check if the Number is in the wanted Range 
    li $t6, 31
    bgt $v0,$t6,error_choice_one
    bltz $v0,error_choice_one
    
# Empty the Buffer from Previous Values    
   la $a0, per_day_buffer
   li $a1, 256
   jal empty_buffer
   
    move $s1,$v0
    jal find_line
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    j main
#================================================  Option Two ==============================================  
choice_two:
    la $a0,space_line
    li $v0, 4
    syscall
    
    la $a0,choice_one_op_two
    li $v0, 4
    syscall
# Read the Day Numbers from the User
    li $v0,8
    la $a0,get_Days_buffer
    li $a1,265
    syscall
    
    move $t6,$a0  #Pointer of the Buffer   
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $t7, 44    # ASCII code for ','
    lb $t3, newline    # Load the newline character into $t3
    
start_slot2:        #1,11,4
   lb $t0,0($t6)        #Read the first Char
   beq $t0, $t7, inc    # if $t0 equals the comma, $t6 = $t6 ++
   lb $a1,1($t6)        #Read the Second Char
   
   blt $a1, $t4, comma
   bgt $a1, $t5, comma
   beqz $a1, comma
   beq $a1,$t3, comma
   
   subi $t0,$t0,48          # Convert from String to Integer
   move $a0,$t0
   jal convert_and_contact
   move $t0,$v0
   addi $t6,$t6,2  
   j conti 
   
comma:
   beqz $t0, end_of_option2
   beq $t0,$t3, end_of_option2
   subi $t0,$t0,48          # Convert from String to Integer   
conti:  
    #Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    la $a0,space_line
    li $v0, 4
    syscall

# Empty the Buffer from Previous Values    
   la $a0, per_day_buffer
   li $a1, 256
   jal empty_buffer
   
   move $s1,$t0
   jal find_line
   
    addi $t6,$t6,1
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $t7, 44    # ASCII code for ','
    lb $t3, newline    # Load the newline character into $t3
  
   j start_slot2
   
inc:
   addi $t6,$t6,1
   j start_slot2
   
end_of_option2:   
    j main
    
#================================================  Option Three ==============================================  
choice_three:
    la $a0,space_line
    li $v0, 4
    syscall
    
#Print the Options of Choice one Part 3
    la $a0,choice_one_op_three_part1
    li $v0, 4
    syscall
    
# Read the Input Day 
    li $v0, 5
    syscall 
    
    move $s1,$v0
    
# Check the Validity of the Input Day    
    li $t6, 31
    bgt $v0,$t6,error_choice_one_part3
    bltz $v0,error_choice_one_part3
    
# Print Space Line
    la $a0,space_line
    li $v0, 4
    syscall   
            
#Get the Line    
   
    jal find_line
    
# If the find_line Function does not find the desired Day, then try again
    la $t6,not_found_msg
    beq $t6,$a0, choice_three
    
# Check is the Day is Empty or Not    
    la $t9, per_day_buffer 
    la $a0,newline
    li $a1,13
    
find_if_empty_choice_Three:
    lb $t3,colom
    lb $t0, 0($t9)   # Load the current character

    #beqz $t0, next_line  # If it's null (end of line), move to the next line
    beq $t0, $t3, found_if_empty_choice_Three # If it's ":", we found it
    addi $t9, $t9, 1   # Move to the next character

    j find_if_empty_choice_Three
       
found_if_empty_choice_Three:
    lb $t0,1($t9)
    li $a0,10
    li $a1,13
    beqz $t0,empty_day_choice_three
    beq $t0,$a0,empty_day_choice_three  
    beq $t0,$a1,empty_day_choice_three   
   
    
# Print the start hour of the slot
ReadStartHour:
    la $a0,choice_one_op_three_start_slot
    li $v0, 4
    syscall
    
#Read the start hour of the slot    
    li $v0, 5
    syscall 

#Transfer the Hour into 24 Hour format 
    move $a0, $v0
    jal Transfer_fun
    move $s3,$v0
    
#Check the Validity of the Input Hour
HourRead1:
    li $t6, 17
    li $t7, 8
    bge $s3,$t6,error_choice_one_part3_HourPart1
    blt $s3,$t7, error_choice_one_part3_HourPart1
    
#Print the end hour of the slot
ReadEndHour:
    la $a0,choice_one_op_three_end_slot
    li $v0, 4
    syscall
    
#Read the end hour of the slot    
    li $v0, 5
    syscall 
    
# Transfer the Hour into 24 Hour format    
    move $a0, $v0
    jal Transfer_fun
    move $s4,$v0
    
# Check the Validity of the Input Hour    
HourRead2:
    li $t6, 17
    li $t7, 8
    bgt $s4,$t6,error_choice_one_part3_HourPart2
    ble $s4,$t7, error_choice_one_part3_HourPart2
        
#cont:  
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $t9, 0    # Pointer Register
    li $t8, 0    # Test1 Register 
    li $t3, 0    # Test2 Register
    li $t7,79    # O Character Regiter
    li $t6,72    # H Character Regiter 
    li $t0,0     # Start Hour of Slot Regiter
    li $t1,0     # End Hour of Slot Regiter
    li $t2,0     # Type of Appointment Regiter
    la $t9,per_day_buffer    #$t9 is a pointer to the begining of the wanted Line    
     
find_colon1:
    lb $t8,colom
    lb $t0, 0($t9)   # Load the current character
    #beqz $t0, next_line  # If it's null (end of line), move to the next line
    beq $t0, $t8, found_colon1 # If it's ":", we found it
    addi $t9, $t9, 1   # Move to the next character
    j find_colon1     
found_colon1:
    addi $t9,$t9,1  
    
start_slot:        
   lb $t0,0($t9)            # Start of the Slot
   subi $t0,$t0,48          # Convert from String to Integer  
   addi $t9,$t9,1           # $t9 Point to the "-"
   lb $a1,0($t9)  
   blt $a1, $t4, not_a_Num
   bgt $a1, $t5, not_a_Num
   move $a0,$t0
   jal convert_and_contact
   move $t0,$v0
   addi $t9,$t9,2
get_end:                     #8-9 L, 10-12 OH, 12-2 M

   move $a0, $t0
   jal Transfer_fun
   move $t0,$v0
   
   lb $t1,0($t9)            # End of the Slot
   subi $t1,$t1,48          # Convert from String to Integer   
   addi $t9,$t9,1           # $t9 is the Type of appointment
get_Appointment:
   lb $t2,0($t9)            # Type of Appointment
   blt $t2, $t4, end_not_a_number     # Check if $t2 is greater than or equal to '0' and less than or equal to '9'
   bgt $t2, $t5, end_not_a_number
   move $a0, $t1
   move $a1,$t2
   jal convert_and_contact
   move $t1,$v0
   addi $t9,$t9,1
   j get_Appointment  
not_a_Num:
   addi $t9,$t9,1   
   j get_end  
end_not_a_number:
   bne $t2,$t7,continue
   addi $t9,$t9,1
continue: 
   move $a0, $t1
   jal Transfer_fun
   move $t1,$v0

# Start Comparison
match_test:       #9  2  8-9 1-2
  bgt $t0, $s4, end_choice3_part3
  blt $t0, $s3,range_test
  bne $t0,$s3,range_test
  #bgt $t0, $s4, end_choice3_part3
  beq $t0,$s4,found_end_slot
  j found_start_slot
 
range_test:
  beq $t0,$s4,found_end_slot
  #bgt $t0, $t3, found_mid_slot
  bgt $t0, $s3, found_mid_slot
  addi $t0,$t0,1
  ble $t0,$t1,match_test
  lb $t8,0($t9)            # Start of the Slot
  #bnez $t8,start_slot
  bnez $t8,increment_choice_three
  
mid_test:
  bgt $t0,$s4,end_choice3_part3
  j found_mid_slot
  
mid_range_test:
  addi $t0,$t0,1
  ble $t0,$t1,mid_test
 # beq $t0,$s4,found_end_slot
  addi $t9,$t9,2           # $t9 Points to the Next Slot
  lb $t8,0($t9)            # Start of the Slot
  bnez $t8,start_slot 
      
  
end_buffer:
  #  la $a0,not_found_msg
   # li $v0, 4
   # syscall
    j main  # Return to Welcome Menu  
  
found_start_slot:
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    la $a0,space_line
    li $v0, 4
    syscall
    
# Return the Hour into 12 Format 
    move $a0, $t0     
    jal Return_fun
    move $t3,$v0
    
    li $v0, 1
    move $a0, $t3
    syscall
  
    li $v0, 4
    la $a0 space
    syscall

    bne $t2,$t7,Next
    
#Print OH
    li $v0, 11
    li $a0, 79
    syscall
  
    li $v0, 11
    li $a0, 72
    syscall
    
    j mid_range_test
Next:
    #addi $t9,$t9,2
    move $a0, $t2
    li $v0, 11
    syscall
    j mid_range_test
    
found_mid_slot:
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
# Return the Hour into 12 Format  
    move $a0, $t0  
    jal Return_fun
    move $t3,$v0
  
    li $v0, 1
    move $a0, $t3
    syscall
  
    li $v0, 4
    la $a0 space
    syscall

    bne $t2,$t7,Next1
    
#Print OH
    li $v0, 11
    li $a0, 79
    syscall
  
    li $v0, 11
    li $a0, 72
    syscall
    
    j mid_range_test
    
Next1: 
    move $a0, $t2
    li $v0, 11
    syscall
    j mid_range_test
    
found_end_slot:
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall

# Return the Hour into 12 Format 
    move $a0, $t0     
    jal Return_fun
    move $t3,$v0
        
    li $v0, 1
    move $a0, $t3
    syscall
  
    li $v0, 4
    la $a0 space
    syscall

    bne $t2,$t7,Next2
    
#Print OH
    li $v0, 11
    li $a0, 79
    syscall
  
    li $v0, 11
    li $a0, 72
    syscall
    
    j main
    
Next2:
    move $a0, $t2
    li $v0, 11
    syscall
    j main
                
error_choice_one_part3_HourPart1:
    la $a0,error_input
    li $v0, 4
    syscall
    j ReadStartHour
    
error_choice_one_part3_HourPart2:
    la $a0,error_input
    li $v0, 4
    syscall
    j ReadEndHour
    
error_choice_one_part3:
    la $a0,error_input
    li $v0, 4
    syscall
    j choice_three
          
end_choice3_part3:
    j main  #Retrun to Welcome Menu
    
increment_choice_three:
   addi $t9,$t9,2
   j start_slot    
   
empty_day_choice_three: 
   la $a0, empty_day_msg
   li $v0,4
   syscall
   j main     
##################################################### Find Day Function ######################################################       
find_line:
# Initialize pointers
    la $t0, buffer       # Pointer to the beginning of the buffer
    la $t1, buffer       # Pointer to the current character in the buffer
    lb $t3, newline    # Load the newline character into $t3
    la $t9,per_day_buffer 
    li $t7, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $s2,0
    li $s3,0

process_next_line:
# Load the first byte of the current line from the buffer
    lb $t2, 0($t1)
  
# Test if the Day have two digit
    addi $t8, $t1,1
    lb $t4,0($t8)
    blt $t4, $t7, contt
    bgt $t4, $t5, contt
    li $s2,1
    move $s3,$t2     #Move the first char here
    move $a0,$t2
    subi $a0,$a0,48
    move $a1,$t4
    subi $a1,$a1,48          # Convert from String to Integer    
    mul $a0,$a0,10
    add $v0,$a0,$a1    
    move $t2,$v0
    addi $t2,$t2,48
     
contt:
  
    # Check for the end of the line or end of the buffer
    beqz $t2, end_of_buffer
    beq $t2,$t3, end_of_line

    # Check if the first byte of the current line is equal to the given number
    move $t4,$t2
    subi $t4,$t4,48
    bne $t4, $s1, next_line
    sub $t4, $t1, $t0   # Calculate the length of the current line
    bnez $s2,Label
contt2:
    j print_line_loop
    
next_line:
    lb $t2, 0($t1)
    # Check for the end of the line or end of the buffer
    beqz $t2, end_of_buffer
    beq $t2,$t3, end_of_line
    addi $t1, $t1, 1
    j next_line
    
print_line_loop:  
    sb $t2,0($t9)
    addi $t1, $t1, 1
    addi $t9,$t9,1 
    lb $t2, 0($t1)
    beqz $t2, print_line
    beq $t2,$t3, print_line
    j print_line_loop
    
print_line:
 # Print the line
    li $v0, 4                # System call code for print_str
    la $a0, per_day_buffer           # Load the address of the buffer
    syscall
    j end_choice_one
    
end_of_line:
# Move to the next line
    addi $t1, $t1, 1      
    j process_next_line

end_of_buffer:
    la $a0,not_found_msg
    li $v0, 4
    syscall
    jr $ra  # Return      
      
error_choice_one:
    la $a0,error_input
    li $v0, 4
    syscall
    j start_choice_one
     
end_choice_one:
    jr $ra
Label:
  move $t2,$s3
  j contt2
     
###############################################    Convert and Contact Function     ######################################################          
convert_and_contact:
   subi $a1,$a1,48          # Convert from String to Integer    
   mul $a0,$a0,10
   add $v0,$a0,$a1    
   jr $ra

############################################## Transfer the Hour into 24 Hour format #######################################################
   
Transfer_fun:
    li $a1 , 7
    bgt $a0,$a1,NoEffect  # if $v0 > 7 ; Branch
    addi $v0,$a0,12
    jr $ra
    
NoEffect:
    move $v0,$a0
    jr $ra

############################################## Return the Hour into 12 Hour format #######################################################
   
Return_fun:
    li $a1,12
    bgt $a0, $a1 ,return_12Form
    move $v0,$a0
    jr $ra

return_12Form: 
   subi $a0,$a0,12
   move $v0,$a0
   jr $ra
   
#############################################           Empty the Buffer          ##########################################################
empty_buffer:
    li $t8, 0          # Null character ASCII code

loop:
        # Store a null character in the buffer
        sb $t8, 0($a0)

        # Move to the next byte in the buffer
        addi $a0, $a0, 1

        # Decrement the size counter
        subi $a1, $a1, 1

        # Check if the buffer is fully cleared
        bnez $a1, loop

    jr $ra  # Return
    
####################################################  Choice Two Function  ######################################################               
state:
   
#Print Choice Two Options 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    
    li $v0,4
    la $a0,choice_two_options
    syscall
    
# Read Choosen Value
    li $v0,5
    syscall
       
# Comparison 
    li $t1,1
    li $t2,2
    li $t3,3
    li $t4,4
    li $t5,5
    
    move $v1,$v0
    bge $v0,$t1,num_Lecture
    ble $v0,$t5,num_Lecture
   
    la $a0,error_input
    li $v0, 4
    syscall
    j state
      
num_Lecture:
# Initialize Registers

   li $s0,0  #Number of Lectures
   li $s1,0 #Number of Meetings
   li $s3,0 #Number of OH
   li $s4,0 #Number of Days
   li $s5, 77 # M Character Regiter
   li $s6, 76 # L Character Regiter
   li $t7,79    # O Character Regiter
   li $s7,72    # H Character Regiter 
    li $t0,0     # Start Hour of Slot Regiter
    li $t1,0     # End Hour of Slot Regiter
    li $t2,0     # Type of Appointment Regiter
    li $t3, 0    # Test2 Register
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    lb $t6, newline    # Load the newline character into $t3   
    li $t8, 0    # Test1 Register 
    li $t9, 0    # Pointer Register
    la $t9,buffer
    lb $t8,colom
     
find_colon:
    lb $t0, 0($t9)   # Load the current character
   # beqz $t0, next_line  # If it's null (end of line), move to the next line
   beqz $t0,end_of_buffer_choice2 
    beq $t0, $t8, found_colon  # If it's ":", we found it
    addi $t9, $t9, 1   # Move to the next character
    j find_colon     
found_colon:
    addi $t9,$t9,1 
    li $a0,10
    li $a1,13
    lb $t0,0($t9)
    beqz $t0,inc_next_day
    beq $t0,$a0,inc_next_day 
    beq $t0,$a1,inc_next_day  
# Start Processing     
start_proc:        

   lb $t0, 0($t9)   # Start Hour of the Slot  
   subi $t0,$t0,48          # Convert from String to Integer  
   addi $t9,$t9,1           # $t9 Point to the "-"
   lb $a1,0($t9)  
   blt $a1, $t4, not_a_Num2
   bgt $a1, $t5, not_a_Num2
   move $a0,$t0
   jal convert_and_contact
   move $t0,$v0
   addi $t9,$t9,2
get_end2:                     
   move $a0, $t0
   jal Transfer_fun
   move $t0,$v0
  
   lb $t1,0($t9)            # End of the Slot
   subi $t1,$t1,48          # Convert from String to Integer   
   addi $t9,$t9,1           # $t9 is the Type of appointment
get_Appointment2:
   lb $t2,0($t9)            # Type of Appointment
   blt $t2, $t4, end_not_a_number2     # Check if $t2 is greater than or equal to '0' and less than or equal to '9'
   bgt $t2, $t5, end_not_a_number2
   move $a0, $t1
   move $a1,$t2
   jal convert_and_contact
   move $t1,$v0
   addi $t9,$t9,1
   j get_Appointment2  
   
not_a_Num2:
   addi $t9,$t9,1   
   j get_end2  
   
end_not_a_number2:
   bne $t2,$t7,continue2
   addi $t9,$t9,1
continue2: 

   move $a0, $t1
   jal Transfer_fun
   move $t1,$v0

# Start Comparison
  beq $t2, $s5 , get_M
  beq $t2, $s6, get_L
  beq $t2, $t7, get_OH
  
get_next_slot:  
  addi $t9,$t9,2
  li $t6,13
#Test if the line ends
  subi $t8, $t9,1  
  lb $t3,0($t8)
  beq $t3,$t6,end_of_line_choice2
  li $t6,10
 # beqz $t3, end_of_buffer_choice2 
  beq $t3,$t6, end_of_line_choice2
 
  j start_proc
  
get_M:
  sub $t3, $t1, $t0
  add $s1,$s1,$t3
  j get_next_slot
  
  
get_L:
  sub $t3, $t1, $t0
  add $s0,$s0,$t3
  j get_next_slot
  
get_OH:
  #addi $t9,$t9,1  
  sub $t3, $t1, $t0
  add $s3,$s3,$t3
  j get_next_slot 


end_of_buffer_choice2:
    li $t1,1
    li $t2,2
    li $t3,3
    li $t4,4
    li $t5,5
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall

# Brach Conditions      
  beq $v1,$t1,Lecture
  beq $v1,$t2,OH
  beq $v1,$t3,Meeting
  beq $v1,$t4,Average
  beq $v1,$t5,Ratio
  
Meeting:    
# Print Number of Meetings    
    li $v0,11
    move $a0,$s5
    syscall
    
    la $a0,space
    li $v0, 4
    syscall
    
    li $v0,1
    move $a0 ,$s1
    syscall
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall    
     j main 
  
      
OH:
# Print Number of OH       
    li $v0,11
    move $a0,$t7
    syscall
    
     li $v0,11
    move $a0,$s7
    syscall
    
    la $a0,space
    li $v0, 4
    syscall
    
    li $v0,1
    move $a0 ,$s3
    syscall
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
     j main 

# Print Number of Lectures     
Lecture:
    li $v0,11
    move $a0,$s6
    syscall
    
    la $a0,space
    li $v0, 4
    syscall
    
    li $v0,1
    move $a0 ,$s0
    syscall
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    j main 
Average:
    la $a0,avg
    li $v0,4
    syscall
    
  #  divu $s0,$s4
   ## mflo $t0
   # mtc1 $t0 , $f12
   # cvt.s.w $f12, $f12  # Convert integer to floating-point
    
    mtc1 $s0, $f4       # Move $s0 to $f4
    mtc1 $s4, $f6       # Move $s3 to $f6
    div.s $f12, $f4, $f6  # Floating-point division
    
    li $v0,2
    syscall
    
    #Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    j main
Ratio:  
   la $a0,ratio
    li $v0,4
    syscall
    
  #  divu $s0,$s3
  #  mflo $t0
  #  mtc1 $t0 , $f12
  #  cvt.s.w $f12, $f12  # Convert integer to floating-point
    mtc1 $s0, $f4       # Move $s0 to $f4
    mtc1 $s3, $f6       # Move $s3 to $f6
    div.s $f12, $f4, $f6  # Floating-point division
      
    li $v0,2
    syscall
    
    #Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    j main  

end_of_line_choice2:  
  addi $s4,$s4,1 
  addi $t9,$t9,1
  lb $t8,colom
  j find_colon
         
end_choice_two:
   j main
   
inc_next_day:
   addi $t9,$t9,1
   j find_colon   
###################################################    Choice Three  Function  ######################################################
addition:
# User-provided information
#Read Day Number
    li $v0, 4             # System call code for print_str
    la $a0, day_number  # Print slot prompt
    syscall
   
    
    li $v0, 5             # System call code for read integer
    syscall  
    move $s6,$v0
    
#Print the Day Line      
    move $s1,$v0
    jal find_line
    la $t0, not_found_msg
    beq $a0,$t0,addition
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall  
    
#get Slot Hours        
get_slot_start: 
    li $v0, 4            # System call code for print_str
    la $a0, choice_one_op_three_start_slot   # Print slot prompt
    syscall
    
    li $v0, 5           # System call code for print_str
    syscall
    
    move $a0,$v0
    jal Transfer_fun
       
    li $t6, 17
    li $t7, 8
    bge $v0,$t6,get_slot_start
    blt $v0,$t7,get_slot_start
    
    move $s0,$v0
    
#Print the end hour of the slot
get_slot_end: 
    la $a0,choice_one_op_three_end_slot
    li $v0, 4
    syscall
   
    li $v0, 5             # System call code for print_str
    syscall
    
    move $a0,$v0
    jal Transfer_fun
    
    li $t6, 17
    li $t7, 8
    bgt $v0,$t6,get_slot_end
    ble $v0,$t7,get_slot_end
    
    
    move $s1,$v0 
       



##################################################### Find Time Function ######################################################        
find_time:      
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $t9, 0    # Pointer Register
    li $t8, 0    # Test1 Register 
    li $t3, 0    # Test2 Register
    li $t7,79    # O Character Regiter
    li $t6,72    # H Character Regiter 
    li $t0,0     # Start Hour of Slot Regiter
    li $t1,0     # End Hour of Slot Regiter
    li $t2,0     # Type of Appointment Regiter
    la $t9,per_day_buffer    #$t9 is a pointer to the begining of the wanted Line
    li $s5,0  #flag
   
find_colon2:
    lb $t8,colom
    lb $t0, 0($t9)   # Load the current character
    #beqz $t0, next_line  # If it's null (end of line), move to the next line
    beq $t0, $t8, found_colon2 # If it's ":", we found it
    addi $t9, $t9, 1   # Move to the next character
    j find_colon2    
found_colon2:
    addi $t9,$t9,1 
    li $a0,10
    li $a1,13 
    lb $t0,0($t9)
    beqz $t0,add_empty_day
    beq $t0,$a0,add_empty_day 
    beq $t0,$a1,add_empty_day
    
start_slot1:        
   lb $t0,0($t9)            # Start of the Slot
   beqz $t0,found_space_end
   subi $t0,$t0,48          # Convert from String to Integer  
   addi $t9,$t9,1           # $t9 Point to the "-"
   lb $a1,0($t9)  
   blt $a1, $t4, not_a_Num1
   bgt $a1, $t5, not_a_Num1
   move $a0,$t0
   jal convert_and_contact
   move $t0,$v0
   addi $t9,$t9,2
get_end1:                     #8-9 L, 10-12 OH, 12-2 M

   move $a0, $t0
   jal Transfer_fun
   move $t0,$v0
   
   lb $t1,0($t9)            # End of the Slot
   subi $t1,$t1,48          # Convert from String to Integer   
   addi $t9,$t9,1           # $t9 is the Type of appointment
get_Appointment1:
   lb $t2,0($t9)            # Type of Appointment
   blt $t2, $t4, end_not_a_number1     # Check if $t2 is greater than or equal to '0' and less than or equal to '9'
   bgt $t2, $t5, end_not_a_number1
   move $a0, $t1
   move $a1,$t2
   jal convert_and_contact
   move $t1,$v0
   addi $t9,$t9,1
   j get_Appointment1  
not_a_Num1:
   addi $t9,$t9,1   
   j get_end1  
end_not_a_number1:
   bne $t2,$t7,continue1
   addi $t9,$t9,1
continue1: 
   move $a0, $t1
   jal Transfer_fun
   move $t1,$v0

# Start Comparison
first_match:    
  blt $s0,$t0,check_first
  bgt $t1,$s0,conflict
  addi $t0,$t0,1
  bgt $t0,$t1,increment
  j first_match
 
check_first:
  bnez $s5,middle_test
  blt $s1,$t0,found_space_first
  
   
middle_test:
  blt $s1,$t0,found_space_Middle
  beq $t0,$s1,found_space_Middle
   
conflict:
  la $a0, conflict_msg
  li $v0,4
  syscall 
  j addition
  
increment:
   addi $t9,$t9,2
   addi $s5,$s5,1
   j start_slot1 
#----------------------------------------------------- Add Appointment to Empty Day -------------------------------------------------
add_empty_day:

# Read the type of appointment
    li $v0, 4             # System call code for print_str
    la $a0, type_prompt   # Print type prompt
    syscall
    
    li $v0, 8             # System call code for read string
    la $a0, type_buffer   # Buffer to store type input
    li $a1, 10            # Maximum number of characters to read
    syscall

#Store the new Slot Buffer
   la $t8,new_slot_buffer 
   
#Start Hour  
    move $a0,$s0
    jal Return_fun 
    move $s0,$v0 
       
    li $t9,10
    move $a0,$s0
    bge $s0,$t9,divide_empty
    addi $s0,$s0,48
    #addi $t8,$t8,1 
    sb $s0,0($t8) 
    j get_slach_empty
divide_empty: jal divide_contact    
    #addi $t8,$t8,1 
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8) 
get_slach_empty:     
#Slach 
    addi $t8,$t8,1   
    li $s2 ,45
    sb $s2,0($t8)
#End Hour 
    move $a0,$s1
    jal Return_fun 
    move $s1,$v0   
    move $a0,$s1
    bge $s1,$t9,divide1_empty
   addi $t8,$t8,1    
    addi $s1,$s1,48
    sb $s1,0($t8)     
    j get_type_empty
divide1_empty: jal divide_contact    
          
    addi $t8,$t8,1
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8)  

get_type_empty:          
#Type   
    addi $t8,$t8,1
    la $s3, type_buffer 
    lb $s4,0($s3)
    sb $s4,0($t8) 
    bne $s4,$t7,conttt_empty
add_one_empty:
    addi $t8,$t8,1
    addi $s3,$s3,1
    lb $s4,0($s3) 
    sb $s4,0($t8) 
conttt_empty:     
    addi $t8,$t8,1
    li $t2 ,0
    sb $t2,0($t8)
###########################################################################  
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,new_slot_buffer 
    syscall 
#############################################################################
    la $t9, per_day_buffer
    la $t8, resulted_buffer
    
store_resulted_buffer_first_empty:    
    lb $t0,0($t9)
    sb $t0,0($t8)
    beq $t0, ':', first_storing_found_empty
   # beqz $t0, done1
    addi $t9, $t9, 1
    addi $t8, $t8, 1
    j store_resulted_buffer_first_empty
    
first_storing_found_empty:    
    addi $t9, $t9, 1 
    addi $t8, $t8, 1 
   
first_storing_empty:
  la $t3,new_slot_buffer 
  
start_first_storing_new_loop_empty:     
     lb $t0,0($t3)
     beqz $t0,print_resulted_buffer_empty
     sb $t0,0($t8)
     addi $t8,$t8,1 
     addi $t3,$t3,1 
     bnez $t0,start_first_storing_new_loop_empty

print_resulted_buffer_empty :
   li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall

    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,resulted_buffer
    syscall 
    
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    la $a0,space_line
    li $v0, 4
    syscall
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    
       move $s1,$s6
       jal update_file
       j main   
             
#----------------------------------------------------- Found Space First ----------------------------------------      
found_space_first:
    move $s7,$t0
# Read the type of appointment
    li $v0, 4             # System call code for print_str
    la $a0, type_prompt   # Print type prompt
    syscall
    
    li $v0, 8             # System call code for read string
    la $a0, type_buffer   # Buffer to store type input
    li $a1, 10            # Maximum number of characters to read
    syscall

#Store the new Slot Buffer
   la $t8,new_slot_buffer 
   
#Start Hour  
    move $a0,$s0
    jal Return_fun 
    move $s0,$v0 
       
    li $t9,10
    move $a0,$s0
    bge $s0,$t9,divide
    addi $s0,$s0,48
    #addi $t8,$t8,1 
    sb $s0,0($t8) 
    j get_slach
divide: jal divide_contact    
    #addi $t8,$t8,1 
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8) 
get_slach:     
#Slach 
    addi $t8,$t8,1   
    li $s2 ,45
    sb $s2,0($t8)
#End Hour 
    move $a0,$s1
    jal Return_fun 
    move $s1,$v0   
    move $a0,$s1
    bge $s1,$t9,divide1
   addi $t8,$t8,1    
    addi $s1,$s1,48
    sb $s1,0($t8)     
    j get_type
divide1: jal divide_contact    
          
    addi $t8,$t8,1
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8)  

get_type:          
#Type   
    addi $t8,$t8,1
    la $s3, type_buffer 
    lb $s4,0($s3)
    sb $s4,0($t8) 
    bne $s4,$t7,conttt
add_one:
    addi $t8,$t8,1
    addi $s3,$s3,1
    lb $s4,0($s3) 
    sb $s4,0($t8) 
conttt: 
#Comma    
  #  addi $t8,$t8,1
  #  li $s2 ,44
   # sb $s2,0($t8)
    
    addi $t8,$t8,1
    li $t2 ,0
    sb $t2,0($t8)
###########################################################################  
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    la $t8,new_slot_buffer 
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,new_slot_buffer 
    syscall 
#############################################################################
    la $t9, per_day_buffer
    la $t8, resulted_buffer
store_resulted_buffer_first:    
    lb $t0,0($t9)
    sb $t0,0($t8)
    beq $t0, ':', first_storing_found
   # beqz $t0, done1
    addi $t9, $t9, 1
    addi $t8, $t8, 1
    j store_resulted_buffer_first
    
first_storing_found:    
    addi $t9, $t9, 1 
    addi $t8, $t8, 1 
   
first_storing:
  la $t3,new_slot_buffer 
start_first_storing_new_loop:     
     lb $t0,0($t3)
     beqz $t0,get_comma
     sb $t0,0($t8)
     addi $t8,$t8,1 
     addi $t3,$t3,1 
     bnez $t0,start_first_storing_new_loop
get_comma:
     lb $t0,0($t9)
     beqz $t0,copy_rest_loop
    # addi $t8,$t8,1
     li $s2 ,44
     sb $s2,0($t8)
     addi $t8,$t8,1
     
         
copy_rest_loop:     
     lb $t0,0($t9)
     sb $t0,0($t8)
     addi $t8,$t8,1
     addi $t9,$t9,1
     bnez $t0, copy_rest_loop

print_resulted_buffer :
   li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall

    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,resulted_buffer
    syscall 
    
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    la $a0,space_line
    li $v0, 4
    syscall
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    
       move $s1,$s6
       jal update_file
       j main   
       
#------------------------------------- Found Space Middle ------------------------------------------------------           
found_space_Middle: 
        move $s7,$t0
        move $a0,$s7
        jal Transfer_fun
        move $s7,$v0
        
# Read the type of appointment
    li $v0, 4             # System call code for print_str
    la $a0, type_prompt   # Print type prompt
    syscall
    
    li $v0, 8             # System call code for read string
    la $a0, type_buffer   # Buffer to store type input
    li $a1, 10            # Maximum number of characters to read
    syscall

#Store the new Slot Buffer
   la $t8,new_slot_buffer 
   
#Start Hour  
    move $a0,$s0
    jal Return_fun 
    move $s0,$v0 
       
    li $t9,10
    move $a0,$s0
    bge $s0,$t9,divide_Middle
    addi $s0,$s0,48
    #addi $t8,$t8,1 
    sb $s0,0($t8) 
    j get_slach_Middle
divide_Middle: jal divide_contact    
    #addi $t8,$t8,1 
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8) 
get_slach_Middle:     
#Slach 
    addi $t8,$t8,1   
    li $s2 ,45
    sb $s2,0($t8)
#End Hour 
    move $a0,$s1
    jal Return_fun 
    move $s1,$v0   
    move $a0,$s1
    bge $s1,$t9,divide1_Middle
    addi $t8,$t8,1    
    addi $s1,$s1,48
    sb $s1,0($t8)     
    j get_type_Middle
divide1_Middle: jal divide_contact    
          
    addi $t8,$t8,1
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8)  

get_type_Middle:          
#Type   
    addi $t8,$t8,1
    la $s3, type_buffer
    lb $s4,0($s3)
    sb $s4,0($t8) 
    bne $s4,$t7,conttt_Middle
add_one_Middle:
    addi $t8,$t8,1
    addi $s3,$s3,1
    lb $s4,0($s3) 
    sb $s4,0($t8) 
conttt_Middle: 
#Comma    
  #  addi $t8,$t8,1
  #  li $s2 ,44
   # sb $s2,0($t8)
    
    addi $t8,$t8,1
    li $t2 ,0
    sb $t2,0($t8)
###########################################################################  
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    
  #   la $t8,new_slot_buffer 
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,new_slot_buffer 
    syscall 
#########################################################################################    
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $t9, 0    # Pointer Register
    li $t8, 0    # Test1 Register 
    li $t3, 0    # Test2 Register
    li $t6,0    # Test3 Regiter 
    li $t7,79    # O Character Regiter
    li $t0,0     # Start Hour of Slot Regiter
    li $t1,0     # End Hour of Slot Regiter
    li $t2,0     # Type of Appointment Regiter
  
    la $t9, per_day_buffer
    la $t8, resulted_buffer
    
store_resulted_buffer_Middle:    
    lb $t0,0($t9)
    sb $t0,0($t8)
    beq $t0, ':', Middle_storing_found
   # beqz $t0, done1
    addi $t9, $t9, 1
    addi $t8, $t8, 1
    j store_resulted_buffer_Middle
    
Middle_storing_found:
   addi $t9, $t9, 1  
   addi $t8, $t8, 1
   
Middle_storing:
 
#Store Start    
   lb $t0,0($t9)            # Start of the Slot
   beqz $t0,print_Middle_resulted_buffer 
   subi $t3,$t0,48          # Convert from String to Integer  
   move $t6,$t3
   
    lb $s2,1($t9)
    blt $s2, $t4, check_found
    bgt $s2, $t5, check_found
get_test:    
    
   beq $t3,$s7,start_Middle_storing_new
   
   
#Store Slach
   addi $t9,$t9,1           # $t9 Point to the "-"
  # addi $t8, $t8, 1
   lb $a1,0($t9)   
   blt $a1, $t4, not_a_Num3
   bgt $a1, $t5, not_a_Num3
   move $s5,$a1
   
   move $a0,$t6
   jal convert_and_contact
   move $t3,$v0
# Store Start Two Digit  
   move $a0, $t3
   jal Transfer_fun
   move $t3,$v0
   
   beq $t3,$s7,start_Middle_storing_new
   
   sb $t0,0($t8)
   addi $t8,$t8,1
   sb $s5,0($t8)
   addi $t8,$t8,1
   addi $t9,$t9,1
   #li $t3,45
   lb $t3,0($t9)
   sb $t3,0($t8)
     
get_end3:                 
   
   addi $t9,$t9,1
   addi $t8,$t8,1
    
   lb $t1,0($t9)            # End of the Slot
   sb $t1,0($t8)
   subi $t1,$t1,48          # Convert from String to Integer   
   addi $t9,$t9,1           # $t9 is the Type of appointment
   addi $t8,$t8,1 
             
get_Appointment3:
   lb $t2,0($t9)            # Type of Appointment
   sb $t2,0($t8)
   
   blt $t2, $t4, end_not_a_number3    # Check if $t2 is greater than or equal to '0' and less than or equal to '9'
   bgt $t2, $t5, end_not_a_number3
   
  # move $a0, $t1
  # move $a1,$t2
  # jal convert_and_contact
  # move $t1,$v0
  # beq $t1,$s7,start_Middle_storing_new
   addi $t9,$t9,1
   addi $t8,$t8,1
   lb $t2,0($t9)            # Type of Appointment
   sb $t2,0($t8)
   j get_Appointment3
   
not_a_Num3:
   sb $t0,0($t8)
   addi $t8,$t8,1  
   sb $a1,0($t8)  
  # addi $t9,$t9,1  
  # addi $t8,$t8,1  
   j get_end3
   
end_not_a_number3:
   bne $t2,$t7,continue3
  # lb $t0,0($t9)
  # sb $t0,0($t8)
   addi $t8,$t8,1  
  # addi $t8,$t8,1 
  # sb $a1,0($t8)  
   addi $t9,$t9,1
  # addi $t8,$t8,1 
#Store the H   
    lb $t0,0($t9)
    sb $t0,0($t8)
    
   
continue3: 
   #move $a0, $t1
   #jal Transfer_fun
  # move $t1,$v0 
   #beq $t1,$s7,start_Middle_storing_new
    
  # beqz $t2,print_resulted_buffer 
#comma Printing  
   
   addi $t8,$t8,1 
   addi $t9,$t9,1
#Store the Comma   
    lb $t0,0($t9)
    sb $t0,0($t8)   
   
   addi $t8,$t8,1 
   addi $t9,$t9,1
   j Middle_storing
   
start_Middle_storing_new:
  
    la $t3,new_slot_buffer 
start_Middle_storing_new_loop:     
     lb $t0,0($t3)
     beqz $t0,store_Middle_comma
     sb $t0,0($t8)
     addi $t8,$t8,1 
     addi $t3,$t3,1 
     bnez $t0,start_Middle_storing_new_loop
    # addi $t8,$t8,1 
     #addi $t9,$t9,2
store_Middle_comma:     
     li $t3,44
     sb $t3,0($t8)
     addi $t8,$t8,1 
     subi $t9,$t9,1
     lb $t0,0($t9)
     blt $t0, $t4, skip_comma
     bgt $t0, $t5, skip_comma
     
   #  li $s7,0
   #  j Middle_storing
cont_Middle_Storing:  
     lb $t0,0($t9)
     sb $t0,0($t8)
     addi $t8,$t8,1 
     addi $t9,$t9,1 
     bnez $t0,cont_Middle_Storing
     
print_Middle_resulted_buffer :
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall

    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,resulted_buffer
    syscall 
##############################################################################################    
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall

    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    move $s1,$s6
    jal update_file
    j main  
    
check_found:    
    move $a0, $t3
    jal Transfer_fun
    move $t3,$v0
    j get_test    
skip_comma:
   addi $t9,$t9,1
   j cont_Middle_Storing    
#------------------------------------- Found Space End ------------------------------------------------------    
found_space_end:
    move $s7,$t0
# Read the type of appointment
    li $v0, 4             # System call code for print_str
    la $a0, type_prompt   # Print type prompt
    syscall
    
    li $v0, 8             # System call code for read string
    la $a0, type_buffer   # Buffer to store type input
    li $a1, 10            # Maximum number of characters to read
    syscall

#Store the new Slot Buffer
   la $t8,new_slot_buffer 

#Start Hour  
    move $a0,$s0
    jal Return_fun 
    move $s0,$v0 
       
    li $t9,10
    move $a0,$s0
    bge $s0,$t9,divide_end
    addi $s0,$s0,48
    #addi $t8,$t8,1 
    sb $s0,0($t8) 
    j get_slach_end
divide_end: jal divide_contact    
    #addi $t8,$t8,1 
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8) 
get_slach_end:     
#Slach 
    addi $t8,$t8,1   
    li $s2 ,45
    sb $s2,0($t8)
#End Hour 
    move $a0,$s1
    jal Return_fun 
    move $s1,$v0   
    move $a0,$s1
    bge $s1,$t9,divide1_end
   addi $t8,$t8,1    
    addi $s1,$s1,48
    sb $s1,0($t8)     
    j get_type_end
divide1_end: jal divide_contact    
          
    addi $t8,$t8,1
    sb $v0,0($t8) 
    addi $t8,$t8,1  
    sb $v1,0($t8)  

get_type_end:          
#Type   
    addi $t8,$t8,1
    la $s3, type_buffer 
    lb $s4,0($s3)
    sb $s4,0($t8) 
    bne $s4,$t7,conttt_end
add_one_end:
    addi $t8,$t8,1
    addi $s3,$s3,1
    lb $s4,0($s3) 
    sb $s4,0($t8) 
conttt_end:     
    addi $t8,$t8,1
    li $t2 ,0
    sb $t2,0($t8)
###########################################################################  
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    la $t8,new_slot_buffer 
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,new_slot_buffer 
    syscall 
#############################################################################
    la $t9, per_day_buffer
    la $t8, resulted_buffer
store_resulted_buffer_end:    
    lb $t0,0($t9)
    sb $t0,0($t8)
    beq $t0, ':', end_storing_found
   # beqz $t0, done1
    addi $t9, $t9, 1
    addi $t8, $t8, 1
    j store_resulted_buffer_end
    
end_storing_found:    
    addi $t9, $t9, 1 
    addi $t8, $t8, 1 
    lb $t0,0($t9)
    beqz $t0,end_storing
    
copy_rest_loop_end:     
     lb $t0,0($t9)
     beqz $t0,get_comma_end
     sb $t0,0($t8)
     addi $t8,$t8,1
     addi $t9,$t9,1
     bnez $t0, copy_rest_loop_end
     
get_comma_end:
    li $s2 ,44
    sb $s2,0($t8)  
    addi $t8,$t8,1      
   
end_storing:
  la $t3,new_slot_buffer 
  
start_end_storing_new_loop:     
     lb $t0,0($t3)
     sb $t0,0($t8)
     addi $t8,$t8,1 
     addi $t3,$t3,1 
     bnez $t0,start_end_storing_new_loop

     
         


print_resulted_buffer_end :
   li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall

    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    li $v0,4
    la $a0,resulted_buffer
    syscall
     
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
   la $a0,space_line
    li $v0, 4
    syscall
    
     li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
    
       move $s1,$s6
       jal update_file
       j main   
                
########################################################## Divide and Contact Function ######################################################  
divide_contact:
   li $a1,10
   divu $a0,$a1
   
   mflo $v0
   addi $v0,$v0,48
   
   mfhi $v1
   addi $v1,$v1,48   
   jr $ra     
#######################################################  Update File Function ###############################################  
update_file:
# Initialize pointers
    la $t0, buffer_new      # Pointer to the beginning of the buffer
    la $t1, buffer       # Pointer to the current character in the buffer
    lb $t3, newline    # Load the newline character into $t3
    la $t9,resulted_buffer 
    li $t7, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $s2,0
    li $s3,0

process_update_next_line:
# Load the first byte of the current line from the buffer
    lb $t2, 0($t1)
  
# Test if the Day have two digit
    addi $t8, $t1,1
    lb $t4,0($t8)
    blt $t4, $t7, contt_update
    bgt $t4, $t5, contt_update
    li $s2,1
    move $s3,$t2     #Move the first char here
    move $a0,$t2
    subi $a0,$a0,48
    move $a1,$t4
    subi $a1,$a1,48          # Convert from String to Integer    
    mul $a0,$a0,10
    add $v0,$a0,$a1    
    move $t2,$v0
    addi $t2,$t2,48
     
contt_update:
  
    # Check for the end of the line or end of the buffer
    beqz $t2, end_of_buffer_update
    beq $t2,$t3, end_of_line_update

    # Check if the first byte of the current line is equal to the given number
    move $t4,$t2
    subi $t4,$t4,48
    bne $t4, $s1, next_line_update
    sub $t4, $t1, $t0   # Calculate the length of the current line
    bnez $s2,Label_update
    
contt2_update:
    j print_line_loop_update
    
next_line_update:
    lb $t2, 0($t1)
    sb $t2,0($t0)
    beq $t2,$t3, end_of_line_update
    addi $t1, $t1, 1
    addi $t0, $t0, 1
   
    j next_line_update

    
print_line_loop_update:  
    lb $t2,0($t9)
    beqz $t2,get_next_line
    beq $t2,$t3, get_next_line
    sb $t2,0($t0) 
    addi $t0, $t0,1 
    addi $t9,$t9,1 
    j print_line_loop_update
    
get_next_line:
    sb $t3,0($t0)
    addi $t0,$t0,1
get_next_line_loop:    
    lb $t2, 0($t1)         # Load the current character from the original buffer
    beqz $t2,end_of_buffer_update# Exit loop if null terminator
    addi $t1, $t1, 1       # Move to the next position in the new buffer
    beq $t2, $t3, process_update_next_line # If the character is ',', jump to copy_rest_update
    j get_next_line_loop

copy_rest_update:
    addi $t0, $t0, 1       # Skip the ',' character in the original buffer
    addi $t1, $t1, 1       # Move to the next position in the new buffer

start_loop:
    lb $t2, 0($t1)         # Load the current character from the original buffer
    sb $t2, 0($t0)         # Copy the character to the new buffer
    beqz $t2, end_of_buffer_update # If the character is null terminator, print the updated buffer
    addi $t0, $t0, 1       # Move to the next character in the original buffer
    addi $t1, $t1, 1       # Move to the next position in the new buffer
    j start_loop

    
end_of_line_update:
# Move to the next line
    addi $t1, $t1, 1    
    addi $t0, $t0, 1    
    j process_update_next_line

end_of_buffer_update:
    #addi $t0,$t0,1
   # sb $zero,0($t0)
#------------------ Open the file------------------------
    li $v0, 13               # System call code for open file
    la $a0, file             # Load the file name into $a0
    li $a1, 1                # Flags: 0 for write_only
    syscall    
    move $s0, $v0            # Save the file descriptor in $s0
    bnez $v0, write_update           # If $v0 is not 0, continue to read
    # Error handling
    li $v0, 4                # System call code for print_str
    la $a0, error_msg        # Load the address of the error message
    syscall
    j close_file_update            # Jump to close the file and exit
    
write_update:     
    # Read the file line by line
    li $v0, 15              # System call code for write file
    move $a0, $s0            # File descriptor
    la $a1, buffer_new           # Buffer to store the line
    li $a2, 256             # Maximum number of characters to read
    syscall
    
# Print the line
  #  li $v0, 4                # System call code for print_str
  #  la $a0, buffer_new           # Load the address of the buffer
  #  syscall
   
close_file_update:
    # Close the file
    li $v0, 16               # System call code for close file
    move $a0, $s0            # File descriptor
    syscall
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
   jr $ra     
end_of_line_update_rest:
# Move to the next line
    addi $t1, $t1, 1    
    addi $t0, $t0, 1    
    j start_loop
      
error_choice_one_update_rest:
    la $a0,error_input
    li $v0, 4
    syscall
    j main
    jr $ra  # Return 
    
end_choice_one_update:
    jr $ra
Label_update:
  move $t2,$s3
  j contt2_update
  
  
######################################################### Choice Four Function ###########################################################  
delete:
# User-provided information
#Read Day Number
    li $v0, 4             # System call code for print_str
    la $a0, day_number  # Print slot prompt
    syscall
    
    li $v0, 5             # System call code for read integer
    syscall  
    
    move $a3,$v0
   
    
#Print the Day Line      
    move $s1,$v0
    jal find_line
    la $t0, not_found_msg
    beq $a0,$t0,delete
        
    la $t9, per_day_buffer 
    la $a0,newline
    li $a1,13
find_if_empty:
    lb $t3,colom
    lb $t0, 0($t9)   # Load the current character

    #beqz $t0, next_line  # If it's null (end of line), move to the next line
    beq $t0, $t3, found_if_empty # If it's ":", we found it
    addi $t9, $t9, 1   # Move to the next character

    j find_if_empty
       
found_if_empty:
    lb $t0,1($t9)
    li $a0,10
    li $a1,13
    beqz $t0,empty_day
    beq $t0,$a0,empty_day  
    beq $t0,$a1,empty_day   
   
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall  
    
#get Slot Hours        
get_slot_start_delete: 
    li $v0, 4            # System call code for print_str
    la $a0, choice_one_op_three_start_slot   # Print slot prompt
    syscall
    
    li $v0, 5           # System call code for print_str
    syscall
    
    move $a0,$v0
    jal Transfer_fun
       
    li $t6, 17
    li $t7, 8
    bge $v0,$t6,get_slot_start_delete
    blt $v0,$t7,get_slot_start_delete
    
    move $s0,$v0
    
#Print the end hour of the slot
get_slot_end_delete: 
    la $a0,choice_one_op_three_end_slot
    li $v0, 4
    syscall
   
    li $v0, 5             # System call code for print_str
    syscall
    
    move $a0,$v0
    jal Transfer_fun
    
    li $t6, 17
    li $t7, 8
    bgt $v0,$t6,get_slot_end_delete
    ble $v0,$t7,get_slot_end_delete
    
    
    move $s1,$v0 
    
# Read the type of appointment
    li $v0, 4             # System call code for print_str
    la $a0, type_prompt   # Print type prompt
    syscall
    
    li $v0, 8             # System call code for read string
    la $a0, type_buffer   # Buffer to store type input
    li $a1, 10            # Maximum number of characters to read
    syscall
       
##################################################### Find Time Function ######################################################        
find_deleted_slot:      
    li $t4, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $t9, 0    # Pointer Register
    li $t3, 44    # Test2 Register
    li $t7,79    # O Character Regiter
   # li $t6,72    # H Character Regiter 
    li $t0,0     # Start Hour of Slot Regiter
    li $t1,0     # End Hour of Slot Regiter
    li $t2,0     # Type of Appointment Regiter
    li $s6,0     #Flag Register
    la $t9,per_day_buffer    #$t9 is a pointer to the begining of the wanted Line
    la $t8,deleted_buffer
    la $t6, type_buffer
   
find_colon_delete:
    lb $t3,colom
    lb $t0, 0($t9)   # Load the current character
    sb $t0, 0($t8)
    #beqz $t0, next_line  # If it's null (end of line), move to the next line
    beq $t0, $t3, found_colon_delete # If it's ":", we found it
    addi $t9, $t9, 1   # Move to the next character
    addi $t8, $t8, 1
    j find_colon_delete 
       
found_colon_delete:
    addi $t9,$t9,1  
    addi $t8,$t8,1 
    
start_deleted_slot:        
   lb $t0,0($t9)            # Start of the Slot
  # addi $s5,$t9,1
  move $s5,$t9
  # beqz $t0,set_null
   beqz $t0,print_delete
   subi $t0,$t0,48          # Convert from String to Integer  
   addi $t9,$t9,1           # $t9 Point to the "-"
   lb $a1,0($t9)  
   blt $a1, $t4, not_a_Num_delete
   bgt $a1, $t5, not_a_Num_delete
   move $a0,$t0
   jal convert_and_contact
   move $t0,$v0
   addi $t9,$t9,2
get_end_delete:                     #8-9 L, 10-12 OH, 12-2 M

   move $a0, $t0
   jal Transfer_fun
   move $t0,$v0
# Test if the Start Hour equals to $s0      
   bne $t0,$s0,next_slot_loop
  # addi $s5,$s5,1 
    
   lb $t1,0($t9)            # End of the Slot
   subi $t1,$t1,48          # Convert from String to Integer   
   addi $t9,$t9,1           # $t9 is the Type of appointment
get_Appointment_delete:
   lb $t2,0($t9)            # Type of Appointment
   blt $t2, $t4, end_not_a_number_delete     # Check if $t2 is greater than or equal to '0' and less than or equal to '9'
   bgt $t2, $t5, end_not_a_number_delete
   move $a0, $t1
   move $a1,$t2
   jal convert_and_contact
   move $t1,$v0
   addi $t9,$t9,1
   j get_Appointment_delete 
not_a_Num_delete:
   addi $t9,$t9,1   
   j get_end_delete  
end_not_a_number_delete:
   bne $t2,$t7,continue_delete
   addi $t9,$t9,1
continue_delete: 
   move $a0, $t1
   jal Transfer_fun
   move $t1,$v0
   bne $t1,$s1,next_slot_loop
   #bne $t2,$s0,next_slot_loop
   lb $t3,0($t6)
   bne $t2,$t3,next_slot_loop
   li $s6,1
   
   addi $t3,$t9,1
   lb $t0,0($t3)
   beqz $t0,set_null
   li $a0,10
   li $a1,13
   beq $t0,$a0,set_null 
   beq $t0,$a1,set_null
     
increment_delete:
   addi $t9,$t9,2
   j start_deleted_slot 
    
not_found_deleted_slot:
    la $a0,not_found_slot
    li $v0,4
    syscall
    j delete
    
next_slot_loop:
   # li $s6,1
    li $t3,44
    lb $t0, 0($s5)
    sb $t0,0($t8)
    
    addi $t8,$t8,1
    #addi $t9,$t9,1
    addi $s5,$s5,1  
      
    beqz $t0,print_delete
    bne $t0, $t3, next_slot_loop
    j get_Pointer 
    
    
get_Pointer:
   move $t9,$s5     
   j start_deleted_slot   
   
   
print_delete:
 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
   
    la $a0,space_line
    li $v0, 4
    syscall
    
    
    li $v0, 4                # System call code for print_str
    la $a0, deleted_buffer          # Load the address of the newline character
    syscall 
  
    la $a0,newline
    li $v0, 4
    syscall
    
    bnez $s6, no_conflict
    li $v0,4
    la $a0, no_deleted_msg
    syscall
    
no_conflict:    
    move $s1,$a3
    jal delete_file

     j main  
     
set_null:
    beqz $s6,print_delete
    la $t8,deleted_buffer
    
start_set_null_loop: 
    lb $t0,0($t8)
    addi $t8,$t8,1
    bnez $t0,start_set_null_loop 
    subi $t8,$t8,2
    lb $t0,0($t8)
    li $t3,58
    beq $t0,$t3,print_delete
    li $t3,44
    bne $t0,$t3,print_delete
    sb $zero , 0($t8)
    j print_delete  
    
empty_day:
    la $a0,empty_day_msg
    li $v0,4
    syscall
    j main
    
    
#################################################   Delete File Function ##################################################################                        
delete_file:
# Initialize pointers
    la $t0, buffer_new      # Pointer to the beginning of the buffer
    la $t1, buffer       # Pointer to the current character in the buffer
    lb $t3, newline    # Load the newline character into $t3
    la $t9,deleted_buffer
    li $t7, 48    # ASCII code for '0'
    li $t5, 57    # ASCII code for '9'
    li $s2,0
    li $s3,0


process_delete_next_line:
# Load the first byte of the current line from the buffer
    lb $t2, 0($t1)
  
# Test if the Day have two digit
    addi $t8, $t1,1
    lb $t4,0($t8)
    blt $t4, $t7, contt_delete
    bgt $t4, $t5, contt_delete
    li $s2,1
    move $s3,$t2     #Move the first char here
    move $a0,$t2
    subi $a0,$a0,48
    move $a1,$t4
    subi $a1,$a1,48          # Convert from String to Integer    
    mul $a0,$a0,10
    add $v0,$a0,$a1    
    move $t2,$v0
    addi $t2,$t2,48
     
contt_delete:
  
    # Check for the end of the line or end of the buffer
    beqz $t2, end_of_buffer_delete
    beq $t2,$t3, end_of_line_delete

    # Check if the first byte of the current line is equal to the given number
    move $t4,$t2
    subi $t4,$t4,48
    bne $t4, $s1, next_line_delete
    sub $t4, $t1, $t0   # Calculate the length of the current line
    bnez $s2,Label_delete
    
contt2_delete:
    j print_line_loop_delete
    
next_line_delete:
    lb $t2, 0($t1)
    sb $t2,0($t0)
    beq $t2,$t3, end_of_line_delete
    addi $t1, $t1, 1
    addi $t0, $t0, 1
   
    j next_line_delete

    
print_line_loop_delete:  
    lb $t2,0($t9)
    beqz $t2,get_next_line_delete
    beq $t2,$t3, get_next_line_delete   
    sb $t2,0($t0) 
    addi $t0, $t0,1 
    addi $t9,$t9,1 
    j print_line_loop_delete
    
get_next_line_delete:
    sb $t3,0($t0)
    addi $t0,$t0,1
    
get_next_line_loop_delete:    
    lb $t2, 0($t1)         # Load the current character from the original buffer
    li $s7,13
    beqz $t2,end_of_buffer_delete # Exit loop if null terminator
    addi $t1, $t1, 1       # Move to the next position in the new buffer
    beq $t2, $t3, process_delete_next_line # If the character is ',', jump to copy_rest_update 
    j get_next_line_loop_delete

copy_rest_delete:
    addi $t0, $t0, 1       # Skip the ',' character in the original buffer
    addi $t1, $t1, 1       # Move to the next position in the new buffer

start_loop_delete:
    lb $t2, 0($t1)         # Load the current character from the original buffer
    sb $t2, 0($t0)         # Copy the character to the new buffer
    beqz $t2,end_of_buffer_delete # If the character is null terminator, print the updated buffer
    addi $t0, $t0, 1       # Move to the next character in the original buffer
    addi $t1, $t1, 1       # Move to the next position in the new buffer
    j start_loop_delete

    
end_of_line_delete:
# Move to the next line
    addi $t1, $t1, 1    
    addi $t0, $t0, 1    
    j process_delete_next_line

end_of_buffer_delete:
   # addi $t0,$t0,1
    #sb $zero,0($t0)
#------------------ Open the file------------------------
    li $v0, 13               # System call code for open file
    la $a0, file             # Load the file name into $a0
    li $a1, 1                # Flags: 0 for write_only
    syscall    
    move $s0, $v0            # Save the file descriptor in $s0
    bnez $v0, write_delete           # If $v0 is not 0, continue to read
    # Error handling
    li $v0, 4                # System call code for print_str
    la $a0, error_msg        # Load the address of the error message
    syscall
    j close_file_delete            # Jump to close the file and exit
    
write_delete:     
    # Read the file line by line
    li $v0, 15              # System call code for write file
    move $a0, $s0            # File descriptor
    la $a1, buffer_new           # Buffer to store the line
    li $a2, 256             # Maximum number of characters to read
    syscall
   
close_file_delete:
    # Close the file
    li $v0, 16               # System call code for close file
    move $a0, $s0            # File descriptor
    syscall
    
#Print a newline 
    li $v0, 4                # System call code for print_str
    la $a0, newline          # Load the address of the newline character
    syscall
    
   jr $ra     
end_of_line_delete_rest:
# Move to the next line
    addi $t1, $t1, 1    
    addi $t0, $t0, 1    
    j start_loop_delete
      
error_choice_one_delete_rest:
    la $a0,error_input
    li $v0, 4
    syscall
    j main
    jr $ra  # Return 
    
end_choice_one_delete:
    jr $ra
Label_delete:
  move $t2,$s3
  j contt2_delete
  
  
