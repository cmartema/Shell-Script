#!/bin/bash

###############################################################################
# Name:                 junk.sh
# Description:   		
###############################################################################

#initializing variable containing the path for the 'junk' directory.
readonly JunkPath="$HOME/junk"

#Initialiazing variable basename to use in here document.
ScriptName="$(basename "$0")"

#function for when no arguments are specefied or if -h is provided using here-document.
HELP_Func() {
	cat << HELPTEXT
Usage: $ScriptName [-hlp] [list of files]
    -h: Display help.
    -l: List junked files.
    -p: Purge all files.
    [list of files] with no other arguments to junk those files.
	
HELPTEXT
}

#
if [ $# -eq 0 ]; then
	HELP_Func
	exit 0
fi

#Using variables as booleans.
list_flag=0
purge_flag=0

#Parses the command line arguments.
while getopts "hlp" option; do
	case "$option" in
		h) 	
			HELP_Func
			exit 0
		       	;;
		l)
			list_flag=1
			;;
		p) 
			purge_flag=1
			;;
		?)
			echo "Error: Unknown option '-$OPTARG'."
			HELP_Func 
			exit 1
			;;
	esac
done

#In case if more than one (valid) flag is specified (Compares two bools).
if [ "$list_flag" == 1 ] && ["$purge_flag" == 1 ]; then
	echo "Error: Too many options enabled."
	HELP_Func
	exit 1
fi

#shifting the arguments (Read Search,sh)
shift "$((OPTIND-1))"

#In case any flags are specified with files (Compares two bools).
#There should be only 1 argument remaining.
if [ "$list_flag" == 1 ] || [ "$purge_flag" == 1 ]; then
	if [ $# -gt 1 ]; then
		echo "Error: Too many options enabled."
		HELP_Func
		exit 1
	fi
fi

#Line of code to check if the 'junk' directory exist. Makes directory if there is not one made.
if [ ! -d "$JunkPath" ]; then
	mkdir "$JunkPath"
fi

for FILE in "$@"; do

	#if the file exists move to junk folder
	if [ -e "$FILE" ]; then

	mv "$FILE" $JunkPath

	#if the file does not exist
	else
		echo "Warning: '$FILE' not found"
	fi
done

exit 0


