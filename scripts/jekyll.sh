#!/bin/sh
# Launch Jekyll

die ()
{
  echo -e "\e[1;31m$@\e[m"
  exit
}

[ $1 ] || die "Usage: $0 REPO_NAME"

cd /opt/$1

# Run
jekyll --auto --server &
open '.'
open 'http://localhost:4000'