-- Things Status Reporter 
-- Generates Markdown formatted status reports by Things3 Area
-- 
-- Written by Michael Lines
-- Source code repository at https://github.com/CyberAdvisor/Things-Status-Reporter
-- Please report issues using Github
-- v0.1 - Initial release
--

--
-- Configuration switches (set to your preferences)
--
set the defaultArea to ""
set the defaultDate to (short date string of (current date))
set the defaultPeriod to 7

--
-- Get inputs from the user (area, report duration, week ending date)
-- 
display dialog "Things Status Reporter v0.1" & return & return & "What Area would you like to report on?" default answer defaultArea
set inArea to the text returned of the result
display dialog "Things Status Reporter v0.1" & return & return & "As of what report period end date?" default answer defaultDate
set inWEDateTxt to the text returned of the result
set inWEDate to date inWEDateTxt
display dialog "Things Status Reporter v0.1" & return & return & "Report period duration in days?" default answer defaultPeriod
set inPeriod to the text returned of the result as number
set rptStartDate to inWEDate - ((inPeriod - 1) * days)

--
-- Choose the output file location & open
--
set outputFile to POSIX path of (choose file name default location (path to documents folder from user domain) default name inArea & " " & (short date string of inWEDate) & ".txt")
set statusReportFile to (open for access outputFile with write permission)
set eof of statusReportFile to 0
set cr to ASCII character 10
write "# " & inArea & " Status Report" & return & "### For Period Ending " & (date string of inWEDate) & return & return to statusReportFile as «class utf8»

--
-- Loop through todos for matching items
--
tell application "Things3"
	set tdList to to dos of list "Logbook"
	
	--
	-- Create list of projects in Area > wprList
	--
	set prList to projects
	set wprList to {}
	repeat with pr in prList
		set prName to the name of the area of pr
		if prName = defaultArea then
			copy name of pr to the end of the wprList
		end if
	end repeat
	
	--
	-- Loop through all Area projects for closed items & report
	--
	set lastWP to "" -- Flag to ID project changes
	repeat with i from 1 to number of items in wprList
		set wProject to item i of wprList
		repeat with td in tdList
			set tdDoneIn to completion date of td
			if (tdDoneIn ≥ rptStartDate) and (tdDoneIn ≤ inWEDate) then
				if project of td is not missing value then
					set tdProject to the name of the project of td
					if tdProject is equal to wProject then
						if wProject is not equal to lastWP then -- Check for project changes and print new header
							set lastWP to wProject
							write return & "**" & wProject & "**:" & return to statusReportFile as «class utf8»
						end if
						set tdName to the name of td
						set tdDone to weekday of tdDoneIn -- Adjust as desired to date string or short date string
						write "* " & tdDone & " - " & tdName & return to statusReportFile as «class utf8»
						set tdNotes to the notes of td
						if tdNotes is not "" then
							set fixedNote to my replaceText(cr, " ", tdNotes) -- Strip CRs in notes for formatting
							write "    * " & fixedNote & return to statusReportFile as «class utf8»
						end if
					end if
				end if
			end if
		end repeat
	end repeat
	
end tell

--
-- Close the file
-- 
write return & return & "Produced by Things Status Reporter v0.1 on " & (short date string of (current date)) to statusReportFile as «class utf8»
close access statusReportFile

-- 
-- Subroutine to cleanup notes
--
on replaceText(find, replace, someText)
	set prevTIDs to text item delimiters of AppleScript
	set text item delimiters of AppleScript to find
	set someText to text items of someText
	set text item delimiters of AppleScript to replace
	set someText to "" & someText
	set text item delimiters of AppleScript to prevTIDs
	return someText
end replaceText
