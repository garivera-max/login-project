#!/bin/bash

# Gabriel Rivera
# CYB 125-Z1
# Fall 2026


LOGFILE="auth.log"
REPORT="security_report.txt"

echo "Linux Security Login Report"
echo "==========================="

# Step 1: Check whether the log file exists
if [ ! -f "$LOGFILE" ]; then
   echo "$LOGFILE does not exist. Make sure it is in the current folder."
   exit 1
fi

# Step 2: Count failed login attempts
count_failed_attempts=$(grep -c "Failed password" $LOGFILE)
echo "Failed logins: $count_failed_attempts" 
echo 

# Step 3: Count successful login attempts
count_successful_attempts=$(grep -c "Accepted password" $LOGFILE)
echo "Successful logins: $count_successful_attempts" 
echo 

# Step 4: Identify IP addresses with failed logins
grep "Failed password" $LOGFILE | awk '{print $NF}' | sort | uniq -c > temp_ips.txt

# Step 5: Generate security alerts
awk '{if ( $1 >= 3) {print $2 " " $1 " ALERT"}}' temp_ips.txt > temp_alerts.txt

echo "Failed Attempts by IP address"
cat temp_alerts.txt
echo

# Step 6: Save the results to a report

echo "Linux Security Login Report" > $REPORT
echo "===========================" >> $REPORT
echo "Failed logins: $count_failed_attempts" >> $REPORT
echo >> $REPORT

echo "Successful logins: $count_successful_attempts" >> $REPORT 
echo >> $REPORT

echo "Failed Attempts by IP address" >> $REPORT
cat temp_alerts.txt >> $REPORT

rm temp_ips.txt
rm temp_alerts.txt



