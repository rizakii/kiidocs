#!/bin/sh

# require:
#
#  * find
#  * sed
#  * diff
#  * less

dir1=$1 ; shift
dir2=$1 ; shift

if [ ! -d "$dir1" ] ; then
  echo "Please give directory as dir1"
  exit 1
fi
if [ ! -d "$dir2" ] ; then
  echo "Please give directory as dir2"
  exit 2
fi
if [ ! -d "tmp" ] ; then
  mkdir tmp
fi

list1="tmp/symmetric1.list"
list2="tmp/symmetric2.list"

find "${dir1}" -type f | sed -e "s!^${dir1}!!" > "${list1}"
find "${dir2}" -type f | sed -e "s!^${dir2}!!" > "${list2}"

diff -u "${list1}" "${list2}" | exec less -X
