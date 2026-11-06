#!/bin/bash 
# Project: IT Service Desk software 
# Student: Adam Fleming 
# Student number: T00271654 
# Purpose: Establish a working ticket system for different roles in the Univsersity. Build an IT desk management system to manage those tickets. 

#Update 3.0
#Added safe deletion feature to all files
#Created safe update status ability
#Added further restrictions when logging in as a technician for security purposes
#Added the ability to backup all files to backup server
#Fixed various bugs within the code

PROJECT_TITLE="University IT Support Desk" 
DATA_FILE="main_server/data/records_all.txt"
STUDENT_FILE="main_server/data/student_records.txt"
LECTURER_FILE="main_server/data/lecturer_records.txt"
ADMIN_FILE="main_server/data/admin_records.txt"
IT_FILE="main_server/data/it_staff.txt"
REPORT_DIR="reports" 
BACKUP_DIR="backups" 
#PRIORITY=Generated using if statements, e.g. if from Admin, Priority will = HIGH
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
echo

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
#24 a chooses the desired update line within a file, under Student category in this case
#sed -i updates a file with whatever string given. sed learned from Linux docs: https://man7.org/linux/man-pages/man1/sed.1.html
#Status remains Open until an IT Worker accepts the ticket and changes it

#Insert the information into records.txt in the area in which Lecturer tickets are stored.  
sed -i "12 a $id_number, $forename $surname, $course, $course_year, $problem_area, $priority, Open, $sla, $choose_Worker" "$DATA_FILE"
#Place new information also into dedicated students_records.txt file.
echo >> "$STUDENT_FILE"
echo -n "$id_number, $forename $surname, $course, $course_year, $problem_area, $priority, Open, $sla, $choose_Worker" >> "$STUDENT_FILE"
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
        echo "Please enter a valid Lecturer ID."
        echo
        return 1    
    fi  

sed -i "23 a $id_number, $forename $surname, $course, $problem_area, $problem_time, $priority, Open, $sla, $choose_Worker" "$DATA_FILE"
echo >> "$LECTURER_FILE"
echo -n "$id_number, $forename $surname, $course, $problem_area, $priority, Open, $sla, $choose_Worker" >> "$LECTURER_FILE"
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

sed -i "33 a $id_number, $forename $surname, $problem_area, High, Open, 1. Within hour, $choose_Worker" "$DATA_FILE"
echo >> "$ADMIN_FILE"
echo -n "$id_number, $forename $surname, High, Open, 1. Within hour, $choose_Worker" >> "$ADMIN_FILE"
echo "Thank you $forename, your ticket has been logged, your priority is High priority, we will respond as soon as possible."
}

#---------------------------------------------------------------------------------------------------------------------------------------------------------------

#IF IT STAFF WORKER
#IT Work Menu
show_it_menu(){
echo "1. View all records"
echo "2. Show your current tickets"
echo "3. Search for a ticket by ID"
echo "4. Change a ticket's status"
echo "5. Delete an existing record"
echo "6. Add a new Technician to system"
echo "7. System Backup"
echo "8. Log out"
}

#Searches for the count of entered ID

