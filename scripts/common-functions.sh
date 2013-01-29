#!/bin/sh


# ------------------------------------------------------
# error constants
ERROR_INVALID_GIT_REPO=10

ERROR_BRANCH_DEFINED_TWICE=20
ERROR_INVALID_BRANCH_NAME=21

ERROR_UNKNOWN_OPTION=30
ERROR_MISSING_ARGUMENT=31
ERROR_TOO_MANY_ARGUMENTS=32


# ------------------------------------------------------
# colors definition
#echo -e "\e[0;30;47m Black    \e[0m 0;30m \t\e[1;30;40m Dark Gray  \e[0m 1;30m"
#echo -e "\e[0;31;47m Red      \e[0m 0;31m \t\e[1;31;40m Dark Red   \e[0m 1;31m"
#echo -e "\e[0;32;47m Green    \e[0m 0;32m \t\e[1;32;40m Dark Green \e[0m 1;32m"
#echo -e "\e[0;33;47m Brown    \e[0m 0;33m \t\e[1;33;40m Yellow     \e[0m 1;33m"
#echo -e "\e[0;34;47m Blue     \e[0m 0;34m \t\e[1;34;40m Dark Blue  \e[0m 1;34m"
#echo -e "\e[0;35;47m Magenta  \e[0m 0;35m \t\e[1;35;40m DarkMagenta\e[0m 1;35m"
#echo -e "\e[0;36;47m Cyan     \e[0m 0;36m \t\e[1;36;40m Dark Cyan  \e[0m 1;36m"
#echo -e "\e[0;37;47m LightGray\e[0m 0;37m \t\e[1;37;40m White      \e[0m 1;37m"


# ------------------------------------------------------
# common functions
function echoError() {
	echo; echo -e "*** \e[1;37;41m" $* "\e[0m ***"
}
function echoStep() {
	echo -e " > \e[1;37m"$*"\e[0m"
}

function printHelp() {
	echo TODO : print help for this command!!!
	exit 0
}

function unknownOption() {
	echoError option \'$1\' IS UNKNOWN!
	exit $ERROR_UNKNOWN_OPTION
}

function isGitRepo() {
	[ -d "$1" ] && [ -d "$1/.git" ]
}

function checkIsGitRepo() {
	if ! isGitRepo $1; then
		echoError \'$1\' IS NOT A GIT REPO!
		exit $ERROR_INVALID_GIT_REPO
	fi	
}

function addGitRepo() {
	GIT_REPO[${#GIT_REPO[*]}]=$1
}

function getAllRepositories() {
	for f in *
	do
		if isGitRepo $f; then
			addGitRepo $f
		fi
	done
}

function checkBranchName() {
	git check-ref-format --branch "$1"
	if [ $? -ne 0 ]; then
		echoError \'$1\' IS AN INVALID BRANCH NAME!
		exit $ERROR_INVALID_BRANCH_NAME
	fi
}

# First argument ($1) is the name of the variable where to store the branche name
# Second argument ($2) is the branch name read on command line
function getBranchFromNextArgument() {
	#echo "DEBUG-getBranch: varName = $1"
	#eval echo "DEBUG-getBranch: $1 = "\$$1
	
	eval currentBranchName=\$$1
	if [ -n "$currentBranchName" ]; then
		echoError ONLY ONE BRANCH CAN BE DEFINED!
		exit $ERROR_BRANCH_DEFINED_TWICE
	fi
	
	if [ -z "$2" ]; then
		echoError NO BRANCH SPECIFIED AFTER OPTION \'$1\'
		exit $ERROR_MISSING_ARGUMENT
	fi
	
	checkBranchName $2
	eval $1=$2
	
	#echo "DEBUG-getBranch: varName = $1"
	#eval echo "DEBUG-getBranch: $1 = "\$$1
}

