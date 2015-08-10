#!/bin/bash

function show {
	echo 'git status'
	git status
	echo 'git --no-pager log '
	git --no-pager log
}

function pause {
	echo '-------------------------------------'
	echo $PAUSE
	if [ $PAUSE -eq '1' ] ; then
		read
	fi

	echo '' ; echo '' ; echo ''
}

# Setup ########################################################################

rm -rf demo
mkdir demo
cd demo

set -o verbose

# Create a central bare repository #############################################
mkdir -p remote.git
cd remote.git
git --bare init
find
pause

# Clone to a local copy ########################################################
cd ..
git clone remote.git local
cd local
find
pause

# Add files to the local copy ##################################################
echo 'This is a test' > file1
echo 'Another test' > file2
git add file1 file2
git commit --message='Initial Commit'
show
pause

# And push to the restore repository ###########################################
git push
pause

# Start a new branch ###########################################################
git checkout -b feature1
git status
pause

# Do stuff and create commits on the branch ####################################
echo 'branch1' > branch1
git add --all
git commit --message='First branch commit'
echo 'branch2' > branch2
git add --all
git commit --message='Second branch commit'

show
pause

# Make another changes #########################################################
echo 'still working on this' > wip
git status
pause

# And then make a Work-in-Progress commit ######################################
# git wip
git add --all $@
git ls-files --deleted -z $@ | xargs -0 git rm
git commit --message='wip'
pause

## Display the branch logs
#git --no-pager log --no-color
#git --no-pager log master --no-color

# Fix the emergency ###########################################################
git checkout master
git checkout -b emergency
echo 'Emergency fix to file1' >> file1
git commit --all --message='Fixed the emergency'
show
pause

# Merge the emergency fix back into master ####################################
git checkout master
git merge emergency
show
pause

# Clean up the emergency branch ################################################
git branch --delete emergency
git status
pause

# Now back to work ############################################################
git checkout feature1
git rebase master
show
pause

# Undo the WIP commit ##########################################################
git reset 'HEAD^' # unwip
git status
pause

# And finish up my last change ################################################
mv wip finished_work
git add finished_work
git commit --message='I finished the feature'
pause

# Oops make a mistake #########################################################
echo 'I done this' > finished_work
git commit --all --message='Fix my message'
pause

# Fix my grammar ##############################################################
echo 'I have done this' > finished_work
git commit --all --message='And also fixing my grammar'
pause

# Yuck #########################################################################
show
pause

# Rebase to clean up ###########################################################
git rebase --interactive master
show

#echo 'And we try doing that slower' > squash_me
#git add squash_me
#git commit --message='Add squash_me file'
#
#echo 'And we try doing that faster' > squash_me
#git commit --all --fixup=a929f46
#
#echo 'This is a file about squashing commits' > squash_me
#git commit --all --fixup=a929f46
#
#git --no-pager log --no-color -u
#
#git rebase --interactive --autosquash master
#
#git --no-pager log --no-color -u