display_all_records(){
        cat "$DATA_FILE"
        echo 
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

#Changes status to In Progress when approved by a technician
change_status(){
    local target_id new_status line current_id
    local temp_file="${DATA_FILE}.tmp"
    local temp_stud_file="${STUDENT_FILE}.tmp"
    local temp_lect_file="${LECTURER_FILE}.tmp"
    local temp_admin_file="${ADMIN_FILE}.tmp" 

    sed -i -e '$a\' "$DATA_FILE" >> "$DATA_FILE"
    sed -i -e '$a\' "$STUDENT_FILE" >> "$STUDENT_FILE"
    sed -i -e '$a\' "$LECTURER_FILE" >> "$LECTURER_FILE"
    sed -i -e '$a\' "$ADMIN_FILE" >> "$ADMIN_FILE"

    read -r -p "Enter ticket to update status of: " target_id
    if [ -z "$target_id" ]; then
        echo "Error: ID cannot be blank."
        return 1
    fi

    searchedRecord=$(grep "$target_id" "$DATA_FILE")
    
    echo
    echo "Record selected: $searchedRecord"
    echo
    read -r -p "Update this record: $target_id? (yes/no): " confirm
        case "$confirm" in
        yes|YES|Yes) ;;
        *) echo 
        echo -n "Update cancelled."; return 0 ;;
    esac
    > "$temp_file"

    if [[ "$target_id" == "V00"* ]]; then
        touch "$temp_stud_file"
        echo "Student_ID, Student_name, Course, Course_Year, Problem_Area, Priority, Status, SLA_Status, Assigned_IT_Staff" >> "$temp_stud_file"
        echo "------------------------------------------------------------------------------------------------------------" >> "$temp_stud_file"
        echo >> "$temp_stud_file"
    elif [[ "$target_id" == "S00"* ]]; then
         touch "$temp_lect_file"
         echo "Lecturer_ID, Lecturer_Name, Course, Problem_Area, During_class, Priority, Status, SLA_Status, Assigned_IT_Staff" >> "$temp_lect_file"
         echo "------------------------------------------------------------------------------------------------------------" >> "$temp_lect_file"
         echo >> "$temp_lect_file"
    elif [[ "$target_id" == "A00"* ]]; then
         touch "$temp_admin_file"
         echo "Admin_ID, Admin_Name, Problem_Area, Priority, Status, SLA_Status, Assigned_IT_Staff" >> "$temp_admin_file"
         echo "------------------------------------------------------------------------------------------------------------" >> "$temp_admin_file"
         echo >> "$temp_admin_file"
    fi

     while IFS= read -r line; do
        current_id=${line%%,*}
        echo "$line" >> "$temp_file"
    done < "$DATA_FILE"

    while IFS= read -r othersLine; do
        current_id=${othersLine%%,*}
        if [[ "$target_id" == "V00"* ]] && [[ "$current_id" == "V00"* ]]; then
            echo "$othersLine" >> "$temp_stud_file"
        elif [[ "$target_id" == "S00"* ]] && [[ "$current_id" == "S00"* ]]; then
            echo "$othersLine" >> "$temp_lect_file"
        elif [[ "$target_id" == "A00"* ]] && [[ "$current_id" == "A00"* ]]; then
            echo "$othersLine" >> "$temp_admin_file"   
        fi
    done < "$DATA_FILE"

    currentNum="$(grep -n "$target_id" "$temp_file" | cut -d : -f 1)"
    allStatus=$(sed -i -e "${currentNum}s/Open,/In Progress,/" "$temp_file")

    if [ -f "$temp_stud_file" ]; then
        currentStud="$(grep -n "$target_id" "$temp_stud_file" | cut -d : -f 1)" # code adapted from: carlodef, 2014. Get line number while using grep. [Online] Available at: https://stackoverflow.com/questions/3213748/get-line-number-while-using-grep [Accessed 5 11 2026].

        studStatus=$(sed -i -e "${currentStud}s/Open,/In Progress,/" "$temp_stud_file")
    elif [ -f "$temp_lect_file" ]; then
        currentLect="$(grep -n "$target_id" "$temp_lect_file" | cut -d : -f 1)"
        lectStatus=$(sed -i -e "${currentLect}s/Open,/In Progress,/" "$temp_lect_file")
    elif [ -f "$temp_admin_file" ]; then
        currentAdmin="$(grep -n "$target_id" "$temp_admin_file" | cut -d : -f 1)"
        adminStatus=$(sed -i -e "${currentAdmin}s/Open,/In Progress,/" "$temp_admin_file")
    fi

    if [ -z "$currentNum" ]; then
        echo "Error: record not found."
        return 1
    fi

    echo
    read -r -p "Change $target_id's ticket status to open? (yes/no): " confUpdate
    theLower=$(echo "$confUpdate" | tr [:upper:] [:lower:]) #tr learned from GeeksforGeeks.com, found at: https://www.geeksforgeeks.org/linux-unix/tr-command-in-unix-linux-with-examples/
    if [[ $theLower = "yes" ]]; then
        if [ -f "$temp_file" ]; then

                    if [ -f "$temp_stud_file" ]; then
                        cat $temp_stud_file > "$STUDENT_FILE"
                        rm "$temp_stud_file"
                    elif [ -f "$temp_lect_file" ]; then
                        cat $temp_lect_file > "$LECTURER_FILE"
                        rm "$temp_lect_file"
                    elif [ -f "$temp_admin_file" ]; then
                        cat $temp_admin_file > "$ADMIN_FILE"
                        rm "$temp_admin_file"
                    fi            

            mv "$temp_file" "$DATA_FILE"
            echo
            echo "Record updated successfully."
        fi
    else
        echo
        echo "Error: update failed; original preserved."
        rm "$temp_file"
        
                    if [ -f "$temp_stud_file" ]; then
                        rm "$temp_stud_file"
                    elif [ -f "$temp_lect_file" ]; then
                        rm "$temp_lect_file"
                    elif [ -f "$temp_admin_file" ]; then
                        rm "$temp_admin_file"
                    fi            
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
     elif grep -qi "^${it_id_number}," "$IT_FILE"; then 
        echo "Error: ID already exists, try again." 
        echo
        return 1 
    fi 

