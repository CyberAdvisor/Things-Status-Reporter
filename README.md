# Things Status Reporter
A status report generator for Things 3

While Things3 from Cultured Code is a great task manager and planner, it is lacking an easy way to show actual completion of tasks, especially when it is being used in a work context where status reports are required.

I developed this script specifically to address this need for my own use. Please feel free to use and adjust to your specific requirements. By default the status reporting period is a week, but you can adjust as needed in the code. Also, this will report on all completed and open tasks for projects in a specified area. If you want to have reports for multiple areas you will need to run the report repeatedly. You can also set the defaults for area, report date and name of person in the script so you don't have to reenter them everytime. 

For open items, the report will list all open tasks that are marked 'today' or have a set date within the coming week (again this can be adjusted in the code). All other open tasks without dates are not reported on - this allows you to plan future tasks without having them clutter your status report. At the end of the week before running your report, you can select the tasks you want reported by marking them 'today' or assigning them to specific dates in the coming week. 

To use this script, just copy the source code into Apple's Script Editor and adjust the defaults to your preferences if desired. From there you can save it as an AppleScript Application so that it can be put onto the OSX Dock or executied by double clicking when needed. 

Please report issues using the Github issue tab for this project so that I can track and respond to them centrally. Also, if you would like to be notified of new releases or updates, use Github Watch button at the top of this page. 

Enjoy!

Michael Lines

** Revisions

v2.1 2020-04-09 - Changed from plain text to HTML output for better formatting in Outlook
v2. 2020-04-08 - Refactored the code, changed the reporting logic and switched to email (Outlook) vs text file. Removed Markup logic

