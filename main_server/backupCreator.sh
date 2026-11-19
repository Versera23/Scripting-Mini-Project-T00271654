backup_date=$(date '+%Y-%m-%d_%H-%M-%S')

PROJECT_TITLE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/help_desk.sh" 
DATA_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/data/records_all.txt"
STUDENT_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/data/student_records.txt"
LECTURER_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/data/lecturer_records.txt"
ADMIN_FILE="$/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/data/admin_records.txt"
IT_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/data/it_staff.txt"
REPORT_DIR="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/reports"
BACKUP_LOG_FILE="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/main_server/reports/auto_backup_logs.txt" 
BACKUP_DIR="/mnt/f/Users/basti/Pictures/School_stuff/Scripting/Scripting-Mini-Project-T00271654-main/backup_server" 
BACKUP_FILE="$BACKUP_DIR/backup_${backup_date}.tar.gz"

tar -czf "$BACKUP_FILE" "$DATA_FILE" "$STUDENT_FILE" "$LECTURER_FILE" "$ADMIN_FILE" "$IT_FILE" "$PROJECT_TITLE"
echo -n "Backup for: ${backup_date} created successfully" >> $BACKUP_LOG_FILE
                    
