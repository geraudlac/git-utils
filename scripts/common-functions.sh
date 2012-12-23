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
# common functions
function printHelp() {
	echo TODO : print help for this command!!!
	exit 0
}

function unknownOption() {
	echo; echo '*** ERROR ***' option \'$1\' IS UNKNOWN! '***'
	exit $ERROR_UNKNOWN_OPTION
}

function isGitRepo() {
	[ -d "$1" ] && [ -d "$1/.git" ]
}

function checkIsGitRepo() {
	if ! isGitRepo $1; then
		echo; echo '*** ERROR ***' \'$1\' IS NOT A GIT REPO! '***'
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
		echo; echo '*** ERROR ***' \'$1\' IS AN INVALID BRANCH NAME '***'
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
		echo; echo '*** ERROR ***' ONLY ONE BRANCH CAN BE DEFINED! '***'
		exit $ERROR_BRANCH_DEFINED_TWICE
	fi
	
	if [ -z "$2" ]; then
		echo; echo '*** ERROR ***' NO BRANCH SPECIFIED AFTER OPTION \'$1\' '***'
		exit $ERROR_MISSING_ARGUMENT
	fi
	
	checkBranchName $2
	eval $1=$2
	
	#echo "DEBUG-getBranch: varName = $1"
	#eval echo "DEBUG-getBranch: $1 = "\$$1
}

