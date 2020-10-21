# batch copy or moves files based on user input

# variable declarations
$global:filefolder = $null
$global:destinationfolder = $null
$global:exclusionarystring = $null
$global:userstring = $null

function copy-script {
	$recurse = Read-Host "Is this command recursive?"
	Switch($recurse) {
		Yes {recursive-copy}
		yes {recursive-copy}
		No {root-copy}
		no {root-copy}
	}
}

# refers back to declared variables to create a copy command
function root-copy {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to copy files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be copied into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to copy have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:exclusionarystring = Read-Host "If there are files that fit the copy criteria that you do not want copied, please enter the string you would like the script to avoid."
	
	Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:exclusionarystring*")} | Copy-Item -Destination $destinationfolder
	start-script
}

# refers back to declared variables to create a recursive copy command
function recursive-copy {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to copy files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be copied into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to copy have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:exclusionarystring = Read-Host "If there are files that fit the copy criteria that you do not want copied, please enter the string you would like the script to avoid."
	
	Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:exclusionarystring*")} | Copy-Item -Destination $destinationfolder
	start-script
}

function move-script {
	$recurse = Read-Host "Is this command recursive?"
	Switch($recurse) {
		Yes {recursive-move}
		yes {recursive-move}
		No {root-move}
		no {root-move}
	}
}

# refers back to declared variables to create a move command
function root-move {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to move files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be moved into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to move have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:exclusionarystring = Read-Host "If there are files that fit the copy criteria that you do not want moved, please enter the string you would like the script to avoid."
	
	Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:exclusionarystring*")} | Move-Item -Destination $destinationfolder
	start-script
}

# refers back to declared variables to create a recursive move command
function recursive-move {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to move files from. If you are currently in the folder, please type './'."
	$global:destinationfolder = Read-Host "Please enter the path of the folder you would like the files to be moved into. If you are currently in the folder, please type './'"
	$global:userstring = Read-Host "Please enter the string that the files you want to move have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:exclusionarystring = Read-Host "If there are files that fit the copy criteria that you do not want moved, please enter the string you would like the script to avoid."
	
	Get-ChildItem -Recurse -path "$global:filefolder" | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:exclusionarystring*")} | Move-Item -Destination $destinationfolder
	start-script
}

function delete-script {
	$recurse = Read-Host "Is this command recursive?"
	Switch($recurse) {
		Yes {recursive-delete}
		yes {recursive-delete}
		No {root-delete}
		no {root-delete}
	}
}

# refers back to declared variables to create a delete command
function root-delete {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to delete files from. If you are currently in the folder, please type './'."
	$global:userstring = Read-Host "Please enter the string that the files you want to delete have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:exclusionarystring = Read-Host "If there are files that fit the delete criteria that you do not want deleted, please enter the string you would like the script to avoid. Emter a space if there are no file name conflicts."
	
	Get-ChildItem -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:exclusionarystring*")} | rm
	start-script
}

# refers back to declared variables to create a recursive delete command
function recursive-delete {
	$global:filefolder = Read-Host "Please enter the path of the folder you would like to delete files from. If you are currently in the folder, please type './'."
	$global:userstring = Read-Host "Please enter the string that the files you want to delete have in common. This **can** be a file extension. To use a file extension in this field, please type *.[file extension]"
	$global:exclusionarystring = Read-Host "If there are files that fit the delete criteria that you do not want deleted, please enter the string you would like the script to avoid. Enter a space if there are no file name conflicts."
	Get-ChildItem -Recurse -path $global:filefolder | where {($_ -like "*$global:userstring*" -and $_ -notlike "*$global:exclusionarystring*")} | rm
	start-script
}

# user chooses the function to be loaded
# the user specfies a recursive or root scan for the criteria they will enter in the function with the nested read-host command. The functions that get referenced change if the -Recurse flag is included in the final command.
function start-script {
	$choice = Read-Host "Would you like to copy, delete, or move files? If you have no more commands to complete, end the script by pressing Ctrl+C."
	Switch($choice) {
		Copy {copy-script}
		Move {move-script}
		Delete {delete-script}
		copy {copy-script}
		move {move-script}
		delete {delete-script}
	}
}
start-script