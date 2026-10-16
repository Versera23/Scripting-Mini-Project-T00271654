#!/bin/bash 
# Project: Community Equipment Register 
# Student: Model Student 
# Student number: K000000 
# Purpose: Validate the project data file and display a startup summary. 
 
PROJECT_TITLE="University IT Support Desk" 
DATA_FILE="main_server/data/records_all.txt" 
REPORT_DIR="reports" 
BACKUP_DIR="backups" 

IT_USER="sample_id"
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
RECORD_COUNT=$(wc -l < "$DATA_FILE") 

echo "Code 0x07 - Successful. Welcome $IT_USER" 
echo "$PROJECT_TITLE software loaded" 
echo "Data file ready: $DATA_FILE" 
echo "Records available: $RECORD_COUNT" 

#HOME MENU
echo "Welcome to the IT Service Desk, please select your role to continue"
echo ""
echo "Please choose your role:"	
echo "------------------------"
echo "1. Student"			
echo "2. Lecturer"
echo "3. Admin"			
echo "4. IT Help"		
echo "5. IT Worker"		

echo ""
#IF STUDENT
echo  "Welcome Student, please enter your information below"
echo "-----------------------------------------------------"
echo "1. Enter Name:"		
echo "2. Enter ID number:"
echo "3. Enter course year:"			
echo "4. Enter problem:"
echo ""
echo "Thank you, your ticket has been logged, your priority is $Priority, we will respond as soon as possible."

#{
# VARIABLES AND ECHOS    
#} >> reports/records_all.txt || >> reports/student_records.txt

echo ""
#IF LECTURER
echo  "Welcome Lecturer, please enter your information below"
echo "-----------------------------------------------------"
echo "1. Enter Name:"		
echo "2. Enter ID number:"
echo "3. Enter course:"			
echo "4. Enter problem:"
echo "5. Is the problem during class time? (y/n):"
echo ""
echo "Thank you, your ticket has been logged, your priority is $Priority, we will respond as soon as possible."

#{
# VARIABLES AND ECHOS    
#} >> reports/records_all.txt || >> reports/lecturer_records.txt

echo ""
#IF ADMIN
echo  "Welcome Admin Staff, please enter your information below"
echo "-----------------------------------------------------"
echo "1. Enter Name:"		
echo "2. Enter ID number:"		
echo "4. Enter problem:"
echo ""
echo "Thank you, your ticket has been logged, your priority is $Priority, we will respond as soon as possible."

#{
# VARIABLES AND ECHOS    
#} >> reports/records_all.txt || >> reports/admin_records.txt

echo ""
#IF IT STAFF PROBLEM
echo  "Welcome IT Staff, please enter your information below"
echo "-----------------------------------------------------"
echo "1. Enter Name:"		
echo "2. Enter ID number:"		
echo "4. Enter problem:"
echo ""
echo "Thank you, your ticket has been logged, your priority is $Priority, we will respond as soon as possible."

#{
# VARIABLES AND ECHOS    
#} >> reports/records_all.txt || >> reports/it_records.txt