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
#				"-f" | "--from-branch" ) getBranchFromNextArgument "GIT_FROM_BRANCH" $2; shift ;;
#				"-t" | "--to-branch" ) getBranchFromNextArgument "GIT_TO_BRANCH" $2; shift ;;
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


#echo DEBUG: Git repositories to check: ${GIT_REPO[*]}
#echo DEBUG: Branch to check: $GIT_DEV_BRANCH_CHECK

# ------------------------------------------------------
# calling 'git status' (main part)
echo
echo "**********************************************"
echo "*"
echo -e "* Updating each local \"\e[1;33m$GIT_DEV_BRANCH\e[0m\" branch from \"\e[1;33m$GIT_MASTER_BRANCH\e[0m\" branch "
echo "*"
echo "**********************************************"
echo

for repo in ${GIT_REPO[*]}
do
	echoRepo $repo
	cd $repo
	
	if branchExists $GIT_DEV_BRANCH; then
	
		echoStep Checkout branch \'$GIT_MASTER_BRANCH\'...
		git checkout $GIT_MASTER_BRANCH
		if [ $? -eq 0 ]; then
			echoStep Pulling...
			git pull
			echoStep Checkout branch \'$GIT_DEV_BRANCH\'...
			git checkout $GIT_DEV_BRANCH
			if [ $? -eq 0 ]; then
				echoStep Rebasing...
				git rebase $GIT_MASTER_BRANCH
				if [ $? -ne 0 ]; then
					echoError REBASE FAILED!
				fi
			else
				echoError BRANCH \'$GIT_DEV_BRANCH\' DOES NOT EXIST!
			fi
		else
			echoError BRANCH \'$GIT_MASTER_BRANCH\' DOES NOT EXIST!
		fi
	
	else
		echoInfo branch \'$GIT_DEV_BRANCH\' does not exist in $repo! SKIPPING...
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