echo >> "$IT_FILE"
echo -n "$it_id_number, $it_forename $it_surname, $it_password" >> "$IT_FILE"
echo "Thank you $name, new technician has been added to system"
}

delete_record(){
    local temp_file="${DATA_FILE}.tmp"
    local temp_stud_file="${STUDENT_FILE}.tmp"
    local temp_lect_file="${LECTURER_FILE}.tmp"
    local temp_admin_file="${ADMIN_FILE}.tmp"
    read -r -p "ID Number to Delete record of: " target_id

    searchDelete=$(grep "^${target_id}," "$DATA_FILE") #find id in all records
    studDelete=$(grep "^${target_id}," "$STUDENT_FILE") #find id in students
    lectDelete=$(grep "^${target_id}," "$LECTURER_FILE") #find id in lecturers
    adminDelete=$(grep "^${target_id}," "$ADMIN_FILE") #find id in admin


    #Code adapted from I0b0, 2012. How to add a newline to the end of a file?. [Online] Available at: https://unix.stackexchange.com/questions/31947/how-to-add-a-newline-to-the-end-of-a-file [Accessed 4/11/2026].
    #Guarantees a newline is added to the bottom of a file if it doesn't exist, adapted to make sure every line of file is read, as not having newline at the end causes read to not pick up the last line.
    sed -i -e '$a\' "$DATA_FILE" >> "$DATA_FILE"
    sed -i -e '$a\' "$STUDENT_FILE" >> "$STUDENT_FILE"
    sed -i -e '$a\' "$LECTURER_FILE" >> "$LECTURER_FILE"
    sed -i -e '$a\' "$ADMIN_FILE" >> "$ADMIN_FILE"

        if [ -z "$searchDelete" ] ; then
            echo
            echo "Error: record not found."
            return 1
        fi

    echo
    echo "Record selected: $searchDelete"
    echo
    read -r -p "Delete this record: $target_id? (yes/no): " confirm
        case "$confirm" in
        yes|YES|Yes) ;;
        *) echo -n "Deletion cancelled."; return 0 ;;
    esac
    > "$temp_file"
        while IFS= read -r line; do
        current_id=${line%%,*}
        if [ "$current_id" != "$target_id" ]; then
            echo "$line" >> "$temp_file"
        fi
    done < "$DATA_FILE"

    if [[ "$target_id" == "V00"* ]]; then
        touch "$temp_stud_file"
        echo "Student_ID, Student_name, Course, Course_Year, Problem_Area, Priority, Status, SLA_Status, Assigned_IT_Staff" >> "$temp_stud_file"
        echo "------------------------------------------------------------------------------------------------------------" >> "$temp_stud_file"
        echo >> "$temp_stud_file"
    elif [[ "$target_id" == "S00"* ]]; then
         touch "$temp_lect_file"
         echo "Lecturer_ID, Lecturer_Name, Course, Problem_Area, During_class, Priority, Status, SLA_Status, Assigned_IT_Staff" >> "$temp_lect_file"
         echo "------------------------------------------------------------------------------------------------------------" >> "$temp_lect_file"
         echo >> "$temp_lect_file"
    elif [[ "$target_id" == "A00"* ]]; then
         touch "$temp_admin_file"
         echo "Admin_ID, Admin_Name, Problem_Area, Priority, Status, SLA_Status, Assigned_IT_Staff" >> "$temp_admin_file"
         echo "------------------------------------------------------------------------------------------------------------" >> "$temp_admin_file"
         echo >> "$temp_admin_file"
    fi     
 
