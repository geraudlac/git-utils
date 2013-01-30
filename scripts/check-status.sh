#!/bin/sh

# ------------------------------------------------------
# loading common functions
. common-functions.sh

# ------------------------------------------------------
# functions
function printHelp() {
	echo TODO : print help!!!
	exit 0
}

function analyzeArguments() {
	while [ -n "$1" ]
	do
		if [[ $1 = "-"* ]]; then
			# verify it is a valid option
			#echo DEBUG: analyze option $1
			case "$1" in
				"-h" | "--help"   ) printHelp ;;
#				"-b" | "--branch" ) getBranchFromNextArgument "BRANCH_TO_CHECK" $2; shift ;;
				*                 ) unknownOption $1 ;;
			esac
		else
			# not an option; store it in repositories to check
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
# by default, get default user dev branch as branch to check
#if [ -z $BRANCH_TO_CHECK ]; then
#	BRANCH_TO_CHECK="$GIT_DEV_BRANCH"
#fi


#echo DEBUG: Git repositories to check: ${GIT_REPO[*]}
#echo DEBUG: Branch to check: $BRANCH_TO_CHECK

# ------------------------------------------------------
# calling 'git status' (main part)
echo
echo "**********************************************"
echo "*"
echo -e "* Checking status for each local \"\e[1;33m$GIT_DEV_BRANCH\e[0m\" branch"
echo "*"
echo "**********************************************"
echo

for repo in ${GIT_REPO[*]}
do
	echoRepo $repo
	cd $repo
	echoStep checkout branch \'$GIT_DEV_BRANCH\'...
	git checkout $GIT_DEV_BRANCH
	
	if [ $? -eq 0 ]; then
		echoStep git status...
		git status
		echoStep commits to be pushed to \'$GIT_MASTER_BRANCH\' branch:
		git log $GIT_MASTER_BRANCH..$GIT_DEV_BRANCH --oneline --decorate
	else
		echoError branch \'$GIT_DEV_BRANCH\' does not exist!
	fi
			
	cd ..
	echo; echo
done

echo
echo "*******************"
echo "*                 *"
echo "* Status checked! *"
echo "*                 *"
echo "*******************"
echo
