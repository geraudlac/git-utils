#!/bin/sh

# ------------------------------------------------------
# loading common functions
. common-functions.sh

# ------------------------------------------------------
# functions

function analyzeArguments() {
	while [ -n "$1" ]
	do
		if [[ $1 = "-"* ]]; then
			# verify it is a valid option
			#echo DEBUG: analyze option $1
			case "$1" in
				"-h" | "--help"   ) printHelp ;;
#				"-f" | "--from-branch" ) getBranchFromNextArgument "BRANCH_FROM" $2; shift ;;
#				"-t" | "--to-branch" ) getBranchFromNextArgument "BRANCH_TO" $2; shift ;;
				*                 ) unknownOption $1 ;;
			esac
		else
			# not an option; store it in repositories to update
			#echo DEBUG: analyze argument $1
			checkIsGitRepo $1
			addGitRepo $1
		fi
		shift
	done
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
# by default, check all git repositories
if [ -z $GIT_REPO ]; then
	getAllRepositories
fi

# ------------------------------------------------------
# by default, get default user dev branch and local master branch
if [ -z $BRANCH_TO ]; then
	BRANCH_TO="$GIT_DEV_BRANCH"
fi
if [ -z $BRANCH_FROM ]; then
	BRANCH_FROM="$GIT_MASTER_BRANCH"
fi


#echo DEBUG: Git repositories to check: ${GIT_REPO[*]}
#echo DEBUG: Branch to check: $BRANCH_TO_CHECK

# ------------------------------------------------------
# calling 'git status' (main part)
echo
echo "**********************************************"
echo "*"
echo "* Updating each local \"$BRANCH_TO\" branch from \"$BRANCH_FROM\" branch "
echo "*"
echo "**********************************************"
echo

for repo in ${GIT_REPO[*]}
do
	echoRepo $repo
	cd $repo
	echoStep Checkout branch \'$BRANCH_FROM\'...
	git checkout $BRANCH_FROM
	if [ $? -eq 0 ]; then
		echoStep Pulling...
		git pull
		echoStep Checkout branch \'$BRANCH_TO\'...
		git checkout $BRANCH_TO
		if [ $? -eq 0 ]; then
			echoStep Rebasing...
			git rebase $BRANCH_FROM
			if [ $? -ne 0 ]; then
				echoError Rebasing failed!
			fi
		else
			echoError branch \'$BRANCH_TO\' does not exist!
		fi
	else
		echoError branch \'$BRANCH_FROM\' does not exist!
	fi
	cd ..
	echo
done

echo
echo "*********************"
echo "*                   *"
echo "* Update completed! *"
echo "*                   *"
echo "*********************"
echo
