use AppleScript version "2.4" -- Yosemite (10.10) or later
use scripting additions
(*
Things Status Reporter
By Michael Lines
mikelines@gmail.com

ABOUT
This script creates a weekly status report for a designated Things area.

HISTORY
- 2020-04-08 - v2.0;  refactored, changed to email output
- 2020-04-09 - v2.0.1;  minor code cleanups, fixed display default bugs
- 2020-04-09 - v2.1;  changed to HTML output for better Outlook formatting and to support inclusion of notes down the road

KNOWN ISSUES
- 

PENDING ENHANCEMENTS
- Add input verification. Allow users to select Area from list, verify input date
- Update to include projects closed in report period
- Update to make period a changeable constant
- Update to add option to print notes for tasks - do after HTML added to allow for indentation. 
*)

-- 
-- Get the report parameters
--
set area_default to "" -- default area to report on in Things
set person_default to "" -- default name of person to use in report title

display dialog "Things Status Reporter " & return & return & "What Things Area would you like to report on?" default answer area_default
set report_area to the text returned of the result

display dialog "Things Status Reporter " & return & return & "What is the 'as of' report date (default today)?" default answer date string of (current date)
set report_date_string to the text returned of the result
set report_date to date report_date_string
set report_end_date_string to date string of ((current date) + (7 * days))
set report_end_date to date report_end_date_string
set report_start_date_string to date string of ((current date) - (7 * days))
set report_start_date to date report_start_date_string

display dialog "Things Status Reporter " & return & return & "Who is this status report for?" default answer person_default
set report_person to the text returned of the result

--
-- Generate the report
--
tell application "Things3"
	--
	-- Get the list of all projects in the report area, skipping complete
	--
	set projects_list to projects
	set report_projects_list to {}
	repeat with selected_project in projects_list
		if area of selected_project is not missing value then
			if name of the area of selected_project = report_area and completion date of selected_project is missing value then
				copy name of selected_project to the end of the report_projects_list
			end if
		end if
	end repeat
	
	--
	-- Get the list of completed tasks
	--
	set done_todos_list to to dos of list "Logbook"
	
	-- 
	-- Print the report header information
	--
	set report_text to "" -- Initialize report
	set report_text to report_text & "Weekly Status Report for " & report_person & "<br>" & "Week Ending " & report_date_string & "<br>"
	
	--
	-- For each project, print the in scope completed and pending tasks
	--
	repeat with i from 1 to number of items in report_projects_list
		--
		-- Print the project header info
		--
		set report_text to report_text & "<br>" & "Project: " & item i of report_projects_list & "<br>"
		
		--
		-- Print the project closed tasks in scope
		--
		set report_text to report_text & "<br><ul>" & "Completed: " & "<br><ul>"
		repeat with done_todo in done_todos_list
			if completion date of done_todo < report_start_date then
				exit repeat
			end if
			if project of done_todo is not missing value then
				if name of the project of done_todo is equal to item i of report_projects_list then -- Check if done todo was for this project
					if (completion date of done_todo ≥ report_start_date) and (completion date of done_todo ≤ report_date + (1 * days)) then
						set report_text to report_text & "<li>" & name of done_todo & "<br>"
					end if
				end if
			end if
		end repeat
		set report_text to report_text & "</ul>"
		
		-- 
		-- Print the project open tasks in scope
		-- 
		set selected_project to item i of report_projects_list
		set open_todos_list to to dos of project selected_project
		set report_text to report_text & "<br>" & "In Progress/Next: " & "<br><ul>"
		repeat with open_todo in open_todos_list
			if activation date of open_todo ≤ report_end_date and activation date of open_todo is not missing value then
				set report_text to report_text & "<li>" & name of open_todo & "<br>"
			end if
		end repeat
		set report_text to report_text & "</ul></ul>"
	end repeat
	set report_text to report_text & "<br>"
end tell

-- 
--  Email the report (will be in drafts folder for final edits before sending)
--
tell application "Microsoft Outlook"
	set email_subject to report_person & " Weekly Status Report for " & "Week Ending " & report_date_string
	set status_email to make new outgoing message with properties {subject:email_subject, content:report_text}
	send status_email
end tell
