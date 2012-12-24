#!/bin/sh

# ------------------------------------------------------
# loading user settings
. user-settings.sh

# ------------------------------------------------------
# loading common functions
. common-functions.sh

# ------------------------------------------------------
# functions

function tooManyArguments() {
	echo; echo '*** ERROR ***' NO MORE THAN ONE ARGUMENT! '***'
	exit $ERROR_TOO_MANY_ARGUMENTS
}

function noGitRepoSpecified() {
	echo; echo '*** ERROR ***' YOU MUST SPECIFIY A PROJECT! '***'
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
# working with default branches only for the moment
BRANCH_FROM=$GIT_DEFAULT_DEV_BRANCH
BRANCH_TO=$GIT_DEFAULT_MASTER_BRANCH

# ------------------------------------------------------
# calling 'git rebase' and 'git push' (main part)
echo
echo "**********************************************"
echo "*"
echo "* Rebasing and pushing local \"$BRANCH_FROM\" branch to \"$BRANCH_TO\" branch for projet \"$1\""
echo "*"
echo "**********************************************"
echo

echo === $repo ===
echo -----------------

cd $repo

echo Checkout branch \'$BRANCH_TO\'...
git checkout $BRANCH_TO

if [ $? -eq 0 ]; then
	echo Rebasing \'$BRANCH_FROM\'...
	git rebase $BRANCH_FROM
	if [ $? -eq 0 ]; then
		echo Pushing \'$BRANCH_TO\'...
		git push
	else
		echo; echo "*** ERROR *** Rebasing branch '$BRANCH_FROM' to '$BRANCH_TO' failed! (Push canceled) ***"
	fi
else
	echo; echo '*** ERROR ***' branch \'$BRANCH_TO\' does not exist! '***'
fi	


echo
echo "*********************"
echo "*                   *"
echo "*  Push completed!  *"
echo "*                   *"
echo "*********************"
echo
