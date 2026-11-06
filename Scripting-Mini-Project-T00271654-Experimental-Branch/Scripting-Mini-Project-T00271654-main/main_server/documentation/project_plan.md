# Project Plan
University sets up a new IT support ticket system, this will allow different groups to be split up, such as students and staff, into different priorities depending on what field they are in, or a current problem (i.e. a lecturer during lecture). Allow for managing tickets by IT staff.

Each part of the Ticket system will divert users to their respective areas by selecting from a list of options. If records do not line up, i.e. a student tries to enter their credentials as a lecturer, they will be notified that it won't work. Only allow IT staff to change records, nobody else should be able to make any changes other than logging their issues into the system. If chosen by an IT member with correct credentials, a ticket's status may be updated by displaying "Ticket status changed to resolved" before removing the ticket from the system entirely. IT Staff workers can locate their assigned projects using grep, only if IT Worker is selected and credentials match. This will all be on a mock "Main Server".


Included will also be a variety of report files, such as Errors, or a mock Backup Server section in which all records will be stored for convenience and logging.

## Project title
University IT Service Support - Ticket management system

## Intended user
University students and staff, including lecturers, administration staff and IT staff.

## Problem statement
University needs a ticket management system to enable IT staff to better handle cases, otherwise it extremely affects work flow and problems being solved in an effecient manor. 

## Record structure
Lecturer: Lecturer_ID, Lecturer_Name, Course, Problem_Area (Email, Canvas, etc. = Medium Priority. Accessing computers or labs = High priority), Priority (high if during working hours, allow for option to select that, tickets may be low-medium priority instead), Assigned_IT_staff, Status, SLA_status (hours promised to fix by)

Student: Student_ID, Student_Name, Course, Course_Year (if 4th year, automatically high priority), Problem_Area, Priority, Assigned_IT_staff, Status, SLA_status

Admin: Admin_ID, Admin_Name, Problem_Area, Assigned_IT_staff, Status, SLA_status

IT_Working: If IT_Name == Assigned_IT_staff for a ticket, allow for changes to be made to the tickets, aka changing status or priority of a ticket.

## Unique identifier
example_id will be the unique identifier. E.g. student_id.

## Planned menu
			 After selecting "Student":
"Choose your role: "		"Please enter your details and problem: "
1. Student	   -->	ID:
2. Lecturer	    	Name:
3. Admin			Course:
4. IT Worker		Course Year:
					Problem: (Will be categorized into different priorities based on issue)
			    	(After submission, automated) "Thank you, your ticket has been logged, your priority is $(Priority), we will respond as soon as possible."

## Validation rules
Data file must be found correctly, readable and not empty to not cause an error.
If ID does not match records under a category, e.g. student ID used in lecturer category, output an error and do not proceed with ticket.

## Planned reports
Errors - will store problems within the IT system, such as a failed ticket or downed server.
Warnings - will alert when a report's SLA timer is going to expire.