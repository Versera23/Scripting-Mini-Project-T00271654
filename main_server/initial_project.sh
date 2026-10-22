#!/bin/bash 
# Project: IT Service Desk software 
# Student: Adam Fleming 
# Student number: T00271654 
# Purpose: Establish a working ticket system for different roles in the Univsersity. Build an IT desk management system to manage those tickets. 
 
PROJECT_TITLE="University IT Support Desk" 
DATA_FILE="main_server/data/records_all.txt"
STUDENT_FILE="main_server/data/student_records.txt"
LECTURER_FILE="main_server/data/lecturer_records.txt"
ADMIN_FILE="main_server/data/admin_records.txt"
IT_FILE="main_server/data/it_staff.txt"
REPORT_DIR="reports" 
BACKUP_DIR="backups" 
#PRIORITY="Generated using if statements, e.g. if from Admin, Priority will = HIGH"
#The error codes are based on Chromium's Linux Error Codes: https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/errnos/

#CHECKS IF THE DATA FILE IS AVAILABLE AND CAN BE FOUND
if [ ! -f "$DATA_FILE" ]; then 
    echo "Error 0x01: required data file not found: $DATA_FILE" 
    exit 001 
fi 

#CHECKS IF DATA FILE IS READABLE 
if [ ! -r "$DATA_FILE" ]; then 
    echo "Error 0x06: data file is not readable: $DATA_FILE" 
    exit 006 
fi 

#CHECKS IF DATA FILE HAS ANY DATA INSIDE OF IT 
if [ ! -s "$DATA_FILE" ]; then 
    echo "Error 0x04: data file is empty: $DATA_FILE" 
    exit 004 
fi 

#SUCCESS IN FINDING & READING DATA FILE 
TICKET_COUNT=$(wc -l < "$DATA_FILE") 

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#FUNCTION DECLARATIONS

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#Deciding on priority and SLA timer for students entries

#This chooses 1 random line (-n 1) from staff assignments file and uses shuf to choose a random one to output a staff's name
#shuf learned from Linux docs: https://man7.org/linux/man-pages/man1/shuf.1.html 
choose_Worker=$(shuf -n 1 main_server/data/it_staff_assignment.txt)

#IF STUDENT
student_menu(){   
echo  "Welcome Student, please enter your information below"
echo "-----------------------------------------------------"
read -r -p "Enter your forename: " forename	
read -r -p "Enter your surname: " surname	
read -r -p "Enter your ID Number: " id_number
read -r -p "Enter your course name: " course	
read -r -p "Enter your course year: " course_year	
read -r -p "Enter your problem (short-form, e.g. 'Laptop Issues'): " problem_area
echo ""

    #Priority chosen by Course Year
    if [ "$course_year" = 4 ]; then
        priority="High priority"
        sla="1. Within hour"
    elif [ "$course_year" = 2 ] || [ "$course_year" = 3 ]; then
        priority="Medium priority"    
        sla="2. Within 8 hours"
    elif [ "$course_year" = 1 ]; then
        priority="Low priority"  
        sla="3. Within the day"  
    else
        echo "Please enter a valid course number; 1-4."
        return 1
        echo
    fi

    #Check to see if all fields are filled in
    if [ -z "$id_number" ] || [ -z "$forename" ] || [ -z "$surname" ] || [ -z "$course" ] || [ -z "$course_year" ] || [ -z "$problem_area" ]; then 
        echo "Error: all fields are required." 
        echo
        return 1
    #Check to see if ID Number matches     
    elif [[ $id_number != "V00"* ]]; then
        echo "Please enter a valid Student ID."
        echo
        return 1       
    fi 
#"24 a" chooses the desired update line within a file, under Student category in this case
#sed -i updates a file with whatever string given. sed learned from Linux docs: https://man7.org/linux/man-pages/man1/sed.1.html
#Status remains "Open" until an IT Worker accepts the ticket and changes it

#Insert the information into records.txt in the area in which Lecturer tickets are stored.  
sed -i "12 a $id_number, $forename $surname, $course, $course_year, $problem_area, $priority, "Open", $sla, $choose_Worker" "$DATA_FILE"
#Place new information also into dedicated students_records.txt file.
echo >> "$STUDENT_FILE"
echo -n "$id_number, $forename $surname, $course, $course_year, $problem_area, $priority, "Open", $sla, $choose_Worker" >> "$STUDENT_FILE"
echo "Thank you $forename, your ticket has been logged, your priority is $priority, we will respond as soon as possible."
}


