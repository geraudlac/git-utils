#!/bin/sh

# ------------------------------------------------------
# loading user settings
. user-settings.sh

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
	exit 0
}

function tooManyArguments() {
	echo; echo '*** ERROR ***' NO MORE THAN ONE ARGUMENT! '***'
	exit $ERROR_TOO_MANY_ARGUMENTS
}

function setGitDevBranch() {
	if [ $1 == "-h" ] || [ $1 == "--help" ]; then
		printHelp
	else
		checkBranchName $1
		export GIT_DEV_BRANCH=$1
		displayGitDevBranch
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
