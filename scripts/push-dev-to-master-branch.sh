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
				*                 ) unknownOption $1 ;;
			esac
		else
			# not an option; store it in repositories to push
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
# calling 'git rebase' and 'git push' (main part)
echo
echo "**********************************************"
echo "*"
echo -e "* Rebasing and pushing local \"\e[1;33m$GIT_DEV_BRANCH\e[0m\" branch(es) to \"\e[1;33m$GIT_MASTER_BRANCH\e[0m\" branch(es)"
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
			echoStep Rebasing \'$GIT_DEV_BRANCH\'...
			git rebase $GIT_DEV_BRANCH
			if [ $? -eq 0 ]; then
				echoStep Pushing \'$GIT_MASTER_BRANCH\'...
				git push
			else
				echoError REBASING BRANCH \'$GIT_DEV_BRANCH\' TO \'$GIT_MASTER_BRANCH\' FAILED!
			fi
		else
			echoError BRANCH \'$GIT_MASTER_BRANCH\' DOES NOT EXIST!
		fi	

		echoStep Checkout branch \'$GIT_DEV_BRANCH\'...
		git checkout $GIT_DEV_BRANCH
		if [ $? -ne 0 ]; then
			echoError FAILED TO SWITCH BACK TO \'$GIT_DEV_BRANCH\' BRANCH!
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
echo "*  Push completed!  *"
echo "*                   *"
echo "*********************"
echo