#---------------------------------------------------------------------------------------------------------------------------------------------------------------

lecturer_menu(){
#IF LECTURER
echo  "Welcome Lecturer, please enter your information below"
echo "-----------------------------------------------------"
read -r -p "Enter your forename: " forename	
read -r -p "Enter your surname: " surname	
read -r -p "Enter your ID Number: " id_number
read -r -p "Enter your course name: " course	
read -r -p "Enter your problem (short-form, e.g. 'Laptop Issues'): " problem_area
read -r -p "Is this problem during class time? Enter Yes/No (case-sensitive): " problem_time
echo ""
    #Priority chosen by Course Year
    if [ "$problem_time" = "Yes" ]; then
        priority="High priority"
        sla="1. Within hour"
    elif [ "$problem_time" = "No" ];then
        priority="Medium priority"    
        sla="2. Within 8 hours"
    else
        echo "Please enter a valid answer, Yes or No"
        echo
        return 1
    fi

    #Check to see if all fields are filled in
    if [ -z "$id_number" ] || [ -z "$forename" ] || [ -z "$surname" ] || [ -z "$course" ] || [ -z "$problem_area" ] || [ -z "$problem_time" ]; then 
        echo "Error: all fields are required." 
        return 1
        echo
    #Check to see if ID Number matches     
    elif [[ ! ${id_number} == "S00"* ]]; then
        echo "Please enter a valid Admin ID."
        echo
        return 1    
    fi  

sed -i "23 a $id_number, $forename $surname, $course, $problem_area, $problem_time, $priority, "Open", $sla, $choose_Worker" "$DATA_FILE"
echo >> "$LECTURER_FILE"
echo -n "$id_number, $forename $surname, $course, $course_year, $problem_area, $priority, "Open", $sla, $choose_Worker" >> "$LECTURER_FILE"
echo "Thank you $forename, your ticket has been logged, your priority is $priority, we will respond as soon as possible."
}


#---------------------------------------------------------------------------------------------------------------------------------------------------------------

