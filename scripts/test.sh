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

function setCurrentBranch() {
	CURRENT_BRANCH=git rev-parse --abbrev-ref HEAD
}

function addBranch() {
	BRANCH[${#BRANCH[*]}]=$1
}

function printBranches() {
	for b in $BRANCH; do
		echo " * "$b
	done
}

function branchExists() {
	# TODO dans $1, transformer les . en \., les * en \* etc...
	# all metacharacters can be found here: http://bashshell.net/regular-expressions/features-of-regular-expressions/
	result=`git branch | grep "^. $1$"`
	[ -n "$result" ]
}

# ======================================================
# Script beginning

if branchExists $1; then
	echo branch \"$1\" exists
else
	echo branch \"$1\" DOES NOT exist
fi

echo ---------------------------

setCurrentBranch
echo "Current branch is \""$CURRENT_BRANCH\"

echo ---------------------------

git branch | addBranch
printBranches

echo ---------------------------

branches=`git branch --list`
echo $branches

echo ---------------------------


