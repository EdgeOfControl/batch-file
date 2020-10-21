# batch copy, deletes, or moves files based on user input

# user modifiable variable declarations
$global:filefolder = $null
$global:destinationfolder = $null
$global:userstring = $null
$global:userstring2 = $null
$global:directorycheck = $null
$global:recursivecheck = $null

# refers back to declared variables to create a copy command
function copy-redirect {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to move files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be moved into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to move have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:userstring2 = Read-Host "Please enter a second additional filter. Enter 'skipfilter' to have the script ignore this filter."
	if($global:userstring2 -eq "skipfilter") { # checks if the user entered the skip command
		$global:userstring2 = $null # resets the variable to null for the if statement that sets the filtercheck variable to function properly
	}
	$global:directorycheck = test-path $global:destinationfolder # checks if the directory inputted by the user for the variable $global:destinationfolder exists
	if($false -eq $global:directorycheck) { # if the check returns false, PowerShell notifies and creates the directory for the user before continuing its runtime
		Write-Warning "This directory does not exist. Waiting for user input to create directory."
		pause # this forces the user to acknowledge the folder creation before allowing the script's runtime to continue
		mkdir $global:destinationfolder | Out-Null
		Write-Warning "The script has created the directory specified by the user and will now continue on user input."
		pause # allows the user to have time to read the message PowerShell outputs by forcing them to make an input before continuing runtime.
	}
	if($global:userstring2 -eq $null) { # refers back to the previous if statement checking for the skip command. The only way for this variable to be null at this stage is by the user typing "skipfilter" and the if statement resetting the variable's value
		$filtercheck = "1" # sets the filtercheck variable switch to 1
	}
	elseIf($global:userstring2.GetType().Name -eq "String") {
		$filtercheck = "2" # sets the filtercheck variable switch to 2
	}
	Switch($filtercheck) {
		1 {
			$global:recursivecheck = Read-Host "Is this command recursive?" # asks the user if the search will include subfolders or if the search will only monitor the root of the provided directory
			$operatorcheck = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator." # asks the user to specify inclusive or exclusive filtering
			If($operatorcheck -ilike "*like*") { # switch commands are case sensitive. This if statement is taking a case insensitive look at the answer provided by the user and is ensuring that the answer is in the proper case for the switch command to function.
				$operatorcheck = "like"
			}
			elseIf($operatorcheck -ilike "*notlike*") {
				$operatorcheck = "notlike"
			}
			Switch ($operatorcheck) {
				like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*")} | Copy-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*")} | Copy-Item -Destination $destinationfolder
					}
				}
				notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -notlike "*$global:userstring*")} | Copy-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -notlike "*$global:userstring*")} | Copy-Item -Destination $destinationfolder
					}
				}
			}
		}
		2 {
			$global:recursivecheck = Read-Host "Is this command recursive?"
			$operatorcheckao = Read-Host "Does this command require the use of an and or an or operator? You must type either and/or."
			If($operatorcheckao -ilike "*and*") {
				$operatorcheckao = "and"
			}
			elseIf($operatorcheckao -ilike "*notlike*") {
				$operatorcheckao = "notlike"
			}
			Switch($operatorcheckao) {
				and {
					$operatorchecklnl = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator."
					If($operatorchecklnl -ilike "*like") {
						$operatorchecklnl = "like"
					}
					elseIf($operatorchecklnl -ilike "*notlike*") {
						$operatorchecklnl = "notlike"
					}
					Switch($operatorchecklnl) {
						like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
				}
			}
						notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
				}
			}
		}
				or {
					$operatorchecklnl = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator."
					If($operatorchecklnl -ilike "*like") {
						$operatorchecklnl = "like"
					}
					elseIf($operatorchecklnl -ilike "*notlike*") {
						$operatorchecklnl = "notlike"
					}
					Switch($operatorchecklnl) {
						like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
				}
			}
						notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Copy-Item -Destination $destinationfolder
					}
				}
			}
				}
			}
			function-repeat
		}
	

