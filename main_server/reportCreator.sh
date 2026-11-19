#!/bin/bash

DATA_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/data/records_all.txt"
REPORT_DIR="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/reports" 
REPORT_LOG_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/reports/auto_report_logs.txt" 
TICKET_COUNT=$(wc -l < "$DATA_FILE") 

    creation_date=$(date +%Y-%m-%d)
    report_file="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/reports/$creation_date.txt"
    openTicket=$(grep -c "Open" $DATA_FILE) #Count open tickets within the data file
    in_Progress=$(grep -c "In progress" $DATA_FILE) #Count in progress tickets within the data file

    {
        echo "TICKETS REPORT"
        echo "Generated: $(date)"
        echo "Source: $DATA_FILE"
        echo "Total records: $TICKET_COUNT"
        echo
        cat $DATA_FILE
        echo
        echo
        echo "------------------------------------------------------------------------------------------------------------"
        echo
        echo "All open tickets; Current count: $openTicket"
        echo
        echo "------------------------------------------------------------------------------------------------------------"
        echo
        echo
        grep -v ", In progress," $DATA_FILE
        echo
        echo
        echo "------------------------------------------------------------------------------------------------------------"
        echo
        echo "All tickets in progress; Current count: $in_Progress"
        echo
        echo "------------------------------------------------------------------------------------------------------------"   
        echo
        echo
        grep -v ", Open," $DATA_FILE

} > $report_file

echo "Report for: ${creation_date} created successfully" >> $REPORT_LOG_FILE