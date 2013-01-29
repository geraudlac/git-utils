#!/bin/sh

# ------------------------------------------------------
# loading common functions
. common-functions.sh

# ------------------------------------------------------
# functions

function tooManyArguments() {
	echoError NO MORE THAN ONE ARGUMENT!
	exit $ERROR_TOO_MANY_ARGUMENTS
}

function noGitRepoSpecified() {
	echoError YOU MUST SPECIFIY A PROJECT!
	exit $ERROR_MISSING_ARGUMENT
}

function analyzeArguments() {
	case "$#" in
		"0" ) noGitRepoSpecified;;
		"1" ) checkIsGitRepo $1; repo=$1;;
		*   ) tooManyArguments;;
	esac
}

# ======================================================
# Script beginning

# ------------------------------------------------------
# going to user git repositories parent folder
cd $GIT_REPOSITORIES_LOCATION

# ------------------------------------------------------
# Read options and arguments
analyzeArguments $*

# ------------------------------------------------------
# calling 'git rebase' and 'git push' (main part)
echo
echo "**********************************************"
echo "*"
echo "* Rebasing and pushing local \"$GIT_DEV_BRANCH\" branch to \"$GIT_MASTER_BRANCH\" branch for projet \"$1\""
echo "*"
echo "**********************************************"
echo

echoRepo $repo

cd $repo

echoStep Checkout branch \'$GIT_MASTER_BRANCH\'...
git checkout $GIT_MASTER_BRANCH

if [ $? -eq 0 ]; then
	echoStep Rebasing \'$GIT_DEV_BRANCH\'...
	git rebase $GIT_DEV_BRANCH
	if [ $? -eq 0 ]; then
		echoStep Pushing \'$GIT_MASTER_BRANCH\'...
		git push
	else
		echoError Rebasing branch \'$GIT_DEV_BRANCH\' to \'$GIT_MASTER_BRANCH\' failed!
	fi
else
	echoError branch \'$GIT_MASTER_BRANCH\' does not exist!
fi	

echoStep Checkout branch \'$GIT_DEV_BRANCH\'...
git checkout $GIT_DEV_BRANCH
if [ $? -ne 0 ]; then
	echoError Failed to switch back to \'$GIT_DEV_BRANCH\' branch!
fi


echo
echo "*********************"
echo "*                   *"
echo "*  Push completed!  *"
echo "*                   *"
echo "*********************"
echo