# refers back to declared variables to create a move command
function move-redirect {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to move files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be moved into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to move have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:userstring2 = Read-Host "Please enter a second additional filter. Enter 'skipfilter' to have the script ignore this filter."
	if($global:userstring2 -eq "skipfilter") { # checks if the user entered the skip command
		$global:userstring2 = $null # resets the variable to null for the if statement that sets the filtercheck variable to function properly
	}
	$global:directorycheck = test-path $global:destinationfolder # checks if the directory inputted by the user for the variable $global:destinationfolder exists
	if($false -eq $global:directorycheck) { # if the check returns false, PowerShell notifies and creates the directory for the user before continuing its runtime
		Write-Warning "This directory does not exist. Waiting for user input to create directory."
		pause # this forces the user to acknowledge the folder creation before allowing the script's runtime to continue
		mkdir $global:destinationfolder | Out-Null
		Write-Warning "The script has created the directory specified by the user and will now continue on user input."
		pause # allows the user to have time to read the message PowerShell outputs by forcing them to make an input before continuing runtime.
	}
	if($global:userstring2 -eq $null) { # refers back to the previous if statement checking for the skip command. The only way for this variable to be null at this stage is by the user typing "skipfilter" and the if statement resetting the variable's value
		$filtercheck = "1" # sets the filtercheck variable switch to 1
	}
	elseIf($global:userstring2.GetType().Name -eq "String") {
		$filtercheck = "2" # sets the filtercheck variable switch to 2
	}
	Switch($filtercheck) {
		1 {
			$global:recursivecheck = Read-Host "Is this command recursive?" # asks the user if the search will include subfolders or if the search will only monitor the root of the provided directory
			$operatorcheck = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator." # asks the user to specify inclusive or exclusive filtering
			If($operatorcheck -ilike "*like*") { # switch commands are case sensitive. This if statement is taking a case insensitive look at the answer provided by the user and is ensuring that the answer is in the proper case for the switch command to function.
				$operatorcheck = "like"
			}
			elseIf($operatorcheck -ilike "*notlike*") {
				$operatorcheck = "notlike"
			}
			Switch ($operatorcheck) {
				like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*")} | Move-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*")} | Move-Item -Destination $destinationfolder
					}
				}
				notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -notlike "*$global:userstring*")} | Move-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -notlike "*$global:userstring*")} | Move-Item -Destination $destinationfolder
					}
				}
			}
		}
		2 {
			$global:recursivecheck = Read-Host "Is this command recursive?"
			$operatorcheckao = Read-Host "Does this command require the use of an and or an or operator?"
			If($operatorcheckao -ilike "*and*") {
				$operatorcheckao = "and"
			}
			elseIf($operatorcheckao -ilike "*notlike*" ){
				$operatorcheckao = "notlike"
			}
			Switch($operatorcheckao) {
				and {
					$operatorchecklnl = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator."
					If($operatorchecklnl -ilike "*like") {
						$operatorchecklnl = "like"
					}
					elseIf($operatorchecklnl -ilike "*notlike*") {
						$operatorchecklnl = "notlike"
					}
					Switch($operatorchecklnl) {
						like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
				}
			}
						notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
				}
			}
		}
				or {
					$operatorchecklnl = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator."
					If($operatorchecklnl -ilike "*like") {
						$operatorchecklnl = "like"
					}
					elseIf($operatorchecklnl -ilike "*notlike*") {
						$operatorchecklnl = "notlike"
					}
					Switch($operatorchecklnl) {
						like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
				}
			}
						notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | Move-Item -Destination $destinationfolder
					}
				}
			}
				}
			}
			function-repeat
		}