admin_menu(){
#IF ADMIN
echo  "Welcome Admin Staff, please enter your information below"
echo "-----------------------------------------------------"
read -r -p "Enter your forename: " forename	
read -r -p "Enter your surname: " surname	
read -r -p "Enter your ID Number: " id_number
read -r -p "Enter your problem (short-form, e.g. 'Laptop Issues'): " problem_area
echo ""

    #Check to see if all fields are filled in
    if [ -z "$id_number" ] || [ -z "$forename" ] || [ -z "$surname" ] || [ -z "$problem_area" ]; then 
        echo "Error: all fields are required." 
        echo
        return 1
   #Check to see if ID Number matches     
    elif [[ ! ${id_number} == "A00"* ]]; then
        echo "Please enter a valid Admin ID."
        echo
        return 1    
    fi 

#Status remains "Open" until an IT Worker accepts the ticket and changes it

sed -i "33 a $id_number, $forename $surname, $problem_area, "High", "Open", $sla, $choose_Worker" "$DATA_FILE"
echo >> "$ADMIN_FILE"
echo -n "$id_number, $forename $surname, "High", "Open", $sla, $choose_Worker" >> "$ADMIN_FILE"
echo "Thank you $forename, your ticket has been logged, your priority is High priority, we will respond as soon as possible."
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#IF IT STAFF WORKER
#IT Work Menu
show_it_menu(){
echo "1. View all records"
echo "2. Show your current tickets"
echo "3. Search for a ticket by ID"
echo "4. Add a new Technician to system"
echo "5. Delete an existing record"
echo "6. Log out"
}

#Searches for the count of entered ID

display_all_records(){
        cat "$DATA_FILE"
        echo ""
}

show_working_tickets(){
        find_ticket=$(grep -i "$name" "$DATA_FILE")
        if [ "$find_ticket" = "" ]; then
        {
                echo "You have no active tickets. Take a break!"
        }
        else 
                echo "$find_ticket"
        
        fi
        echo
}

search_by_id(){
    #Used to declare Variables only within this function
    local search_id 
    local match 

     read -r -p "Enter ID of user with problem: " search_id 
       if [ -z "$search_id" ]; then 
            echo "Error 0x17: identifier cannot be blank." 
            echo 
            return 1

    fi 
    match=$(grep -i "^${search_id}," "$DATA_FILE") 

    if [ -n "$match" ]; then 
        echo 
        echo "Matching record:" 
        echo 
        echo "$match" 
        return 001 
    else 
        echo
        echo "No user found with ID: $search_id"
        echo 
        return 002 
    fi 
}

add_technician(){
echo  "Add new technician information below"
echo "-----------------------------------------------------"
read -r -p "Enter new forename: " it_forename	
read -r -p "Enter new surname: " it_surname	
read -r -p "Enter new ID Number: " it_id_number
read -r -p "Enter new default password: " it_password
echo ""

    #Check to see if all fields are filled in
    if [ -z "$it_id_number" ] || [ -z "$it_forename" ] || [ -z "$it_surname" ] || [ -z "$it_password" ]; then 
        echo "Error: all fields are required." 
        echo
        return 1
   #Check to see if ID Number is valid    
     elif [[ ! ${it_id_number} == "IT00"* ]]; then
        echo "Please enter a valid technician ID."
        echo
        return 1    
    fi 

echo >> "$IT_FILE"
echo -n "$it_id_number, $it_forename $it_surname, $it_password" >> "$IT_FILE"
echo "Thank you $name, new technician has been added to system"
}

delete_record(){
read -r -p "Enter an ID number to remove ticket: " remove_tick
echo
sed -i "/$remove_tick/d" "$DATA_FILE"
echo
echo "Ticket for: $remove_tick successfully removed."
}


#Examples given, but feel free to use any name, id and password in it_staff.txt. Note: Everything is case sensitive
it_menu(){
        echo "Code 0x07 - Successful." 
        echo "$PROJECT_TITLE software loaded" 
        echo "Data file ready: $DATA_FILE" 
        echo "Tickets logged: $TICKET_COUNT" 
        echo   

read -r -p "Enter your full name (Use 'Jessica Cooley' for testing): " name
read -r -p "Enter ID number (Use 'IT007654' for testing): " id_worker
read -r -p "Enter password (Use 'JessicaPassword' for testing): " password
echo 
while true; do   
check_name=$(grep -c "$name" main_server/data/it_staff.txt)
check_worker_id=$(grep -c "$id_worker" main_server/data/it_staff.txt)
check_password=$(grep -c "$password" main_server/data/it_staff.txt)
ticket_amount=$(grep -c "$name" "$DATA_FILE")

#Searches for if the field is blank, or there are no existing names of entered value
if [ -z  "$name" ] || [ "$check_name" = 0 ]; then
        echo "Error 0x20: name field invalid"; return 1
elif [ -z  "$id_worker" ] || [ "$check_worker_id" = 0 ]; then
        echo "Error 0x21: ID field invalid"; return 1
elif [ -z "$password"  ] || [ "$check_password" = 0 ]; then
        echo "Error 0x22: password field invalid"; return 1           
else  
        echo
        echo  "Welcome $name, you have $ticket_amount open tickets"
        echo "-----------------------------------------------------"
        echo 
#Call the IT Menu
show_it_menu
#Switch section for IT
echo 
read -r -p "Please enter number of desired function: " work_choice
echo
case "$work_choice" in
            1) display_all_records ;;
            2) show_working_tickets ;;
            3) search_by_id ;;
            4) add_technician ;;
            5) delete_record ;;
            6) echo "Goodbye $name, have a good day!"; break ;;
            *) echo "Please select a valid option, 1-7." ;; 
esac
fi
done
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#HOME MENU
home_menu(){
echo
echo "Welcome to the IT Service Desk, please select your role to continue"
echo
echo "Please choose your role:"	
echo "------------------------"
echo "1. Student"			
echo "2. Lecturer"
echo "3. Admin"	
echo "4. IT Worker"		
echo "5. Exit the software"
echo 
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#Initial Menu executing

#---------------------------------------------------------------------------------------------------------------------------------------------------------------
while true; do
home_menu
read -r -p "Please enter number of desired function: " user_choice
echo 
case "$user_choice" in
            1) student_menu ;;
            2) lecturer_menu ;;
            3) admin_menu ;;
            4) it_menu ;;
            5) echo "Goodbye, have a good day!"; break ;; 
            *) echo "Invalid, please restart and select an option 1-5" ;; 

esac
done