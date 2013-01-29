#!/bin/sh

# ------------------------------------------------------
# loading common functions
. common-functions.sh

# ------------------------------------------------------
# functions
function printHelp() {
	echo Usage:
	echo ------
	echo "  workon                  : Displays current branch you're working on"
	echo "  workon <branchName>     : Set <branchName> as current working branch"
# Do not exit any more because this script is executed in the same shell as the window
#	exit 0
}

function tooManyArguments() {
	echo; echo '*** ERROR ***' NO MORE THAN ONE ARGUMENT! '***'
# Do not exit any more because this script is executed in the same shell as the window
#	exit $ERROR_TOO_MANY_ARGUMENTS
}

function setGitDevBranch() {
	if [ $1 == "-h" ] || [ $1 == "--help" ]; then
		printHelp
	else
		git check-ref-format --branch "$1"
		if [ $? -eq 0 ]; then
			export GIT_DEV_BRANCH=$1
			displayGitDevBranch
		else
			echo; echo '*** ERROR ***' \'$1\' IS NOT A VALID BRANCH NAME '***'
			#exit $ERROR_INVALID_BRANCH_NAME
		fi
	fi
}

function displayGitDevBranch() {
	echo
	echo "****************************************************"
	echo "*"
	echo "* Now working on \"$GIT_DEV_BRANCH\" branches!"
	echo "*"
	echo "****************************************************"
	echo
}

# ======================================================
# Script beginning

case "$#" in
	"0" ) displayGitDevBranch;;
	"1" ) setGitDevBranch $1;;
	*   ) tooManyArguments;;
esac