# refers back to declared variables to create a delete command
function delete-redirect {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to move files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be moved into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to move have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:userstring2 = Read-Host "Please enter a second additional filter. Enter 'skipfilter' to have the script ignore this filter."
	if($global:userstring2 -eq "skipfilter") { # checks if the user entered the skip command
		$global:userstring2 = $null # resets the variable to null for the if statement that sets the filtercheck variable to function properly
	}
	$global:directorycheck = test-path $global:destinationfolder # checks if the directory inputted by the user for the variable $global:destinationfolder exists
	if($false -eq $global:directorycheck) { # if the check returns false, PowerShell notifies and creates the directory for the user before continuing its runtime
		Write-Warning "This directory does not exist. Waiting for user input to create directory."
		pause # this forces the user to acknowledge the folder creation before allowing the script's runtime to continue
		mkdir $global:destinationfolder | Out-Null
		Write-Warning "The script has created the directory specified by the user and will now continue on user input."
		pause # allows the user to have time to read the message PowerShell outputs by forcing them to make an input before continuing runtime.
	}
	if($global:userstring2 -eq $null) { # refers back to the previous if statement checking for the skip command. The only way for this variable to be null at this stage is by the user typing "skipfilter" and the if statement resetting the variable's value
		$filtercheck = "1" # sets the filtercheck variable switch to 1
	}
	elseIf($global:userstring2.GetType().Name -eq "String") {
		$filtercheck = "2" # sets the filtercheck variable switch to 2
	}
	Switch($filtercheck) {
		1 {
			$global:recursivecheck = Read-Host "Is this command recursive?" # asks the user if the search will include subfolders or if the search will only monitor the root of the provided directory
			$operatorcheck = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator." # asks the user to specify inclusive or exclusive filtering
			If($operatorcheck -ilike "*like*") { # switch commands are case sensitive. This if statement is taking a case insensitive look at the answer provided by the user and is ensuring that the answer is in the proper case for the switch command to function.
				$operatorcheck = "like"
			}
			elseIf($operatorcheck -ilike "*notlike*") {
				$operatorcheck = "notlike"
			}
			Switch ($operatorcheck) {
				like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*")} | rm
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*")} | rm
					}
				}
				notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -notlike "*$global:userstring*")} | rm
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -notlike "*$global:userstring*")} | rm
					}
				}
			}
		}
		2 {
			$global:recursivecheck = Read-Host "Is this command recursive?"
			$operatorcheckao = Read-Host "Does this command require the use of an and or an or operator?"
			If($operatorcheckao -ilike "*and*") {
				$operatorcheckao = "and"
			}
			elseIf($operatorcheckao -ilike "*notlike*") {
				$operatorcheckao = "notlike"
			}
			Switch($operatorcheckao) {
				and {
					$operatorchecklnl = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator."
					If($operatorchecklnl -ilike "*like") {
						$operatorchecklnl = "like"
					}
					elseIf($operatorchecklnl -ilike "*notlike*") {
						$operatorchecklnl = "notlike"
					}
					Switch($operatorchecklnl) {
						like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | rm
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | rm
					}
				}
			}
						notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | rm
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | rm
					}
				}
			}
		}
				or {
					$operatorchecklnl = Read-Host "Does this command require the use of a like or a notlike operator? All commands require the use of a like or a notlike operator."
					If($operatorchecklnl -ilike "*like") {
						$operatorchecklnl = "like"
					}
					elseIf($operatorchecklnl -ilike "*notlike*") {
						$operatorchecklnl = "notlike"
					}
					Switch($operatorchecklnl) {
						like {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | rm
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -like "*$global:userstring2*")} | rm
					}
				}
			}
						notlike {If($global:recursivecheck -ilike "*yes*") {
						Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | rm
					}
					else {
						Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:userstring2*")} | rm
					}
				}
			}
				}
			}
			function-repeat
		}

# user chooses the function to be loaded
# the user specfies a recursive or root scan for the criteria they will enter in the function with the nested read-host command. The functions that get referenced change if the -Recurse flag is included in the final command.
function start-script {
	$choice = Read-Host "Would you like to copy, delete, or move files?"
	If($choice -ilike "*copy*") {
		$choice = "copy"
	}
	elseIf($choice -ilike "*move*") {
		$choice = "move"
	}
	elseIf($choice -ilike "*delete*") {
		$choice = "delete"
	}	
	Switch($choice) {
		copy {copy-redirect}
		move {move-redirect}
		delete {delete-redirect}
	}
}

# a carbon copy of the start-script function that will be referred to **after** a command was previously completed. It adds a line in the Read-Host that tells a new PowerShell user how to end the script.
function function-repeat {
	$choice = Read-Host "Would you like to copy, delete, or move files? If you have no more commands to complete, end the script by pressing Ctrl+C."
	If($choice -ilike "*copy*") {
		$choice = "copy"
	}
	elseIf($choice -ilike "*move*") {
		$choice = "move"
	}
	elseIf($choice -ilike "*delete*") {
		$choice = "delete"
	}
	Switch($choice) {
		copy {copy-redirect}
		move {move-redirect}
		delete {delete-redirect}
	}
}
start-script