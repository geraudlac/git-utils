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
	echo TODO : print help!!!
	exit 0
}

function tooManyArguments() {
	echo; echo '*** ERROR ***' NO MORE THAN ONE ARGUMENT! '***'
	exit $ERROR_TOO_MANY_ARGUMENTS
}

function setDefaultDevBranch() {
	if [ $1 == "-h" ] || [ $1 == "--help" ]; then
		printHelp
	else
		checkBranchName $1
		GIT_DEFAULT_DEV_BRANCH=$1
		displayDefaultDevBranch
	fi
}

function displayDefaultDevBranch() {
	echo
	echo "****************************************************"
	echo "*"
	echo "* working on \"$GIT_DEFAULT_DEV_BRANCH\" branches by default!"
	echo "*"
	echo "****************************************************"
	echo
}

# ======================================================
# Script beginning

case "$#" in
	"0" ) displayDefaultDevBranch;;
	"1" ) setDefaultDevBranch $1;;
	*   ) tooManyArguments;;
esac

