#######################################################################################
## setACL.ps1                                                                        ##
##                                                                                   ##
## This script is designed to traverse all folders (and subfolders) in a given       ##
## directory and change the access permissions for each object.                      ##
#######################################################################################

## You must set the execution policy to unrestricted before running this script. 
## Manually execute this command before running this script
#Set-ExecutionPolicy Unrestricted

## To schedule this task using windows scheduler, use the following configurations:
##   * Run whether user is logged in or not
##   * Configure for Windows 7 / Server 2008 R2
##   * Actions > Start a Program:
##      - Program: powershell.exe
##      - Arguments: "& 'E:\Scripts\setACL.ps1'" (assuming this is the correct path)

## Define Variables

# Windows domain to pull user from (enter computer name for local users)
$domain = "bobst.lib"

# Path to files in question
$path = "P:\tests\"

# Initialize hash
$user = @{}

# List of users to add permissions to
$user[0] = @{}
$user[0]["name"] = "bs122"
$user[0]["permission"] = "FullControl"

$user[1] = @{}
$user[1]["name"] = "rdf6"
$user[1]["permission"] = "Modify"



## Code execution

$acl = get-acl $path
for ($i = 0; $i -lt $user.count; $i++)
{
	$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule ($user[$i]["name"], $user[$i]["permission"], "ContainerInherit,ObjectInherit", "None", "Allow")
	$acl.AddAccessRule($accessRule)
}
$acl | set-acl $path

exit