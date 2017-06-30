## Setup:
	- Install Ruby if it's not available already. Ref: [Install Ruby](https://www.ruby-lang.org/en/documentation/installation/)
	- Tested script on Ruby 2.3.1, Assuming your version of ruby is the same version or above. 
	- Download and place the file locally. Change [permissions](http://linuxcommand.org/lts0070.php) of the script file to be executable. 
	- Run the script as below.
	```
	ruby segment.rb
	```
## Assumptions for simplification:
	- Data in the source file is well formatted and consistent including week name being 3 characters.
	- No empty lines in source file
	- Ruby installation and file permissions are user responsibility. 
	- Time slots in the source file will be within the same day.
	- Exception handling is not fully implemented.
## Usage:
	- Run the script and enter the file name along with full path. If the script is in the same directory as source file, just enter the file name. 
	- Enter DateTime in the same format as it is in the source file
	- The output will show a list of available sdr's.
## Examples:
	- User input for time slot examples. NoteL 
		- wed 10am
		- Thu 11:01PM
		- Mon 14