#Validating which category they belong to, adding information to temp files

        while IFS= read -r othersLine; do
        current_id=${othersLine%%,*}
        if [ "$current_id" != "$target_id" ] && [[ "$target_id" == "V00"* ]] && [[ "$current_id" == "V00"* ]]; then
            echo "$othersLine" >> "$temp_stud_file"
        elif [ "$current_id" != "$target_id" ] && [[ "$target_id" == "S00"* ]] && [[ "$current_id" == "S00"* ]]; then
            echo "$othersLine" >> "$temp_lect_file"
        elif [ "$current_id" != "$target_id" ] && [[ "$target_id" == "A00"* ]] && [[ "$current_id" == "A00"* ]]; then
            echo "$othersLine" >> "$temp_admin_file"   
        fi
    done < "$DATA_FILE"

    echo
    read -r -p "Are you sure you wish to delete $target_id? (yes/no): " confDelete
    theLower=$(echo "$confDelete" | tr [:upper:] [:lower:]) #tr learned from GeeksforGeeks.com, found at: https://www.geeksforgeeks.org/linux-unix/tr-command-in-unix-linux-with-examples/
    if [[ $theLower = "yes" ]]; then
        if [ -f "$temp_file" ]; then

                    if [ -f "$temp_stud_file" ]; then
                        cat $temp_stud_file > "$STUDENT_FILE"
                        rm "$temp_stud_file"
                    elif [ -f "$temp_lect_file" ]; then
                        cat $temp_lect_file > "$LECTURER_FILE"
                        rm "$temp_lect_file"
                    elif [ -f "$temp_admin_file" ]; then
                        cat $temp_admin_file > "$ADMIN_FILE"
                        rm "$temp_admin_file"
                    fi            

            mv "$temp_file" "$DATA_FILE"
            echo
            echo "Record deleted successfully."
        fi
    else
        echo
        echo "Error: deletion failed; original preserved."
        rm "$temp_file"
        
                    if [ -f "$temp_stud_file" ]; then
                        rm "$temp_stud_file"
                    elif [ -f "$temp_lect_file" ]; then
                        rm "$temp_lect_file"
                    elif [ -f "$temp_admin_file" ]; then
                        rm "$temp_admin_file"
                    fi            
    fi
}

backup_files(){
                read -r -p "Do you want to back up files to backup server? (yes/no): " confBackup
                theLower=$(echo "$confBackup" | tr [:upper:] [:lower:])
                    if [[ $theLower = "yes" ]]; then
                        cp "$DATA_FILE" backup_server
                        cp "$STUDENT_FILE" backup_server
                        cp "$LECTURER_FILE" backup_server
                        cp "$ADMIN_FILE" backup_server
                        cp main_server/initial_project.sh backup_server
                        echo
                        echo "Backup successful"
                        return
                    else
                        echo "Backup cancelled successfully"
                        return
                    fi     
}
#Examples given, but feel free to use any name, id and password in it_staff.txt. Note: Everything is case sensitive
it_menu(){
        echo "Code 0x07 - Successful." 
        echo "$PROJECT_TITLE software loaded" 
        echo "Data file ready: $DATA_FILE" 
        echo "Tickets logged: $TICKET_COUNT" 
        echo   

read -r -p "Enter your name (Use 'Jessica' for testing): " name
read -r -p "Enter ID number (Use 'IT007654' for testing): " id_worker
read -r -p "Enter password (Use 'JessicaPassword' for testing): " password
echo 
while true; do   
check_name=$(grep -wc "$name" main_server/data/it_staff.txt)
check_worker_id=$(grep -wc "$id_worker" main_server/data/it_staff.txt)
check_password=$(grep -wc "$password" main_server/data/it_staff.txt)
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
            4) change_status ;;
            5) delete_record ;;
            6) add_technician ;;
            7) backup_files ;;
            8) echo "Successfully signed out: $name"; break ;;
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
            *) echo "Invalid, please select an option 1-5" ;; 
esac
done