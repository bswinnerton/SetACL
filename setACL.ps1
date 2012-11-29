#######################################################################################
## setACL.ps1                                                                        ##
##                                                                                   ##
## This script is designed to traverse all folders (and subfolders) in a given       ##
## directory(s) and change the access permissions for each object.                   ##
#######################################################################################

## You must set the execution policy to unrestricted before running this script. 
## Manually execute this command first:
#Set-ExecutionPolicy Unrestricted

## To schedule this task using windows scheduler, use the following configurations:
##   * Run whether user is logged in or not
##   * Configure for Windows 7 / Server 2008 R2 (if appropriate)
##   * Actions > Start a Program:
##      - Program: powershell.exe
##      - Arguments: "& 'E:\Scripts\setACL.ps1'" (assuming this is the correct path)

# Initialize hashes (don't edit)
$path = @{}
$user = @{}

################################ Variable Definitions #################################

# Path to files in question - use trailing slash
#$path[0] = "C:\test\"
#$path[1] = "C:\test2\"

$path[0] = "F:\VENDOR_LOADS\OCLC_EXPORT_REPORTS\"
$path[1] = "F:\VENDOR_LOADS\OCLC_RECORDS_REPORTS\"


# List of user/group(s) to add to ACL- be sure to increment array & initialize hash
#$user[0] = @{}
#$user[0]["name"] = "bs122"
#$user[0]["permission"] = "FullControl"

$user[0] = @{}
$user[0]["name"] = "BOBST\Aleph Vendor Load Share - Full Access"
$user[0]["permission"] = "FullControl"

$user[1] = @{}
$user[1]["name"] = "BOBST\Aleph Vendor Load Share - Read-only Access"
$user[1]["permission"] = "ReadAndExecute"


##################################### Code execution ##################################

for ($i = 0; $i -lt $path.count; $i++)
{
	foreach ($file in Get-ChildItem $path[$i])
	{

		# Get ACL of file
		$acl = get-acl ($path[$i] + $file)
		
		# Get original times
		$lastWriteTime = $file.lastwritetime
		$lastAccessTime = $file.lastaccesstime
		$creationTime = $file.creationtime
		
		
		# Add access rule for each user in above hash
		for ($j = 0; $j -lt $user.count; $j++)
		{
			$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule ($user[$j]["name"], $user[$j]["permission"], "None", "None", "Allow")
			$acl.AddAccessRule($accessRule)
		}
		
		# Set ACL based on access rules
		$acl | set-acl ($path[$i] + $file)
		
		# Set previously stored times so nothing is overwritten
		$file.lastwritetime = $lastWriteTime
		$file.lastaccesstime = $lastAccessTime
		$file.creationtime = $creationTime
		
	}
}

exit