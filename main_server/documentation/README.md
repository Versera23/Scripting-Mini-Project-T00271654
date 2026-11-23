# Bash Mini-Project

## Project title
University IT Support Desk
## Student
Adam Fleming - T00271654
## How to run

## MUST RUN FROM THE MAIN DIRECTORY, NOT FROM MAIN SERVER OR BACKUP SERVER DUE TO PATHING, PLEASE FOLLOW EXACT OUTLINES BELOW

## Use ./main_server/help_desk.sh

## To activate cron jobs, which are set currently to activate at midnight while the code is live, type crontab -e to access the cron tasks. Change the two 0's to *, which will activate cron jobs to run every minute. Change back to 0 when done testing to not continue making files, as they would only activate once a day at midnight. * * * * * = minute, hour, day, month, weekday

## Due to cron having extremely limited pathing, nothing but absolute paths to the file guarantee it's full function on varying systems. Using pwd with /main_server/help_desk.sh will break the cron jobs. 

## To insert the cron job code onto your device, type crontab -e and paste in the following: 

----------------------------------------------------------------------------------------------

SHELL=/bin/sh
PATH=/bin:/sbin:/usr/bin:/usr/sbin

#CRON REQUIRED A MAIL SERVER TO WORK, TO SOLVE THE ERROR, SPECIFYING THAT IT DOES NOT MAIL ANYWHERE FIXED THE BUG
MAILTO=""
0 0 * * * (YOUR_PWD)/reportCreator.sh
0 0 * * * (YOUR_PWD)/main_server/backupCreator.sh

-----------------------------------------------------------------------------------------------

## Even with specifying the shell in the script files, it still required it to run, as cron is extremely literal. The path variable defines the basic binary path for cron (standard issue).

## Please replace the paths with your pwd to the launch directory up to  /main_server/.... in both backupCreator.sh & reportCreator.sh for the cron jobs to work as intended. 

## You will only need to do this once, which works very well in a pre-defined network, with only slight changes to the files to make the cron jobs work as intended again.

------------------------------------------------------------------------------------------------------------------------------

## Features Breakdown

1. Student, 2. Lecturer and 3. Admin - Follow the prompts to enter a ticket, if anything is not entered, or ticket does not match format (V00, S00 or A00), ticket will fail. Otherwise, will update both records all and indiviual records, matched by the ID number entered.

5. Exit the software - will safely exit the software and close the application

4. IT Worker - To log into IT Staff, use given examples within the prompts, however, feel free to use any staff id, name and password from it_staff.txt, must match name, password and ID number stored in the IT Worker file, cannot login otherwise.

IN IT MENU ---

1. View All Records - Will display the current records_all file

2. Show your current tickets - Will match the amount of instances of the name of the logged in user has and display them. If none, will display a message confirming that there are no tickets.

3. Search for ticket by ID - Can search for ticket by ID number from records_all and display it. If number is not present, will return an error.

4. Change a ticket's status - Will change a ticket's status from Open -> In Progress with entered ID. Uses temporary file to safely update. Will route copies to respective files with ID prefix.

5. Delete an existing record - Will remove a ticket from records_all and respective file by ID. Uses temporary file to safely delete.

6. Add a new technician to system - Can enter in forename, surname and default password. An ID number will be automatically generated and checked to see if it already exists, if so, will generate another ID number until a non-existing one appears.

7. Reports ---

    1. Create report manually - Will create report named with the current date _manual with all open and in progress tickets. Can only be done once a day.

    2. View all current report files - Will display all files currently in the reports folder

    3. View a particular report - Ties into 2., can search for report by entering in the date as prompted, then will display the record to the screen.

    4. Exit to IT menu - will return to the logged in IT menu.

8. System Backup - Will create a compressed backup of all main files, named with the current date and exact time _manual.   

9. Log out - Will log out of the IT menu, returning back to the initial service desk menu.

## EXTRA

backupCreator.sh and reportCreator.sh use cron jobs to automatically make reports and backups once a day at midnight. Can be seen by running crontab -l in terminal. Creates a confirmation in respective auto_logs files.

## Files

backup_server:
    /backup_server/backup_2026-11-9_19-50-52.tar.gz
    /backup_server/backup_2026-11-10_19-50-52.tar.gz
    /backup_server/backup_2026-11-11_19-50-14.tar.gz
    /backup_server/backup_2026-11-12_17-03-48.tar.gz
    /backup_server/backup_2026-11-17_14-53-01.tar.gz
    /backup_server/backup_2026-11-18_11-58-35_manual.tar.gz
    /backup_server/backup_2026-11-18_12-47-01.tar.gz
    /backup_server/backup_2026-11-19_18-43-01.tar.gz
    

main_server:
    data:
        admin_records.txt
        it_staff_assignment.txt
        it_staff.txt
        lecturer_records.txt
        records_all.txt
        student_records.txt

    documentation:
        AI_USAGE.md
        project_plan.md
        README.md

    reports:
        /main_server/reports/2026-11-9.txt
        /main_server/reports/2026-11-10.txt
        /main_server/reports/2026-11-11.txt
        /main_server/reports/2026-11-12.txt
        /main_server/reports/2026-11-17.txt
        /main_server/reports/2026-11-18_manual.txt
        /main_server/reports/2026-11-18.txt
        main_server/reports/2026-11-19_manual.txt
        main_server/reports/2026-11-19.txt
        /main_server/auto_report_logs.txt
        /main_server/auto_backup_logs.txt

    backupCreator.sh
    help_desk.sh
    reportCreator.sh
